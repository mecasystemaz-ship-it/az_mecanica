/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener la sesión actual
        HttpSession session = request.getSession(false); // No crear una nueva sesión si no existe

        if (session != null) {
            // 2. Invalidar la sesión (eliminar todos los atributos y terminar la sesión)
            session.invalidate();
        }
        
        // 3. Redirigir al usuario a la página principal o al login
        // Esto refrescará el index.jsp, que volverá a mostrar "Invitado"
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}