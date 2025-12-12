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
        if (action == null) action = "list";

        switch (action) {
            case "list":
            default:
                listarCitas(request, response);
                break;
            case "cancel":
                // Idealmente usar POST, pero si vienes de un link GET:
                // cancelarCita(request, response); 
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            listarCitas(request, response);
            return;
        }

        switch (action) {
            case "create":
                insertarCita(request, response);
                break;
            case "cancel":
            case "confirm":
            case "updateState": // Agregado para coincidir con el JSP
                actualizarEstadoCita(request, response);
                break;
            default:
                listarCitas(request, response);
                break;
        }
    }

    /**
     * Lógica mejorada para listar citas con navegación de meses.
     */
    private void listarCitas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Obtener fecha actual por defecto
        Calendar cal = Calendar.getInstance();
        int anio = cal.get(Calendar.YEAR);
        int mes = cal.get(Calendar.MONTH) + 1; // Calendar es 0-11

        // 2. Leer parámetros de navegación si existen
        String paramMes = request.getParameter("mes");
        String paramAnio = request.getParameter("anio");

        if (paramMes != null && paramAnio != null) {
            try {
                mes = Integer.parseInt(paramMes);
                anio = Integer.parseInt(paramAnio);
                
                // Ajuste de desbordamiento de meses (si mes es 0 o 13)
                if (mes < 1) { mes = 12; anio--; }
                if (mes > 12) { mes = 1; anio++; }
                
            } catch (NumberFormatException e) {
                // Si hay error, se queda con la fecha actual
                System.err.println("Error al parsear fecha: " + e.getMessage());
            }
        }

        // 3. Calcular Mes Anterior y Siguiente para los botones
        int mesAnt = mes - 1;
        int anioAnt = anio;
        if (mesAnt < 1) { mesAnt = 12; anioAnt--; }

        int mesSig = mes + 1;
        int anioSig = anio;
        if (mesSig > 12) { mesSig = 1; anioSig++; }

        // 4. Enviar variables de navegación al JSP
        request.setAttribute("anio", anio);
        request.setAttribute("mes", mes);
        // Nota: Necesitas un método estático para el nombre del mes, o usar un array simple aquí
        request.setAttribute("mesNombre", getNombreMes(mes));
        
        request.setAttribute("mesAnterior", mesAnt);
        request.setAttribute("anioAnterior", anioAnt);
        request.setAttribute("mesSiguiente", mesSig);
        request.setAttribute("anioSiguiente", anioSig);

        // 5. Obtener datos para los selectores (Clientes, Servicios, etc.)
        request.setAttribute("clientes", citaDAO.listarClientes());
        // Los vehículos se cargan por AJAX, no aquí
        request.setAttribute("servicios", citaDAO.listarServicios());
        request.setAttribute("empleados", citaDAO.listarEmpleados());

        // 6. Obtener las citas y generar calendario
        List<Cita> citasDelMes = citaDAO.listarCitasPorMes(anio, mes);
        List<SemanaCalendario> semanas = CalendarioUtil.generarVistaMensual(anio, mes, citasDelMes);
        request.setAttribute("semanas", semanas);

        // 7. Redirigir
        request.getRequestDispatcher("citas.jsp").forward(request, response);
    }

    // Método auxiliar simple para nombre de mes
    private String getNombreMes(int mes) {
        String[] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        if (mes >= 1 && mes <= 12) return meses[mes-1];
        return "Desconocido";
    }

    private void insertarCita(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String dniCliente = request.getParameter("dniCliente");
            String placaVehiculo = request.getParameter("placaVehiculo");
            int idServicio = Integer.parseInt(request.getParameter("idServicio"));
            String dniEmpleado = request.getParameter("dniEmpleado");
            
            String fechaStr = request.getParameter("fecha");
            String horaStr = request.getParameter("hora");
            String notas = request.getParameter("notas");

            if(fechaStr == null || fechaStr.isEmpty() || horaStr == null || horaStr.isEmpty()){
                 throw new Exception("Fecha y Hora son obligatorias");
            }

            Cita nuevaCita = new Cita();
            nuevaCita.setDniCliente(dniCliente);
            nuevaCita.setPlacaVehiculo(placaVehiculo);
            nuevaCita.setIdServicio(idServicio);
            nuevaCita.setDniEmpleado(dniEmpleado);
            nuevaCita.setFecha(LocalDate.parse(fechaStr));
            nuevaCita.setHora(LocalTime.parse(horaStr));
            nuevaCita.setNotas(notas);
            nuevaCita.setEstado("PENDIENTE"); // Valor por defecto

            boolean exito = citaDAO.crearCita(nuevaCita);

            if (!exito) {
                request.getSession().setAttribute("mensajeError", "Error al agendar la cita. Verifique disponibilidad.");
            } else {
                request.getSession().setAttribute("mensajeExito", "Cita agendada correctamente.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error en los datos: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("CitaServlet");
    }

    private void actualizarEstadoCita(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action"); // 'confirm', 'cancel' o 'updateState'
        String nuevoEstado = null;

        // Lógica para determinar estado basado en el botón presionado en el panel lateral
        if ("confirm".equals(action)) {
            nuevoEstado = "CONFIRMADA";
        } else if ("cancel".equals(action)) {
            nuevoEstado = "CANCELADA";
        } else {
             // Si viene de otro lado, por defecto no hacemos nada o redirigimos
             response.sendRedirect("CitaServlet");
             return;
        }

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            if (citaDAO.actualizarEstadoCita(idCita, nuevoEstado)) {
                request.getSession().setAttribute("mensajeExito", "Cita actualizada a: " + nuevoEstado);
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo actualizar la cita.");
            }
        } catch (NumberFormatException e) {
            System.err.println("ID inválido: " + e.getMessage());
        }
        response.sendRedirect("CitaServlet");
    }
}