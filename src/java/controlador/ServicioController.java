/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import modelo.ServicioDAO;

@WebServlet("/ServicioController")
public class ServicioController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ... (El método doGet para cambiar estado NO CAMBIA, se omite por brevedad) ...
    // Asegúrate de usar la versión anterior del doGet

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lógica para AÑADIR NUEVO SERVICIO
        
        // 1. Obtener parámetros del formulario
        String marcaVehiculo = request.getParameter("marca"); // Nuevo campo
        String modeloVehiculo = request.getParameter("modelo"); // Nuevo campo
        String placa = request.getParameter("placa");
        String usuarioCliente = request.getParameter("usuario_cliente");
        
        int servicioId = -1;
        try {
            servicioId = Integer.parseInt(request.getParameter("servicio"));
        } catch (NumberFormatException e) {
            // Error al obtener el ID del servicio
        }

        // 2. Obtener el ID del cliente
        int clienteId = ServicioDAO.obtenerClienteIdPorUsuario(usuarioCliente);

        if (clienteId != -1 && servicioId != -1) {
            
            // 3. Registrar o buscar el vehículo y obtener su ID
            int vehiculoId = ServicioDAO.guardarVehiculoYObtenerId(clienteId, marcaVehiculo, modeloVehiculo, placa);
            
            if (vehiculoId != -1) {
                // 4. Guardar el servicio solicitado
                boolean guardado = ServicioDAO.guardarServicioSolicitado(vehiculoId, servicioId);

                if (guardado) {
                    request.getSession().setAttribute("msg", "Servicio y Vehículo registrados con éxito.");
                } else {
                    request.getSession().setAttribute("errorMsg", "Error al registrar el servicio solicitado.");
                }
            } else {
                 request.getSession().setAttribute("errorMsg", "Error al registrar/obtener el vehículo.");
            }
        } else {
            request.getSession().setAttribute("errorMsg", "Error de datos: Cliente no encontrado o Servicio inválido.");
        }

        // 5. Redirigir a la vista de listado
        response.sendRedirect("admin_servicios.jsp");
    }
}