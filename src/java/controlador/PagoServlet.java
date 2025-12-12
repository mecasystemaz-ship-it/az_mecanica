package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import modelo.Pago;
import modelo.Cita;
import modelo.Proforma;
import modelo.DAO.PagoDAO;
import modelo.DAO.CitaDAO;
import modelo.DAO.ProformaDAO;

// Definimos las rutas: una para ver la página (/pagos) y otra para guardar (/pagos/guardar)
@WebServlet(name = "PagoServlet", urlPatterns = {"/pagos", "/pagos/guardar"})
public class PagoServlet extends HttpServlet {

    // Instanciamos los DAOs para conectar con la Base de Datos
    private final PagoDAO pagoDAO = new PagoDAO();
    private final CitaDAO citaDAO = new CitaDAO();
    private final ProformaDAO proformaDAO = new ProformaDAO();

    // --- METODO GET: Para CARGAR la página y las listas ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Cargar Historial de Pagos (Tablas inferiores)
            List<Pago> historialCitas = pagoDAO.listarPagosCitas();
            List<Pago> historialProformas = pagoDAO.listarPagosProformas();

            // 2. Cargar Listas de Pendientes (Para los Selects del Modal)
            // AQUI USAMOS EL NUEVO MÉTODO QUE CREAMOS EN CitaDAO
            List<Cita> pendientesCita = citaDAO.listarPendientesDePago(); 
            
            // Asumimos que tienes un método similar en ProformaDAO. Si no, devuelve lista vacía para que no falle.
            List<Proforma> pendientesProforma = new ArrayList<>(); 
            // pendientesProforma = proformaDAO.listarPendientes(); // Descomenta cuando tengas este método en ProformaDAO

            // 3. Enviar todo al JSP
            request.setAttribute("pagosCitas", historialCitas);
            request.setAttribute("pagosProformas", historialProformas);
            
            request.setAttribute("listaCitasPendientes", pendientesCita);
            request.setAttribute("listaProformasPendientes", pendientesProforma);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error al cargar datos: " + e.getMessage());
        }

        // Redirigir al JSP visual
        request.getRequestDispatcher("/pagos.jsp").forward(request, response);
    }

    // --- METODO POST: Para GUARDAR el pago ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String path = request.getServletPath();

        if (path.equals("/pagos/guardar")) {
            try {
                // 1. Recibir datos del formulario
                String origen = request.getParameter("origen"); // "CITA" o "PROFORMA"
                String idReferencia = request.getParameter("id_referencia");
                double monto = Double.parseDouble(request.getParameter("monto"));
                String metodo = request.getParameter("metodoPago");
                Date fecha = Date.valueOf(request.getParameter("fecha"));
                String notas = request.getParameter("notas");

                // Validar que se haya seleccionado algo
                if (idReferencia == null || idReferencia.isEmpty()) {
                    throw new Exception("Debe seleccionar una Cita o Proforma válida.");
                }

                // 2. Crear objeto Pago
                Pago p = new Pago();
                p.setOrigen(origen);
                p.setIdReferencia(idReferencia);
                p.setMonto(monto);
                p.setMetodoPago(metodo);
                p.setFecha(fecha);
                p.setNotas(notas);

                // 3. Insertar en Base de Datos
                boolean registrado = pagoDAO.insertar(p);

                if (registrado) {
                    session.setAttribute("mensajeExito", "Pago registrado correctamente.");

                    // 4. ACTUALIZAR ESTADO (Opcional pero recomendado)
                    // Si pagó la cita, cambiamos su estado a "PAGADO" o "CONFIRMADA"
                    if ("CITA".equals(origen)) {
                        int idCita = Integer.parseInt(idReferencia);
                        // Usamos el método actualizarEstadoCita que ya tienes en CitaDAO
                        citaDAO.actualizarEstadoCita(idCita, "PAGADO"); 
                    }
                    // if ("PROFORMA".equals(origen)) { ... }

                } else {
                    session.setAttribute("mensajeError", "No se pudo registrar el pago en la BD.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("mensajeError", "Error: " + e.getMessage());
            }
        }

        // Redirigir de nuevo a /pagos para ver la tabla actualizada
        response.sendRedirect(request.getContextPath() + "/pagos");
    }
}