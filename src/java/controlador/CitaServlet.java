// Archivo: src/main/java/controller/CitaServlet.java
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DAO.CitaDAO;
import modelo.Cita;
import util.CalendarioUtil;
import util.SemanaCalendario;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.List;

@WebServlet("/CitaServlet")
public class CitaServlet extends HttpServlet {

    private CitaDAO citaDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        citaDAO = new CitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
            default:
                listarCitas(request, response);
                break;
            case "cancel":
                // Esta acción se manejaría más limpio en POST, pero la incluimos para completar la lógica
                // response.sendRedirect("CitaServlet"); // Mejor usar POST
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Asegúrate de usar la codificación correcta si manejas caracteres especiales
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            // Error o fallback
            listarCitas(request, response);
            return;
        }

        switch (action) {
            case "create":
                insertarCita(request, response);
                break;

            case "cancel":
            case "confirm":
                // Llama al método unificado para cambiar el estado
                actualizarEstadoCita(request, response);
                break;

            default:
                listarCitas(request, response);
                break;
        }
    }

    /**
     * Prepara el calendario y los datos para los SELECTs del JSP.
     */
    private void listarCitas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Obtener la fecha actual o la fecha seleccionada
        Calendar cal = Calendar.getInstance();
        int anio = cal.get(Calendar.YEAR);
        int mes = cal.get(Calendar.MONTH) + 1; // Calendar es 0-basado, sumamos 1

        // 2. Obtener datos de apoyo para el modal lateral (SELECTs)
        request.setAttribute("clientes", citaDAO.listarClientes());
        request.setAttribute("vehiculos", citaDAO.listarVehiculos());
        request.setAttribute("servicios", citaDAO.listarServicios());
        request.setAttribute("empleados", citaDAO.listarEmpleados());

        // 3. Obtener las citas del mes
        List<Cita> citasDelMes = citaDAO.listarCitasPorMes(anio, mes);

        // 4. Construir la vista mensual del calendario
        List<SemanaCalendario> semanas = CalendarioUtil.generarVistaMensual(anio, mes, citasDelMes);

        // 5. Establecer atributos para el JSP
        request.setAttribute("semanas", semanas);
        request.setAttribute("anio", anio);
        request.setAttribute("mesNombre", CalendarioUtil.getNombreMes(mes));

        // 6. Redirigir a la vista
        request.getRequestDispatcher("citas.jsp").forward(request, response);
    }

    private void insertarCita(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String dniCliente = request.getParameter("dniCliente");
            String placaVehiculo = request.getParameter("placaVehiculo");
            int idServicio = Integer.parseInt(request.getParameter("idServicio"));
            String dniEmpleado = request.getParameter("dniEmpleado"); // Puede ser nulo o vacío
            LocalDate fecha = LocalDate.parse(request.getParameter("fecha"));
            LocalTime hora = LocalTime.parse(request.getParameter("hora"));
            String notas = request.getParameter("notas");

            // Creación y seteo del objeto Cita
            Cita nuevaCita = new Cita();
            nuevaCita.setDniCliente(dniCliente);
            nuevaCita.setPlacaVehiculo(placaVehiculo);
            nuevaCita.setIdServicio(idServicio);
            nuevaCita.setDniEmpleado(dniEmpleado);
            nuevaCita.setFecha(fecha);
            nuevaCita.setHora(hora);
            nuevaCita.setNotas(notas);
            // El estado por defecto es PENDIENTE (ver modelo Cita)

            boolean exito = citaDAO.crearCita(nuevaCita);

            if (!exito) {
                // Manejar error (p.ej., si falla la llave única u otra restricción)
                request.setAttribute("error", "Error al crear la cita. Verifique si ya existe una cita para ese vehículo/empleado en esa hora.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error en el formato de los datos: " + e.getMessage());
        }

        // Redirigir siempre al listado (GET) para evitar doble submit
        response.sendRedirect(request.getContextPath() + "/CitaServlet");
    }

    private void actualizarEstadoCita(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action"); // 'confirm' o 'cancel'
        String nuevoEstado = null;

        if ("confirm".equals(action)) {
            nuevoEstado = "CONFIRMADA";
        } else if ("cancel".equals(action)) {
            nuevoEstado = "CANCELADA";
        } else {
            // Acción no reconocida, redirigir
            response.sendRedirect(request.getContextPath() + "/CitaServlet");
            return;
        }

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            if (citaDAO.actualizarEstadoCita(idCita, nuevoEstado)) {
                System.out.println("Cita ID " + idCita + " actualizada a estado: " + nuevoEstado);
            } else {
                System.err.println("Error DB al actualizar cita ID " + idCita);
            }

        } catch (NumberFormatException e) {
            System.err.println("ID de cita inválido para " + nuevoEstado + ".");
        }

        // Redirigir al listado
        response.sendRedirect(request.getContextPath() + "/CitaServlet");
    }

    private void cancelarCita(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            citaDAO.cancelarCita(idCita);
        } catch (NumberFormatException e) {
            System.err.println("ID de cita inválido para cancelación.");
        }

        // Redirigir al listado
        response.sendRedirect(request.getContextPath() + "/CitaServlet");
    }
}
