/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.*;
import util.CalendarioMes;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

@WebServlet(name="CitaServlet", urlPatterns={"/CitaServlet","/citas"})
public class CitaServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private ClienteDAO clienteDAO;  // <- el tuyo (package modelo)
    private EmpleadoDAO empleadoDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        clienteDAO = new ClienteDAO();
        empleadoDAO = new EmpleadoDAO(); // no rompe si no hay tabla
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());

        LocalDate hoy = LocalDate.now();
        int anio = parseInt(req.getParameter("anio"), hoy.getYear());
        int mes  = parseInt(req.getParameter("mes"),  hoy.getMonthValue());

        LocalDate ini = LocalDate.of(anio, mes, 1);
        LocalDate fin = ini.withDayOfMonth(ini.lengthOfMonth());

        List<Cita> citas = citaDAO.listarPorRango(ini, fin);
        List<Cliente> clientes = clienteDAO.listar(null);   // <- usa tu DAO existente
        List<Empleado> empleados = empleadoDAO.listarCombo();

        Map<String,Object> cal = CalendarioMes.armar(anio, mes, citas);
        req.setAttribute("anio", cal.get("anio"));
        req.setAttribute("mesNombre", cal.get("mesNombre"));
        req.setAttribute("semanas", cal.get("semanas"));
        req.setAttribute("clientes", clientes);
        req.setAttribute("empleados", empleados);

        // Navegación de meses
        int mesPrev = (mes == 1) ? 12 : mes-1;
        int anioPrev = (mes == 1) ? anio-1 : anio;
        int mesNext = (mes == 12) ? 1 : mes+1;
        int anioNext = (mes == 12) ? anio+1 : anio;
        req.setAttribute("mesPrev", mesPrev);
        req.setAttribute("anioPrev", anioPrev);
        req.setAttribute("mesNext", mesNext);
        req.setAttribute("anioNext", anioNext);

        req.getRequestDispatcher("/citas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String action = p(req,"action"); // create | cancel | confirm | update

        boolean ok = false;
        String fechaParam = req.getParameter("fecha"); // para redirigir al mes correcto al final

        switch (action) {
            case "create" -> {
                Cita c = new Cita();
                c.setIdCliente(p(req,"idCliente")); // DNI
                c.setFecha(LocalDate.parse(p(req,"fecha")));
                c.setHora(LocalTime.parse(p(req,"hora")));
                c.setTipo(p(req,"tipo"));
                c.setNotas(p(req,"notas"));
                String idEmp = p(req,"idEmpleado");
                c.setIdEmpleado(idEmp.isBlank() ? null : Integer.valueOf(idEmp));
                c.setEstado("PENDIENTE");
                ok = citaDAO.crear(c);
            }
            case "cancel" -> {
                long id = Long.parseLong(p(req,"id"));
                ok = citaDAO.cancelar(id);
            }
            case "confirm" -> {
                long id = Long.parseLong(p(req,"id"));
                ok = citaDAO.confirmar(id);
            }
            case "update" -> {
                Cita c = new Cita();
                c.setId(Long.parseLong(p(req,"id")));
                c.setIdCliente(p(req,"idCliente"));
                c.setFecha(LocalDate.parse(p(req,"fecha")));
                c.setHora(LocalTime.parse(p(req,"hora")));
                c.setTipo(p(req,"tipo"));
                c.setNotas(p(req,"notas"));
                String idEmp = p(req,"idEmpleado");
                c.setIdEmpleado(idEmp.isBlank()? null : Integer.valueOf(idEmp));
                ok = citaDAO.actualizar(c);
            }
            default -> {}
        }

        String redir = req.getContextPath()+"/CitaServlet";
        if (fechaParam != null && !fechaParam.isBlank()) {
            LocalDate d = LocalDate.parse(fechaParam);
            redir += "?anio="+d.getYear()+"&mes="+d.getMonthValue()+"&msg="+(ok?"OK":"ERROR");
        } else {
            redir += "?msg="+(ok?"OK":"ERROR");
        }
        resp.sendRedirect(redir);
    }

    private static int parseInt(String s, int def) { try { return (s==null||s.isBlank())?def:Integer.parseInt(s); } catch(Exception e){return def;} }
    private static String p(HttpServletRequest r, String n){ String v=r.getParameter(n); return v==null? "": v.trim(); }
}
