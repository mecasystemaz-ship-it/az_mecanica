<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Guardar"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Registro de Cliente - Mecánica AZ</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .container { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        h1 { text-align: center; color: #333; }
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%; background-color: #007bff; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer;
        }
        input[type="submit"]:hover { background-color: #0056b3; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

<div class="container">
    <h1>Registro de Nuevo Cliente</h1>
    
    <%
        // Variables para el manejo de mensajes
        String mensaje = "";
        String tipoMensaje = "";

        // Comprobamos si el formulario fue enviado (usando POST)
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            
            // 1. Recolección de parámetros
            String usuario = request.getParameter("usuario");
            String contrasena = request.getParameter("contrasena");
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String correo = request.getParameter("correo");
            String celular = request.getParameter("celular");
            String direccion = request.getParameter("direccion");

            // 2. Validación de campos obligatorios
            if (usuario == null || contrasena == null || nombre == null || correo == null || 
                usuario.isEmpty() || contrasena.isEmpty() || nombre.isEmpty() || correo.isEmpty()) {
                
                mensaje = "Por favor, complete todos los campos obligatorios (*).";
                tipoMensaje = "error";

            } else {
                
                // 3. Llamada al método guardar del Modelo
                // Usamos una lógica simple para manejar nulls en campos opcionales
                boolean registrado = Guardar.guardar(
                    usuario, 
                    contrasena, // ¡Recuerda HASHear en un proyecto real!
                    nombre, 
                    apellido != null ? apellido : "", 
                    correo, 
                    celular != null ? celular : "",
                    direccion != null ? direccion : ""
                );

                if (registrado) {
                    mensaje = "¡Registro exitoso! Ya eres cliente de Mecánica AZ.";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al registrar. Verifica si el usuario o correo ya están en uso.";
                    tipoMensaje = "error";
                }
            }
        }
        
        // 4. Muestra del mensaje
        if (!mensaje.isEmpty()) {
            %>
            <div class="message <%= tipoMensaje %>">
                <%= mensaje %>
            </div>
            <%
        }
    %>

    <form action="registro.jsp" method="POST">
        
        <label for="nombre">Nombre (*)</label>
        <input type="text" id="nombre" name="nombre" required>

        <label for="apellido">Apellido</label>
        <input type="text" id="apellido" name="apellido">

        <label for="usuario">Usuario (Nombre de acceso) (*)</label>
        <input type="text" id="usuario" name="usuario" required>
        
        <label for="contrasena">Contraseña (*)</label>
        <input type="password" id="contrasena" name="contrasena" required>

        <label for="correo">Correo Electrónico (*)</label>
        <input type="email" id="correo" name="correo" required>

        <label for="celular">Celular</label>
        <input type="tel" id="celular" name="celular">

        <label for="direccion">Dirección</label>
        <input type="text" id="direccion" name="direccion">
        
        <input type="submit" value="Crear Cuenta">
    </form>
    
    <p style="text-align: center;"><a href="login.jsp">¿Ya tienes cuenta? Inicia Sesión</a></p>
</div>

</body>
</html>