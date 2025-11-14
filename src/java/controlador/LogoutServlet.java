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
/**
 * Servlet que maneja la lógica de cierre de sesión (Logout).
 * Invalida la sesión actual del usuario.
 */
@WebServlet("/LogoutServlet") // Mapea este Servlet a la URL /LogoutServlet
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Usaremos el método doGet ya que el enlace "Salir" en index.jsp usa GET.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener la sesión actual. El parámetro 'false' asegura que no se cree una nueva sesión
        // si no existe (aunque ya debería existir si el usuario está logueado).
        HttpSession session = request.getSession(false); 

        if (session != null) {
            // 2. Destruir la sesión. Esto elimina todas las variables de sesión
            // (incluyendo "nombreUsuario") y finaliza la sesión.
            session.invalidate();
        }

        // 3. Redirigir al usuario a la página de inicio (index.jsp) o login.jsp.
        // index.jsp es mejor porque ahí se volverá a mostrar "Ingresar" automáticamente.
        response.sendRedirect("index.jsp");
    }

    // Opcional: Para manejar si alguien envía una solicitud POST, simplemente redirigimos a doGet.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}