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
import modelo.Cliente;
import modelo.ClienteDAO;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/clientes"})
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String action = param(req, "action");
        String q = param(req, "q");

        try {
            switch (action) {
                case "editar": {
                    String dni = param(req, "dni");
                    Cliente c = dao.buscarPorDni(dni);
                    if (c == null) {
                        req.setAttribute("error", "No se encontró el cliente con DNI " + dni);
                        resp.sendRedirect(req.getContextPath() + "/clientes");
                        return;
                    }
                    req.setAttribute("cliente", c);
                    req.getRequestDispatcher("cliente-form.jsp").forward(req, resp);
                    break;
                }
                case "eliminar": {
                    String dni = param(req, "dni");
                    boolean ok = dao.eliminar(dni);
                    if (!ok) {
                        req.setAttribute("error", "No se pudo eliminar el cliente (revise dependencias).");
                    }
                    resp.sendRedirect(req.getContextPath() + "/clientes");
                    break;
                }
                default: {
                    List<Cliente> clientes = dao.listar(q);
                    req.setAttribute("lista", clientes);
                    req.setAttribute("q", q);
                    req.getRequestDispatcher("clientes.jsp").forward(req, resp);
                }
                case "historial": {
                    // Filtros opcionales (por ahora usamos 'nombre'; los demás se pueden usar luego)
                    String nombre = param(req, "nombre");   // texto libre
                    String origen = param(req, "origen");   // Orden/Proforma/Web (placeholder)
                    String desde = param(req, "desde");    // yyyy-MM-dd
                    String hasta = param(req, "hasta");    // yyyy-MM-dd

                    // Traemos lista desde DAO
                    var items = new modelo.ClienteDAO().listarHistorial(nombre, origen, desde, hasta);

                    // Devolver JSON
                    resp.setContentType("application/json; charset=UTF-8");
                    StringBuilder sb = new StringBuilder();
                    sb.append("[");
                    for (int i = 0; i < items.size(); i++) {
                        var r = items.get(i);
                        sb.append("{")
                                .append("\"id\":").append(r.getId()).append(",")
                                .append("\"nombre\":\"").append(escapeJson(r.getNombre())).append("\",")
                                .append("\"origen\":\"").append(escapeJson(r.getOrigen())).append("\",")
                                .append("\"ref\":\"").append(escapeJson(r.getRef())).append("\",")
                                .append("\"placa\":\"").append(escapeJson(r.getPlaca())).append("\",")
                                .append("\"fecha\":\"").append(escapeJson(r.getFecha())).append("\",")
                                .append("\"monto\":").append(r.getMonto()).append(",")
                                .append("\"metodo\":\"").append(escapeJson(r.getMetodo())).append("\"")
                                .append("}");
                        if (i < items.size() - 1) {
                            sb.append(",");
                        }
                    }
                    sb.append("]");
                    resp.getWriter().write(sb.toString());
                    return; // IMPORTANTE: cortar el flujo aquí
                }

            }
        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Error: " + ex.getMessage());
            req.getRequestDispatcher("clientes.jsp").forward(req, resp);
        }
    }
    
    private static String escapeJson(String s) {
    if (s == null) return "";
    return s.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r");
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String action = param(req, "action");

        if ("guardar".equals(action)) {
            Cliente c = new Cliente(
                    param(req, "dni"),
                    param(req, "nombre"),
                    param(req, "apellido"),
                    param(req, "telefono"),
                    param(req, "email"),
                    param(req, "direccion")
            );

            boolean ok = dao.existe(c.getDni()) ? dao.actualizar(c) : dao.insertar(c);
            if (!ok) {
                req.setAttribute("error", "No se pudo guardar el cliente.");
                req.setAttribute("cliente", c);
                req.getRequestDispatcher("cliente-form.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/clientes");
            return;
        }

        // Si no se especifica action, vuelve al listado
        resp.sendRedirect(req.getContextPath() + "/clientes");
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }
}
