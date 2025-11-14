<%-- 
    Document   : login
    Created on : 7 oct. 2025, 10:07:06
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Iniciar Sesión - Mecánica AZ</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .container { max-width: 400px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        h1 { text-align: center; color: #333; }
        input[type="text"], input[type="password"] {
            width: 100%; padding: 10px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%; background-color: #007bff; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer;
        }
        input[type="submit"]:hover { background-color: #0056b3; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

<div class="container">
    <h1>Inicio de Sesión</h1>
    
    <%
        // Aquí puedes recibir y mostrar mensajes de error si el login falla (ej. desde el Servlet)
        String mensajeError = (String) request.getAttribute("error");
        if (mensajeError != null && !mensajeError.isEmpty()) {
            %>
            <div class="message">
                <%= mensajeError %>
            </div>
            <%
        }
    %>

    <form action="LoginServlet" method="POST">
        
        <label for="usuario">Usuario:</label>
        <input type="text" id="usuario" name="usuario" required>
        
        <label for="contrasena">Contraseña:</label>
        <input type="password" id="contrasena" name="contrasena" required>
        
        <input type="submit" value="Iniciar Sesión">
    </form>
    
    <p style="text-align: center;">¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
</div>

</body>
</html>