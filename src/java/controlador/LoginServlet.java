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

    request.setCharacterEncoding("UTF-8");

    String usuario = request.getParameter("usuario");
    String contrasena = request.getParameter("contrasena");

    Usuario u = UsuarioDAO.login(usuario, contrasena);

    if (u != null) {
        HttpSession session = request.getSession(true);
        session.setAttribute("nombreUsuario", u.getNombre()); // "Hugo Huallpa"
        session.setAttribute("rol", u.getRol());              // "ADMIN" o "CLIENTE"
        // (opcional) session.setAttribute("idUsuario", u.getId());

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    } else {
        request.setAttribute("error", "Credenciales incorrectas. Verifique su usuario y contraseña.");
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