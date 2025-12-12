// Archivo: src/main/java/controlador/ServicioServlet.java
package controlador;

import modelo.DAO.ServicioDAO;
import modelo.Servicio;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ServicioServlet", urlPatterns = {"/servicios.jsp", "/servicios/guardar", "/servicios/eliminar"})
public class ServicioServlet extends HttpServlet {

    private ServicioDAO servicioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        servicioDAO = new ServicioDAO();
    }

    // Maneja listado y edición (carga)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            listarServicios(request, response);
        } else {
            // CRÍTICO: Eliminar la lógica obsoleta de 'edit' y 'view'
            // Ya no necesitas cargar un servicio en el request y redirigir a otro JSP.
            // La edición se maneja completamente con JavaScript en servicios.jsp.
            listarServicios(request, response);
        }
    }

    // Maneja la creación, actualización y eliminación
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if (path.equals("/servicios/guardar")) {
            guardarOActualizarServicio(request, response);
        } else if (path.equals("/servicios/eliminar")) {
            eliminarServicio(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida.");
        }
    }

    private void listarServicios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener la lista de la base de datos
        List<Servicio> listaServicios = servicioDAO.listarServicios();

        // 2. Establecer el atributo en el request
        request.setAttribute("listaServicios", listaServicios);

        // 3. Redirigir la ejecución al JSP
        request.getRequestDispatcher("/servicios.jsp").forward(request, response);
    }

    // *** ELIMINADA: La función mostrarFormularioServicio ya no es necesaria ***

    private void guardarOActualizarServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lógica de obtención de parámetros...
        String idParam = request.getParameter("id_servicio");
        String nombre = request.getParameter("nombre");
        String categoria = request.getParameter("categoria");
        String descripcion = request.getParameter("descripcion");
        String precioParam = request.getParameter("precio");
        String tiempoEstimado = request.getParameter("tiempo_estimado");

        Servicio servicio = new Servicio();

        // Si hay ID, estamos en modo Actualizar
        if (idParam != null && !idParam.isEmpty()) {
            servicio.setIdServicio(Integer.parseInt(idParam));
        }

        // Validación y parseo de campos
        if (nombre == null || nombre.isEmpty() || precioParam == null || precioParam.isEmpty()) {
            request.getSession().setAttribute("mensajeError", "Nombre y Precio son obligatorios.");
            response.sendRedirect(request.getContextPath() + "/servicios");
            return;
        }

        try {
            servicio.setNombre(nombre);
            servicio.setCategoria(categoria);
            servicio.setDescripcion(descripcion);
            servicio.setPrecio(new BigDecimal(precioParam)); // Convertir String a BigDecimal
            servicio.setTiempoEstimado(tiempoEstimado);

            boolean exito;
            String mensaje;

            if (servicio.getIdServicio() > 0) {
                exito = servicioDAO.actualizarServicio(servicio);
                mensaje = "actualizado";
            } else {
                exito = servicioDAO.agregarServicio(servicio);
                mensaje = "registrado";
            }

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Servicio " + mensaje + " correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al guardar el servicio.");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "Error en el formato de Precio.");
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error inesperado: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/servicios");
    }

    private void eliminarServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id_servicio");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                if (servicioDAO.eliminarServicio(id)) {
                    request.getSession().setAttribute("mensajeExito", "Servicio eliminado correctamente.");
                } else {
                    request.getSession().setAttribute("mensajeError", "Error al eliminar el servicio. Puede estar en uso.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("mensajeError", "ID de servicio no válido.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/servicios");
    }
}