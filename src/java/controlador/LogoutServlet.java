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
        
        // 1. Obtener la sesión actual sin crear una nueva
        HttpSession session = request.getSession(false); 

        if (session != null) {
            // 2. Destruir la sesión en el servidor (Esto borra usuarioLogeado, rol, etc.)
            session.invalidate();
        }
        
        // ========================================================================
        // 3. ELIMINAR CACHÉ DEL NAVEGADOR (EL CANDADO FINAL)
        // Estas líneas son CRUCIALES. Evitan que al dar "Atrás" se vea la página anterior.
        // ========================================================================
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0 (compatibilidad)
        response.setDateHeader("Expires", 0); // Proxies
        
        // 4. Redirigir obligatoriamente al Login
        // Al enviarlo al login en lugar del index, refuerzas que debe ingresar credenciales.
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}