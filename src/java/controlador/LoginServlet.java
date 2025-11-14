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

import modelo.UsuarioDAO; // Importamos el modelo

/**
 * Servlet que maneja la lógica de inicio de sesión.
 */
@WebServlet("/LoginServlet") // Anotación para mapear el Servlet (alternativa a web.xml)
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        // 2. Llamar al modelo para verificar credenciales
        String nombreUsuario = UsuarioDAO.verificarCredenciales(usuario, contrasena);

        if (nombreUsuario != null) {
            // 3. Éxito en el Login: Iniciar Sesión
            HttpSession session = request.getSession();
            
            // Guardamos el nombre de usuario en la sesión para mostrarlo en el index.jsp
            session.setAttribute("nombreUsuario", nombreUsuario.trim()); 
            
            // Aquí se podría guardar el ID o el rol del usuario:
            // session.setAttribute("rol", "CLIENTE");

            // 4. Redirigir al index (página principal)
            response.sendRedirect("index.jsp");

        } else {
            // 5. Fallo en el Login: Redirigir de vuelta al login.jsp con error
            String error = "Credenciales incorrectas. Verifique su usuario y contraseña.";
            
            // Guardamos el mensaje de error para que login.jsp lo muestre
            request.setAttribute("error", error); 
            
            // Reenviamos la solicitud de vuelta a login.jsp
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    // Opcional: Manejar peticiones GET (si alguien intenta acceder al servlet por URL)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}