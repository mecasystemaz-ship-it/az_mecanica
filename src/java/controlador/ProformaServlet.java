// Archivo: src/main/java/controlador/ProformaServlet.java
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DAO.ProformaDAO;
import modelo.DAO.ClienteDAO; 
import modelo.Proforma;
import modelo.Cliente;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProformaServlet", urlPatterns = {"/proformas", "/proformas/guardar", "/proformas/eliminar"})
public class ProformaServlet extends HttpServlet {
    
    private final ProformaDAO proformaDAO = new ProformaDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        // Manejar las peticiones de POST si se reciben por GET (evita errores 405)
        if (path.equals("/proformas/guardar") || path.equals("/proformas/eliminar")) {
            doPost(request, response);
            return;
        }

        // 1. Cargar la lista de Proformas
        List<Proforma> listaProformas = proformaDAO.listar();
        request.setAttribute("listaProformas", listaProformas);
        
        // 2. Cargar la lista de Clientes para el modal
        try {
            List<Cliente> listaClientes = clienteDAO.listarClientes();
            request.setAttribute("listaClientes", listaClientes);
        } catch (Exception e) {
             request.getSession().setAttribute("mensajeError", "Error al cargar la lista de clientes: " + e.getMessage());
             e.printStackTrace();
        }
        
        // 3. ⭐ CORRECCIÓN: Redirigir a la vista proforma.jsp
        request.getRequestDispatcher("/proforma.jsp").forward(request, response); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String path = request.getServletPath();
        String mensaje = "";
        boolean exito = false;

        switch (path) {
            case "/proformas/guardar":
                exito = guardarProforma(request);
                mensaje = exito ? "Proforma guardada con éxito." : "Error al guardar la proforma. Verifique los datos.";
                break;
            case "/proformas/eliminar":
                String idEliminar = request.getParameter("id_proforma");
                exito = proformaDAO.eliminar(idEliminar);
                mensaje = exito ? "Proforma eliminada con éxito." : "Error al eliminar la proforma. Verifique que no tenga dependencias.";
                break;
            default:
                mensaje = "Acción no válida.";
                exito = false;
        }

        if (exito) {
            request.getSession().setAttribute("mensajeExito", mensaje);
        } else {
            request.getSession().setAttribute("mensajeError", mensaje);
        }

        response.sendRedirect(request.getContextPath() + "/proformas");
    }
    
    private boolean guardarProforma(HttpServletRequest request) {
        try {
            // Obtener y parsear parámetros
            String idProforma = request.getParameter("id_proforma");
            String idCliente = request.getParameter("id_cliente");
            double montoEstimado = Double.parseDouble(request.getParameter("monto_estimado"));
            String estado = request.getParameter("estado");

            Proforma p = new Proforma();
            p.setIdProforma(idProforma);
            p.setIdCliente(idCliente);
            p.setMontoEstimado(montoEstimado);
            p.setEstado(estado);

            // Lógica de actualización o inserción
            if (idProforma != null && !idProforma.trim().isEmpty()) {
                 if (proformaDAO.buscarPorId(idProforma) != null) {
                    return proformaDAO.actualizar(p);
                 } else { 
                    return proformaDAO.insertar(p);
                 }
            } else {
                return false;
            }
            
        } catch (Exception e) {
            e.printStackTrace(System.out);
            return false;
        }
    }
}