// Archivo: src/main/java/controlador/ClienteServlet.java
package controlador;

import modelo.DAO.ClienteDAO; // Asegúrate que el path sea correcto (modelo.DAO)
import modelo.Cliente;
import java.io.IOException;
import java.util.List;

// Usamos las importaciones de Jakarta (si usas Tomcat 10+ / Jakarta EE)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/clientes", "/clientes/guardar", "/clientes/eliminar"})
public class ClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO();

    /**
     * Maneja las peticiones GET: 1. /clientes -> Listar todos los clientes. 2.
     * /clientes?action=edit&dni=... -> Cargar datos para el formulario de
     * edición.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String path = request.getServletPath();

        if ("/clientes".equals(path)) {
            if ("edit".equals(action) || "view".equals(action)) {
                // Ir a la lógica de cargar datos para el formulario de edición/vista
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
     * Actualizar un cliente. 2. /clientes/eliminar?action=delete -> Eliminar un
     * cliente.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String path = request.getServletPath(); // Obtiene la URL de destino (e.g., /clientes/guardar)
        String action = request.getParameter("action"); // Se usa solo si es necesario para DELETE

        // 1. Manejar la acción de GUARDAR/ACTUALIZAR
        if ("/clientes/guardar".equals(path)) {
            // Llama directamente a la lógica de guardado/actualización
            guardarOActualizarCliente(request, response);
        } // 2. Manejar la acción de ELIMINAR (usando action=delete como parámetro)
        else if ("/clientes/eliminar".equals(path) && "delete".equals(action)) {
            eliminarCliente(request, response);
        } // 3. Fallback
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
            // Manejo de errores de base de datos
            request.getSession().setAttribute("mensajeError", "Error al cargar la lista de clientes: " + e.getMessage());
            e.printStackTrace();
        }

        // Usar FORWARD para que el JSP pueda acceder a 'listaClientes'
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

        // CRÍTICO: Añadir la acción al request para que el JSP la pueda leer
        request.setAttribute("action", action); // Puede ser "edit", "view", o "create" (por defecto)

        // El JSP debe leer si 'cliente' está presente para decidir si es CREATE o EDIT
        request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
    }

    private void guardarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener datos (incluyendo el DNI)
        String dni = request.getParameter("dni");
        // ... (obtener el resto de parámetros y crear el objeto cliente)
        Cliente cliente = new Cliente();
        // ... (setters para nombres, apellidos, etc.)
        cliente.setDni(dni);
        // ...

        // 2. Lógica de validación
        if (clienteDAO.existeClientePorDni(dni)) {
            // CRÍTICO: El DNI ya existe, no se puede registrar.

            String mensajeError = "ERROR: El DNI " + dni + " ya está registrado. Use la opción Editar.";

            // Cargar el objeto cliente en el request para que los campos no se borren
            request.setAttribute("cliente", cliente);
            request.setAttribute("error", mensajeError);
            request.setAttribute("action", "create"); // Sigue en modo crear

            // Volver a cargar el formulario con el mensaje de error
            request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
            return; // Detener la ejecución
        }

        // 3. Si el DNI no existe, se procede al registro (ADD)
        if (clienteDAO.agregarCliente(cliente)) {
            // Éxito: Redirigir a la lista de clientes
            response.sendRedirect(request.getContextPath() + "/clientes?mensaje=Cliente registrado con éxito.");
        } else {
            // Fallo en la inserción por otra razón (ej. error de conexión o SQL)
            request.setAttribute("error", "ERROR: No se pudo registrar el cliente. Revise los logs del servidor.");
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
        }
    }

    private void guardarOActualizarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 0. Configuración y Obtención de Parámetros (igual que antes)
        request.setCharacterEncoding("UTF-8");
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");
        String origen = request.getParameter("origen");
        String nreferencia = request.getParameter("nreferencia");
        String placa = request.getParameter("placa");
        String metodo = request.getParameter("metodo");

        // Validaciones mínimas
        if (dni == null || dni.isEmpty() || nombres == null || nombres.isEmpty()) {
            request.getSession().setAttribute("mensajeError", "El DNI y Nombres son obligatorios.");
            response.sendRedirect(request.getContextPath() + "/clientes");
            return;
        }

        // Crear y poblar el objeto Cliente con todos los datos recibidos
        Cliente cliente = new Cliente();
        cliente.setDni(dni);
        cliente.setNombres(nombres);
        cliente.setApellidos(apellidos);
        cliente.setTelefono(telefono);
        cliente.setCorreo(correo);
        cliente.setDireccion(direccion);
        cliente.setOrigen(origen);
        cliente.setNreferencia(nreferencia);
        cliente.setPlaca(placa);
        cliente.setMetodo(metodo);

        // 1. Determinar si es UPDATE o CREATE (buscando por DNI)
        // Es CRÍTICO usar 'obtenerClientePorDni' para saber si el cliente ya existe en la BD.
        Cliente clienteExistente = clienteDAO.obtenerClientePorDni(dni);

        boolean exito;
        String accionTexto;

        if (clienteExistente != null) {
            // --- CASO 1: ACTUALIZAR (El DNI ya existe) ---
            exito = clienteDAO.actualizarCliente(cliente);
            accionTexto = "actualizado";
        } else {
            // --- CASO 2: CREAR (El DNI no existe, se intenta agregar) ---

            // **OPCIONAL:** Si deseas que el error sea más estricto y no solo por DNI,
            // puedes usar aquí tu lógica de validación de correo duplicado si lo tienes como UNIQUE.
            exito = clienteDAO.agregarCliente(cliente);
            accionTexto = "registrado";
        }

        // 2. Manejo de Respuesta (Éxito o Fracaso)
        if (exito) {
            // Éxito: Redirigir al listado (Patrón PRG)
            request.getSession().setAttribute("mensajeExito", "Cliente " + accionTexto + " correctamente.");
            response.sendRedirect(request.getContextPath() + "/clientes");
        } else {
            // Fracaso: Puede ser por DNI/Correo duplicado, error SQL o error de conexión.

            // Si falló y estamos en modo CREAR (no existía antes), volvemos al formulario con un error.
            // Esto cubre fallos por UNIQUE/NOT NULL en la BD.
            if (clienteExistente == null) {
                String mensajeError = "Error al registrar el cliente. Verifique que el DNI no esté duplicado o que los datos sean válidos.";

                // Re-enviamos el objeto cliente para que los campos del formulario se mantengan llenos.
                request.setAttribute("cliente", cliente);
                request.setAttribute("error", mensajeError);
                request.setAttribute("action", "create");

                // Hacemos FORWARD para mostrar el error en la misma página.
                request.getRequestDispatcher("/cliente-form.jsp").forward(request, response);
            } else {
                // Si falló la ACTUALIZACIÓN, redirigimos con un mensaje de error genérico.
                request.getSession().setAttribute("mensajeError", "Error al actualizar el cliente. Verifique los logs del servidor.");
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
                request.getSession().setAttribute("mensajeError", "Error al eliminar el cliente. Puede tener registros asociados.");
            }
        } else {
            request.getSession().setAttribute("mensajeError", "DNI no proporcionado para la eliminación.");
        }

        // Redirigir al listado principal
        response.sendRedirect(request.getContextPath() + "/clientes");
    }
}
