package controlador;

import modelo.DAO.VehiculoDAO;
import modelo.DAO.ClienteDAO; // Importamos el DAO de Cliente
import modelo.Vehiculo;
import modelo.Cliente; // Importamos el Modelo de Cliente
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VehiculoServlet", urlPatterns = {"/vehiculos", "/vehiculos/form", "/vehiculos/eliminar", "/vehiculos/guardar"})
public class VehiculoServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    private ClienteDAO clienteDAO; // Objeto para manejar la lógica de clientes

    @Override
    public void init() throws ServletException {
        super.init();
        vehiculoDAO = new VehiculoDAO();
        clienteDAO = new ClienteDAO(); // Inicializamos el DAO de Cliente
    }
// ----------------------------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Determinamos la acción por el parámetro 'action' o por el path de la URL
        String action = request.getParameter("action");
        String path = request.getServletPath();

        // Si la URL es para ver/editar/crear el formulario
        if (action != null && (action.equals("create") || action.equals("edit") || action.equals("view")) || path.equals("/vehiculos/form")) {

            // Llama al método que carga el formulario y los clientes
            cargarFormulario(request, response, action);

        } else {
            // Lógica por defecto: listar la tabla principal de vehículos
            listarVehiculos(request, response);
        }
    }
// ----------------------------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/vehiculos/eliminar".equals(path)) {
            eliminarVehiculo(request, response);
        } else if ("/vehiculos/guardar".equals(path)) {
            guardarOActualizarVehiculo(request, response);
        } else {
            // Manejo de otras peticiones POST si las hubiera
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción POST no reconocida.");
        }
    }
// ----------------------------------------------------------------------------------

    /**
     * Carga la lista de clientes y, si aplica (edit/view), el vehículo
     * específico antes de hacer forward a vehiculo-form.jsp.
     *
     * @param action La acción a realizar (create, edit, view).
     */
    private void cargarFormulario(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        // 1. CARGAR CLIENTES: Necesario para el <select> en vehiculo-form.jsp
        //  ESTO ASEGURA QUE "${listaClientes}" FUNCIONE EN EL JSP 
        List<Cliente> listaClientes = clienteDAO.listarClientes();
        request.setAttribute("listaClientes", listaClientes);

        // 2. CARGAR VEHÍCULO ESPECÍFICO (si es editar o ver)
        if ("edit".equals(action) || "view".equals(action)) {
            String placa = request.getParameter("placa");
            // Asumimos que VehiculoDAO tiene el método obtenerVehiculoPorPlaca
            Vehiculo vehiculo = vehiculoDAO.obtenerVehiculoPorPlaca(placa);
            request.setAttribute("vehiculo", vehiculo); // Pasa el objeto para rellenar los campos
        }

        // 3. Pasar la acción y redirigir al formulario
        request.setAttribute("action", action);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/vehiculo-form.jsp");
        dispatcher.forward(request, response);
    }
// ----------------------------------------------------------------------------------

    private void listarVehiculos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Vehiculo> listaVehiculos = vehiculoDAO.listarVehiculos();
        request.setAttribute("listaVehiculos", listaVehiculos);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/vehiculos.jsp");
        dispatcher.forward(request, response);
    }
// ----------------------------------------------------------------------------------

    private void guardarOActualizarVehiculo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener parámetros del formulario
        String placa = request.getParameter("placa");
        String dniCliente = request.getParameter("dniCliente");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String tipo = request.getParameter("tipo");
        String anioStr = request.getParameter("anio");
        String color = request.getParameter("color");
        String combustible = request.getParameter("combustible");
        String transmision = request.getParameter("transmision");
        String nMotor = request.getParameter("nummotor");
        String vin = request.getParameter("vin");
        String placaOriginal = request.getParameter("placaOriginal"); // Solo existe en EDIT

        // Conversión de tipos
        Integer anio = anioStr != null && !anioStr.isEmpty() ? Integer.parseInt(anioStr) : null;

        // 2. Crear objeto Vehiculo
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setPlaca(placa);
        vehiculo.setDniCliente(dniCliente);
        vehiculo.setMarca(marca);
        vehiculo.setModelo(modelo);
        vehiculo.setTipo(tipo);
        vehiculo.setAnio(anio);
        vehiculo.setColor(color);
        vehiculo.setCombustible(combustible);
        vehiculo.setVin(vin);
        vehiculo.setTransmision(transmision);
        vehiculo.setNummotor(nMotor);

        boolean exito;

        // 3. Determinar si es INSERT o UPDATE
        if (placaOriginal != null && !placaOriginal.isEmpty()) {
            // Es Edición (UPDATE)
            exito = vehiculoDAO.actualizarVehiculo(vehiculo, placaOriginal); // Asume que el DAO tiene este método
        } else {
            // Es Creación (INSERT)
            exito = vehiculoDAO.agregarVehiculo(vehiculo); // Asume que el DAO tiene este método
        }

        // 4. Manejo de la respuesta
        if (exito) {
            request.getSession().setAttribute("mensajeExito", "Vehículo " + placa + " guardado correctamente.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al guardar el vehículo " + placa + ". Verifique los datos.");
        }

        // 5. Redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/vehiculos");
    }
// ----------------------------------------------------------------------------------

    private void eliminarVehiculo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String placa = request.getParameter("placa");

        if (placa != null && !placa.isEmpty()) {
            boolean exito = vehiculoDAO.eliminarVehiculo(placa);
            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Vehículo " + placa + " eliminado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al eliminar el vehículo " + placa + ".");
            }
        }
        // Redirigir de vuelta a la lista
        response.sendRedirect(request.getContextPath() + "/vehiculos");
    }

    
}


