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
import modelo.DAO.GuardarDAO; // Usaremos el DAO directamente
import java.io.IOException;


@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    private final GuardarDAO guardarDAO = new GuardarDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Recolección de parámetros
        // Usamos 'usuario' como el DNI/ID
        String dni = request.getParameter("usuario"); 
        String contrasena = request.getParameter("contrasena");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String celular = request.getParameter("celular");
        String direccion = request.getParameter("direccion");

        // 2. Validación y Limpieza (Se puede mejorar, pero mantenemos la lógica base del JSP)
        if (dni == null || contrasena == null || nombre == null || correo == null ||
            dni.isEmpty() || contrasena.isEmpty() || nombre.isEmpty() || correo.isEmpty()) {
            
            // Si faltan campos obligatorios, regresamos a la vista con error
            request.setAttribute("mensaje", "Por favor, complete todos los campos obligatorios (*).");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return; // Detenemos la ejecución aquí
        }

        // 3. Llamada al DAO para el registro (el modelo se encarga de la DB)
        boolean registrado = guardarDAO.guardarUsuario(
            dni, contrasena, 
            nombre, apellido != null ? apellido : "", 
            correo, 
            celular != null ? celular : "", 
            direccion != null ? direccion : ""
        );

        if (registrado) {
            // 4. Éxito: Redirigir a la página de inicio de sesión
            // Usamos sendRedirect para evitar que el usuario intente enviar el formulario de nuevo (Post-Redirect-Get)
            request.getSession().setAttribute("registroExitoso", "¡Registro exitoso! Ya puedes iniciar sesión.");
            response.sendRedirect("login.jsp");
            
        } else {
            // 5. Fallo: Volver al formulario de registro con un mensaje de error
            request.setAttribute("mensaje", "Error al registrar. El DNI o Correo ya están registrados.");
            request.setAttribute("tipoMensaje", "error");
            
            // Devolvemos los datos ingresados al formulario (opcional, para conveniencia del usuario)
            request.setAttribute("nombre", nombre);
            request.setAttribute("apellido", apellido);
            request.setAttribute("usuario", dni);
            request.setAttribute("correo", correo);
            request.setAttribute("celular", celular);
            request.setAttribute("direccion", direccion);

            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}