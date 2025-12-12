// Archivo: src/main/java/controlador/ClienteServlet.java
package controlador;

import modelo.DAO.ClienteDAO;
import modelo.Cliente;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/clientes", "/clientes/guardar", "/clientes/eliminar"})
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

    /**
     * Maneja las peticiones GET: 1. /clientes -> Listar todos los clientes. 2.
     * /clientes?action=edit&dni=... -> Cargar datos para el formulario de edición/vista.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String path = request.getServletPath();

        if ("/clientes".equals(path)) {
            if ("edit".equals(action) || "view".equals(action)) {
                // Va a la lógica de cargar datos para el formulario de edición/vista
                mostrarFormularioCliente(request, response, action);
            } else {
                // Si es solo /clientes o /clientes?action=list -> LISTAR
                listarClientes(request, response);
            }
        } else {
            // Caso de fallback, siempre listar
            listarClientes(request, response);
        }
    }

    /**
     * Maneja las peticiones POST: 1. /clientes/guardar -> Guardar (Crear) o
     * Actualizar un cliente. 2. /clientes/eliminar -> Eliminar un cliente.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        String action = request.getParameter("action"); 

        // 1. Manejar la acción de GUARDAR/ACTUALIZAR
        if ("/clientes/guardar".equals(path)) {
            guardarOActualizarCliente(request, response);
        } 
        // 2. Manejar la acción de ELIMINAR
        else if ("/clientes/eliminar".equals(path)) { 
            eliminarCliente(request, response);
        } 
        // 3. Fallback
        else {
            response.sendRedirect(request.getContextPath() + "/clientes");
        }
    }

    // -------------------------------------------------------------------
    // --- Métodos de Lógica de Negocio ---
    // -------------------------------------------------------------------
    private void listarClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Cliente> clientes = clienteDAO.listarClientes();
            System.out.println("Clientes encontrados: " + clientes.size());
            request.setAttribute("listaClientes", clientes);
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al cargar la lista de clientes: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/clientes.jsp").forward(request, response);
    }

    private void mostrarFormularioCliente(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        String dni = request.getParameter("dni");

        if (dni != null && !dni.isEmpty()) {
            Cliente cliente = clienteDAO.obtenerClientePorDni(dni);
            if (cliente != null) {
                request.setAttribute("cliente", cliente);
            } else {
                request.getSession().setAttribute("mensajeError", "Cliente no encontrado con DNI: " + dni);
            }
        }

        request.setAttribute("action", action);
        request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
    }

    // ⭐ MÉTODO UNIFICADO PARA CREAR O ACTUALIZAR ⭐
    private void guardarOActualizarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 0. Obtención de Parámetros
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");

        // Validaciones mínimas
        if (dni == null || dni.isEmpty() || nombres == null || nombres.isEmpty()) {
            request.getSession().setAttribute("mensajeError", "El DNI y Nombres son obligatorios.");
            response.sendRedirect(request.getContextPath() + "/clientes");
            return;
        }

        // Crear y poblar el objeto Cliente
        Cliente cliente = new Cliente();
        cliente.setDni(dni);
        cliente.setNombres(nombres);
        cliente.setApellidos(apellidos);
        cliente.setTelefono(telefono);
        cliente.setCorreo(correo);
        cliente.setDireccion(direccion);

        // 1. Determinar si es UPDATE o CREATE
        boolean existeCliente = clienteDAO.obtenerClientePorDni(dni) != null;

        boolean exito;
        String accionTexto;

        if (existeCliente) {
            // --- CASO 1: ACTUALIZAR ---
            exito = clienteDAO.actualizarCliente(cliente);
            accionTexto = "actualizado";
        } else {
            // --- CASO 2: CREAR (Insertar) ---
            exito = clienteDAO.agregarCliente(cliente);
            accionTexto = "registrado";
        }

        // 2. Manejo de Respuesta (Éxito o Fracaso)
        if (exito) {
            request.getSession().setAttribute("mensajeExito", "Cliente " + accionTexto + " correctamente.");
            response.sendRedirect(request.getContextPath() + "/clientes");
        } else {
            String mensajeError;
            
            if (!existeCliente) {
                // Fallo en la inserción (ej. correo duplicado si es UNIQUE, NOT NULL, o error SQL)
                mensajeError = "Error al registrar el cliente. Verifique que el DNI no esté duplicado o que los datos sean válidos.";
                
                // Re-enviamos el objeto y el error al formulario
                request.setAttribute("cliente", cliente);
                request.setAttribute("error", mensajeError);
                request.setAttribute("action", "create");
                request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
            } else {
                // Fallo en la actualización
                mensajeError = "Error al actualizar el cliente. Verifique los logs del servidor.";
                request.getSession().setAttribute("mensajeError", mensajeError);
                response.sendRedirect(request.getContextPath() + "/clientes");
            }
        }
    }

    private void eliminarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getParameter("dni");

        if (dni != null && !dni.isEmpty()) {
            boolean exito = clienteDAO.eliminarCliente(dni);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cliente eliminado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al eliminar el cliente. Puede tener registros asociados (ej. Proformas).");
            }
        } else {
            request.getSession().setAttribute("mensajeError", "DNI no proporcionado para la eliminación.");
        }

        response.sendRedirect(request.getContextPath() + "/clientes");
    }
}