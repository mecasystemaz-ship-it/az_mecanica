/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import modelo.Servicio;
import modelo.ServicioDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet(name="ServicioServlet", urlPatterns={"/servicios"})
public class ServicioServlet extends HttpServlet {

    private final ServicioDAO dao = new ServicioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = val(req.getParameter("accion"), "listar");
        try {
            switch (accion) {
                case "nuevo":
                    req.setAttribute("servicio", new Servicio());
                    req.getRequestDispatcher("/servicios.jsp").forward(req, resp);
                    break;
                case "editar": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("servicio", dao.buscarPorId(id));
                    req.getRequestDispatcher("/servicios.jsp").forward(req, resp);
                    break;
                }
                case "eliminar": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.eliminar(id);
                    resp.sendRedirect(req.getContextPath()+"/servicios?accion=listar&msg=Eliminado");
                    break;
                }
                case "listar":
                default: {
                    String q = req.getParameter("q");
                    List<Servicio> lista = dao.listar(q);
                    req.setAttribute("lista", lista);
                    req.getRequestDispatcher("/servicios.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/servicios.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        Servicio s = new Servicio();
        try {
            if (idStr != null && !idStr.isBlank()) s.setId(Integer.parseInt(idStr));
            s.setTitulo(val(req.getParameter("titulo"), ""));
            s.setTipo(val(req.getParameter("tipo"), "Mantenimiento"));
            s.setDniCliente(val(req.getParameter("dni_cliente"), ""));
            s.setPlacaVehiculo(val(req.getParameter("placa_vehiculo"), ""));
            s.setOrigen(val(req.getParameter("origen"), ""));
            s.setNumeroRef(emptyToNull(req.getParameter("numero_ref")));
            String fechaStr = val(req.getParameter("fecha"), "");
            s.setFecha(fechaStr.isBlank() ? null : Date.valueOf(fechaStr));
            String totalStr = val(req.getParameter("monto_total"), "0");
            try { s.setMontoTotal(new BigDecimal(totalStr)); } catch (Exception ex) { s.setMontoTotal(new BigDecimal("0.00")); }
            s.setMetodoPago(val(req.getParameter("metodo_pago"), ""));
            s.setEstado(val(req.getParameter("estado"), "Pendiente"));
            s.setObservaciones(val(req.getParameter("observaciones"), ""));

            boolean ok;
            if (s.getId() == null) {
                ok = dao.insertar(s);
                if (ok) resp.sendRedirect(req.getContextPath()+"/servicios?accion=editar&id="+s.getId()+"&msg=Creado");
                else   resp.sendRedirect(req.getContextPath()+"/servicios?accion=listar&msg=No+se+pudo+crear");
            } else {
                ok = dao.actualizar(s);
                if (ok) resp.sendRedirect(req.getContextPath()+"/servicios?accion=editar&id="+s.getId()+"&msg=Actualizado");
                else   resp.sendRedirect(req.getContextPath()+"/servicios?accion=editar&id="+s.getId()+"&msg=No+se+pudo+actualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.setAttribute("servicio", s);
            req.getRequestDispatcher("/servicios.jsp").forward(req, resp);
        }
    }

    private String val(String v, String def){ return (v==null)?def:v; }
    private String emptyToNull(String v){ return (v==null || v.isBlank())? null : v.trim(); }
}
