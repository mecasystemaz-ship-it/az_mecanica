<%-- 
    Document   : login
    Created on : 7 oct. 2025
    Author     : Usuario
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Redirección si ya está logueado
    if (session.getAttribute("usuarioLogeado") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Mensajes de sesión
    String registroExitoso = (String) session.getAttribute("registroExitoso");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Mecánica AZ</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        /* --- RESET Y BASES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #0b0b0d; /* Fondo de respaldo */
            /* Imagen de fondo temática (puedes cambiar la URL por una local tuya) */
            background-image: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=2000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f5f5f5;
        }

        /* --- CONTENEDOR LOGIN --- */
        .login-card {
            background: rgba(23, 23, 27, 0.95); /* Fondo oscuro semi-transparente */
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 420px;
            text-align: center;
            border-top: 4px solid #ffcc00; /* Línea amarilla de marca */
        }

        /* --- LOGO Y TÍTULOS --- */
        .brand-logo {
            margin-bottom: 20px;
        }
        .brand-logo img {
            height: 60px; /* Ajusta según tu logo real */
            width: auto;
        }
        
        .login-card h1 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: #fff;
        }
        .login-card p.subtitle {
            color: #888;
            font-size: 0.95rem;
            margin-bottom: 30px;
        }

        /* --- FORMULARIO --- */
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.9rem;
            color: #ccc;
            font-weight: 600;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }
        .input-wrapper input {
            width: 100%;
            padding: 12px 15px 12px 40px; /* Espacio para el icono */
            background: #0b0b0d;
            border: 1px solid #333;
            border-radius: 6px;
            color: #fff;
            font-size: 1rem;
            outline: none;
            transition: 0.3s;
        }
        .input-wrapper input:focus {
            border-color: #ffcc00;
            box-shadow: 0 0 0 3px rgba(255, 204, 0, 0.1);
        }

        /* --- BOTÓN --- */
        .btn-login {
            width: 100%;
            padding: 12px;
            background: #ffcc00;
            color: #000;
            font-weight: 700;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.2s;
            margin-top: 10px;
        }
        .btn-login:hover {
            background: #e6b800;
        }

        /* --- MENSAJES DE ERROR/EXITO --- */
        .alert {
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: left;
        }
        .alert-error {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
        }
        .alert-success {
            background: rgba(40, 167, 69, 0.15);
            border: 1px solid rgba(40, 167, 69, 0.3);
            color: #75b798;
        }

        /* --- LINKS --- */
        .links {
            margin-top: 20px;
            font-size: 0.9rem;
            color: #888;
        }
        .links a {
            color: #ffcc00;
            text-decoration: none;
            font-weight: 600;
        }
        .links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="login-card">
        
        <div class="brand-logo">
            <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ Mecánica Logo">
        </div>

        <h1>Bienvenido</h1>
        <p class="subtitle">Ingresa a tu cuenta para continuar</p>

        <% 
            if (registroExitoso != null) { 
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-check-circle"></i> <%= registroExitoso %>
            </div>
        <% 
                session.removeAttribute("registroExitoso");
            } 

            String mensajeError = (String) request.getAttribute("error");
            if (mensajeError != null && !mensajeError.isEmpty()) {
        %>
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= mensajeError %>
            </div>
        <% } %>

        <form action="LoginServlet" method="POST">
            
            <div class="input-group">
                <label for="usuario">Correo Electrónico</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="text" id="usuario" name="usuario" placeholder="ejemplo@correo.com" required autocomplete="username">
                </div>
            </div>

            <div class="input-group">
                <label for="contrasena">Contraseña</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="contrasena" name="contrasena" placeholder="••••••••" required autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn-login">Iniciar Sesión</button>
        </form>

        <div class="links">
            ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
        </div>
    </div>

</body>
</html>