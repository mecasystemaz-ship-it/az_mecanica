package controlador;

import modelo.Producto;
import modelo.DAO.ProductoDAO;
import modelo.DAO.ProveedorDAO; // <-- 1. Importar el DAO de Proveedor
import modelo.Proveedor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ProductoServlet", urlPatterns = {"/productos", "/productos/guardar", "/productos/eliminar"})
public class ProductoServlet extends HttpServlet {

    private ProductoDAO productoDAO;
    private ProveedorDAO proveedorDAO; // <-- 3. Declarar la instancia del DAO

    @Override
    public void init() {
        productoDAO = new ProductoDAO();
        proveedorDAO = new ProveedorDAO(); // <-- 4. Inicializar en init()
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener y pasar la lista de Productos
        List<Producto> listaProductos = productoDAO.listarProductos();
        request.setAttribute("listaProductos", listaProductos);

        // 2. Obtener y pasar la lista de Proveedores (¡PASO CLAVE!)
        List<Proveedor> listaProveedores = proveedorDAO.listar();
        request.setAttribute("listaProveedores", listaProveedores); // <-- ¡AHORA ESTÁ DISPONIBLE!

        request.getRequestDispatcher("/productos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/productos/guardar")) {
            guardarOActualizar(request, response);
        } else if (path.equals("/productos/eliminar")) {
            eliminar(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida.");
        }
    }

    private void guardarOActualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("cod_producto");
        String nombre = request.getParameter("nombre");
        String categoria = request.getParameter("categoria");
        String cantParam = request.getParameter("cant_inicial");
        String costoParam = request.getParameter("costo");
        String idProvParam = request.getParameter("id_proveedor");

        // SOLUCIÓN: Añadir .isEmpty() a cantParam y costoParam
        if (nombre == null || nombre.isEmpty()
                || cantParam == null || cantParam.isEmpty()
                || // <-- CAMBIO APLICADO
                costoParam == null || costoParam.isEmpty() // <-- CAMBIO APLICADO
                ) {
            request.getSession().setAttribute("mensajeError", "Nombre, cantidad y costo son obligatorios.");
            response.sendRedirect(request.getContextPath() + "/productos");
            return;
        }

        try {
            Producto p = new Producto();
            if (idParam != null && !idParam.isEmpty()) {
                p.setCodProducto(Integer.parseInt(idParam));
            }
            p.setNombre(nombre);
            p.setCategoria(categoria);
            // ¡Cuidado! Si cantParam o costoParam no son números válidos, esto causará NumberFormatException.
            p.setCantInicial(Integer.parseInt(cantParam));
            p.setCosto(new BigDecimal(costoParam));

            // 1. Cambiar el tipo de la variable local a String
            String idProv = null;

            if (idProvParam != null && !idProvParam.isEmpty()) {
                // 2. Asignar directamente el parámetro String sin intentar parsearlo a entero
                idProv = idProvParam;
            }
// 3. Establecer el valor en el objeto Producto (asegúrate de que seteo en Producto sea String)
            p.setIdProveedor(idProv);

            boolean exito = p.getCodProducto() > 0 ? productoDAO.actualizarProducto(p) : productoDAO.agregarProducto(p);

            // ... (resto del código)
        } catch (NumberFormatException e) {
            // Añadir manejo específico para errores de conversión de texto a número (INT o BigDecimal)
            request.getSession().setAttribute("mensajeError", "Error de formato: Asegúrate de que Cantidad y Costo sean números válidos.");
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error inesperado: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/productos");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("cod_producto");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                boolean exito = productoDAO.eliminarProducto(id);
                request.getSession().setAttribute("mensajeExito", exito ? "Producto eliminado correctamente." : "Error al eliminar producto.");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("mensajeError", "ID de producto no válido.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/productos");
    }
}
