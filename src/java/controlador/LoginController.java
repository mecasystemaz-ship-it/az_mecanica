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
import modelo.Usuario;
import modelo.DAO.UsuarioDAO; // Ajustado a modelo.UsuarioDAO, si usas ese paquete
import java.io.IOException;


// Asegúrate que esta anotación coincida con la acción de tu formulario JSP: action="LoginServlet"
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginController extends HttpServlet {

    // Instancia del DAO para la conexión a la base de datos
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario (del JSP)
        // El campo 'usuario' se mapea al EMAIL en el UsuarioDAO
        String usuarioIngresado = request.getParameter("usuario"); 
        String contrasena = request.getParameter("contrasena");
        
        // 2. Llamar al DAO para verificar las credenciales
        Usuario usuarioLogeado = usuarioDAO.login(usuarioIngresado, contrasena);

        if (usuarioLogeado != null) {
            // 3. Login Exitoso: Crear o recuperar la sesión
            HttpSession session = request.getSession();
            
            // ⭐ AÑADIDOS para la visualización en index.jsp y control de acceso ⭐
            // a) Almacenar el objeto Usuario completo
            session.setAttribute("usuarioLogeado", usuarioLogeado);
            
            // b) Almacenar el nombre para mostrarlo en el saludo: "Hola, Nombre!"
            session.setAttribute("nombreUsuario", usuarioLogeado.getNombre());
            
            // c) Almacenar el rol para la barra de navegación de administrador
            session.setAttribute("rol", usuarioLogeado.getRol());
            
            // Opcional: Establecer un tiempo de vida para la sesión (en segundos)
            session.setMaxInactiveInterval(30 * 60); // 30 minutos

            // Redirigir a la página de bienvenida o al dashboard
            if ("ADMIN".equalsIgnoreCase(usuarioLogeado.getRol())) { // Usar .equalsIgnoreCase() para mayor robustez
                response.sendRedirect("dashboard_admin.jsp");
            } else {
                // Redirige al index.jsp donde se mostrará el nombre
                response.sendRedirect("index.jsp"); 
            }
            
        } else {
            // 4. Login Fallido: Mostrar mensaje de error en el JSP
            request.setAttribute("error", "Usuario o Contraseña inválidos.");
            
            // Además, verificamos si hay un mensaje de registro exitoso para no sobreescribirlo si existe
            String registroExitoso = (String) request.getSession().getAttribute("registroExitoso");
            if (registroExitoso != null) {
                 // Si se viene de un registro, mantenemos el mensaje de éxito en la sesión (para el login.jsp)
                 request.getSession().setAttribute("registroExitoso", registroExitoso);
            }
            
            // Redirigir de nuevo al login.jsp manteniendo el mensaje de error
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    // Si usas GlassFish 7+ y Jakarta EE 9+, solo necesitas el método doPost
    // ya que los formularios de login usan POST.
}