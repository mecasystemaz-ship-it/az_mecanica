// Archivo: src/main/java/servlet/ProveedorServlet.java
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DAO.ProveedorDAO;
import java.io.IOException;
import java.util.List;

import modelo.Proveedor;

@WebServlet("/proveedores")
public class ProveedorServlet extends HttpServlet {

    private ProveedorDAO dao = new ProveedorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Proveedor> lista = dao.listar();
        request.setAttribute("listaProveedores", lista);
        request.getRequestDispatcher("proveedores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        String ruc = request.getParameter("ruc");
        String nombre = request.getParameter("nombre");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");

        Proveedor p = new Proveedor(ruc, nombre, telefono, email, direccion);

        boolean exito = false;

        switch (action) {
            case "registrar":
                exito = dao.registrar(p);
                break;
            case "modificar":
                exito = dao.modificar(p);
                break;
            case "eliminar":
                exito = dao.eliminar(ruc);
                break;
        }

        if (exito) {
            request.getSession().setAttribute("mensajeExito", "Operación realizada con éxito.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al realizar la operación.");
        }

        response.sendRedirect(request.getContextPath() + "/proveedores");
    }
}
