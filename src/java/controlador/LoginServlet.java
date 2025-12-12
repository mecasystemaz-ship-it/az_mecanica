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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import modelo.Usuario;
import modelo.UsuarioDAO;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario u = dao.login(usuario, contrasena);

        if (u != null) {
            // Crear sesión y guardar datos básicos
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioId", u.getId());
            session.setAttribute("usuarioUser", u.getUsuario());
            session.setAttribute("usuarioNombre", u.getNombre());
            session.setAttribute("rol", u.getRol());

            // Redirige a tu home
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.setAttribute("error", "Credenciales incorrectas. Verifique su usuario y contraseña.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Si alguien entra por GET al /login, lo mandamos al login.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
