/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import modelo.Vehiculo;
import modelo.VehiculoDAO;

@WebServlet(name = "VehiculoServlet", urlPatterns = {"/vehiculos"})
public class VehiculoServlet extends HttpServlet {

    private VehiculoDAO dao;

    @Override
    public void init() throws ServletException {
        super.init();
        dao = new VehiculoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String accion = param(req, "accion"); // listar (default) | nuevo | editar | eliminar | buscar
        switch (accion) {
            case "nuevo" -> {
                req.setAttribute("vehiculo", new Vehiculo());
                req.setAttribute("modo", "crear");
                req.getRequestDispatcher("/vehiculo-form.jsp").forward(req, resp);
            }
            case "editar" -> {
                String placa = param(req, "placa");
                Vehiculo v = dao.buscarPorPlaca(placa);
                if (v == null) {
                    resp.sendRedirect(req.getContextPath() + "/vehiculos?msg=No%20existe%20vehiculo");
                    return;
                }
                req.setAttribute("vehiculo", v);
                req.setAttribute("modo", "editar");
                req.getRequestDispatcher("/vehiculo-form.jsp").forward(req, resp);
            }
            case "eliminar" -> {
                String placa = param(req, "placa");
                dao.eliminar(placa);
                resp.sendRedirect(req.getContextPath() + "/vehiculos?msg=Eliminado");
            }
            case "buscar" -> {
                String q = param(req, "q");
                List<Vehiculo> lista = dao.listar(q);
                req.setAttribute("lista", lista);
                req.setAttribute("q", q);
                req.getRequestDispatcher("/vehiculos.jsp").forward(req, resp);
            }
            default -> { // listar
                String q = param(req, "q");
                List<Vehiculo> lista = dao.listar(q);
                req.setAttribute("lista", lista);
                req.setAttribute("q", q == null ? "" : q);
                req.getRequestDispatcher("/vehiculos.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String modo = param(req, "modo"); // crear | editar

        Vehiculo v = new Vehiculo();
        v.setPlaca(param(req, "placa"));
        v.setMarca(param(req, "marca"));
        v.setTipo(param(req, "tipo"));
        v.setModelo(param(req, "modelo"));
        v.setAnio(toInt(param(req, "anio")));
        v.setColor(param(req, "color"));
        v.setCombustible(param(req, "combustible"));
        v.setNumMotor(param(req, "num_motor"));                 // <- ojo: nombre del input
        v.setKilometraje(toInt(param(req, "kilometraje")));
        v.setSoat(param(req, "soat"));
        v.setTarjetaPropietario(param(req, "tarjeta_propietario"));
        v.setDniCliente(param(req, "dni_cliente"));

        boolean ok;
        if ("editar".equalsIgnoreCase(modo)) {
            ok = dao.actualizar(v);
        } else {
            ok = dao.insertar(v);
        }

        String msg = ok ? "OK" : "ERROR";
        resp.sendRedirect(req.getContextPath() + "/vehiculos?msg=" + msg);
    }

    /* ==== helpers ==== */
    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }
    private Integer toInt(String s) {
        try { return (s == null || s.isBlank()) ? null : Integer.parseInt(s); }
        catch (NumberFormatException e) { return null; }
    }
}
