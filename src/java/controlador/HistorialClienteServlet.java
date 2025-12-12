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

@WebServlet(name = "HistorialClienteServlet", urlPatterns = {"/clientes/historial"})
public class HistorialClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json");

        // Filtros desde tu UI: tomamos solo el nombre (texto libre) y opcionalmente DNI
        String nombre = trim(req.getParameter("nombre"));
        String dni    = trim(req.getParameter("dni"));

        // Usamos el listar(q) que ya existe en tu ClienteDAO (busca por LIKE + FULLTEXT si aplica)
        String q = (dni != null && !dni.isBlank())
                ? dni
                : nombre;

        List<Cliente> lista = dao.listar(q);

        // Armamos JSON con el formato que tu render usa
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < lista.size(); i++) {
            Cliente c = lista.get(i);
            String nombreCompleto = (nullToEmpty(c.getNombre()) + " " + nullToEmpty(c.getApellido())).trim();

            json.append("{")
                .append("\"id\":").append(quote(c.getDni())).append(",")  // id = dni (para tus links 👁 ✏ 🗑)
                .append("\"nombre\":").append(quote(nombreCompleto)).append(",")
                .append("\"origen\":").append(quote("—")).append(",")     // no existe en tabla clientes
                .append("\"ref\":").append(quote("—")).append(",")
                .append("\"placa\":").append(quote("—")).append(",")
                .append("\"fecha\":").append(quote("—")).append(",")
                .append("\"monto\":").append(0).append(",")               // 0 para mantener formato S/ 0.00
                .append("\"metodo\":").append(quote("—"))
                .append("}");
            if (i < lista.size() - 1) json.append(",");
        }
        json.append("]");

        resp.getWriter().write(json.toString());
    }

    private String trim(String s){ return s == null ? "" : s.trim(); }
    private String nullToEmpty(String s){ return s == null ? "" : s; }

    private String quote(String s){
        if (s == null) return "null";
        String v = s.replace("\\", "\\\\").replace("\"", "\\\"");
        return "\"" + v + "\"";
    }
}
