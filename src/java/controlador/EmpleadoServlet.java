// Archivo: src/main/java/controlador/EmpleadoServlet.java
package controlador;

import modelo.DAO.EmpleadoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Empleado;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

// ⚡ CORRECCIÓN AQUÍ: Se añade la URL /empleados/cambiarEstado ⚡
@WebServlet(name = "EmpleadoServlet", urlPatterns = {"/empleados", "/empleados/guardar", "/empleados/eliminar", "/empleados/cambiarEstado"})
public class EmpleadoServlet extends HttpServlet {

    private final EmpleadoDAO empleadoDAO;
    private final String LISTA_JSP = "/empleados.jsp";

    public EmpleadoServlet() {
        this.empleadoDAO = new EmpleadoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener la lista de empleados para la tabla
        List<Empleado> listaEmpleados = empleadoDAO.listarTodos();
        request.setAttribute("listaEmpleados", listaEmpleados);

        // 2. Redireccionar al JSP principal que contendrá la tabla y los modales.
        request.getRequestDispatcher(LISTA_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // Usamos el path del servlet para determinar la acción
        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();

        if (servletPath.equals("/empleados/guardar")) {
            insertOrUpdateEmpleado(request, response, session);
            // ⚡ CORRECCIÓN AQUÍ: Ahora se acepta la ruta /empleados/cambiarEstado para esta lógica ⚡
        } else if (servletPath.equals("/empleados/eliminar") || servletPath.equals("/empleados/cambiarEstado")) {
            toggleEstadoEmpleado(request, response, session);
        } else {
            // Manejo por defecto (ej. si alguien hace POST a /empleados)
            response.sendRedirect(request.getContextPath() + "/empleados");
        }
    }

    // --- Métodos de Acción ---
    private void insertOrUpdateEmpleado(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        // Parámetros del formulario
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String cargo = request.getParameter("cargo");
        String fechaContratacionStr = request.getParameter("fecha_contratacion");
        String salarioStr = request.getParameter("salario");

        String mensaje;
        boolean operacionExitosa = false;

        try {
            Date fechaContratacion = Date.valueOf(fechaContratacionStr);
            double salario = Double.parseDouble(salarioStr);

            // Saber si es edición mediante campo oculto
            String dniEdit = request.getParameter("dni_edit");
            boolean esEdicion = dniEdit != null;

            // Usamos el DNI del formulario, que no debería cambiar en la edición
            Empleado existente = empleadoDAO.obtenerPorDni(dni);

            if (esEdicion && existente == null) {
                // ❌ Intento de editar un empleado que no existe
                session.setAttribute("mensajeError", "No se encontró el empleado con DNI " + dni + " para actualizar.");
                response.sendRedirect(request.getContextPath() + "/empleados");
                return;
            }

            // Conservar estado actual si existe
            boolean estado = (existente != null) ? existente.isEstado() : true;

            Empleado emp = new Empleado(dni, nombres, apellidos, telefono, email, fechaContratacion, cargo, salario, estado);

            if (esEdicion) {
                // UPDATE
                operacionExitosa = empleadoDAO.actualizar(emp);
                mensaje = operacionExitosa
                        ? "Empleado '" + nombres + " " + apellidos + "' actualizado correctamente."
                        : "Error al actualizar el empleado.";
            } else {
                // INSERT
                if (existente != null) {
                    // DNI duplicado
                    session.setAttribute("mensajeError", "El DNI '" + dni + "' ya está registrado.");
                    response.sendRedirect(request.getContextPath() + "/empleados");
                    return;
                }

                operacionExitosa = empleadoDAO.insertar(emp);
                mensaje = operacionExitosa
                        ? "Empleado '" + nombres + " " + apellidos + "' registrado correctamente."
                        : "Error al registrar el empleado, Intenta usar otro e-mail.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            mensaje = "Error en el formato de datos: " + e.getMessage();
            operacionExitosa = false;
        }

        if (operacionExitosa) {
            session.setAttribute("mensajeExito", mensaje);
        } else {
            session.setAttribute("mensajeError", mensaje);
        }

        response.sendRedirect(request.getContextPath() + "/empleados");
    }

    private void toggleEstadoEmpleado(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        request.setCharacterEncoding("UTF-8"); // Asegurar codificación para parámetros
        String dni = request.getParameter("dni");
        String nombreCompleto = request.getParameter("nombre_completo");
        String mensaje = null;

        // 1. Obtener el empleado actual para conocer su estado
        Empleado empleado = empleadoDAO.obtenerPorDni(dni);

        if (empleado != null) {
            // 2. Invertir el estado
            boolean nuevoEstado = !empleado.isEstado();

            // 3. Establecer el nuevo estado en el objeto
            empleado.setEstado(nuevoEstado);

            // 4. Llamar al DAO para la actualización
            // Asumiendo que empleadoDAO.actualizar() actualiza todos los campos, incluido el estado
            boolean operacionExitosa = empleadoDAO.actualizar(empleado);

            if (operacionExitosa) {
                String estadoStr = nuevoEstado ? "ACTIVADO" : "DESACTIVADO";
                mensaje = "Empleado '" + (nombreCompleto != null ? nombreCompleto : "desconocido") + "' (" + dni + ") ha sido " + estadoStr + " con éxito.";
                session.setAttribute("mensajeExito", mensaje);
            } else {
                mensaje = "Error al cambiar el estado del empleado '" + (nombreCompleto != null ? nombreCompleto : "desconocido") + "' (" + dni + ").";
                session.setAttribute("mensajeError", mensaje);
            }

        } else {
            mensaje = "Error: No se encontró el empleado con DNI " + dni + ".";
            session.setAttribute("mensajeError", mensaje);
        }

        response.sendRedirect(request.getContextPath() + "/empleados");
    }
}
