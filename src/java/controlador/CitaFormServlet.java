/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Cita;
import modelo.CitaDAO;
import modelo.Cliente;
import modelo.ClienteDAO;   // tu DAO existente (package modelo)
import modelo.Empleado;
import modelo.EmpleadoDAO; // si no tienes tabla, devolverá lista vacía

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name="CitaFormServlet", urlPatterns={"/CitaForm"})
public class CitaFormServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private ClienteDAO clienteDAO;
    private EmpleadoDAO empleadoDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        clienteDAO = new ClienteDAO();
        empleadoDAO = new EmpleadoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/CitaServlet?msg=Falta%20id");
            return;
        }

        long id = Long.parseLong(idStr);
        Cita cita = citaDAO.buscarPorId(id);
        if (cita == null) {
            resp.sendRedirect(req.getContextPath() + "/CitaServlet?msg=Cita%20no%20encontrada");
            return;
        }

        // combos
        List<Cliente> clientes = clienteDAO.listar(null);      // usa tu DAO existente
        List<Empleado> empleados = empleadoDAO.listarCombo();  // puede ser vacío

        req.setAttribute("cita", cita);
        req.setAttribute("clientes", clientes);
        req.setAttribute("empleados", empleados);
        req.getRequestDispatcher("/citas-form.jsp").forward(req, resp);
    }
}
