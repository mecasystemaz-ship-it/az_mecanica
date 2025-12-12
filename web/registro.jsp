<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Registro de Cliente - Mecánica AZ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        /* --- RESET Y BASES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #0b0b0d;
            background-image: linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.8)), url('https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=2000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f5f5f5;
            padding: 20px;
        }

        /* --- CONTENEDOR REGISTRO --- */
        .register-card {
            background: rgba(23, 23, 27, 0.95);
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 600px;
            border-top: 4px solid #ffcc00;
        }

        /* --- ENCABEZADO --- */
        .header-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .header-section h1 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: #fff;
        }
        .header-section p {
            color: #888;
            font-size: 0.95rem;
        }

        /* --- GRID PARA CAMPOS --- */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        @media (max-width: 550px) {
            .form-grid { grid-template-columns: 1fr; }
        }
        
        .full-width {
            grid-column: 1 / -1;
        }

        /* --- INPUTS Y LABELS --- */
        .input-group {
            margin-bottom: 15px;
            text-align: left;
        }
        .input-group label {
            display: block;
            margin-bottom: 6px;
            font-size: 0.85rem;
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
            font-size: 0.9rem;
        }
        .input-wrapper input {
            width: 100%;
            padding: 10px 15px 10px 38px;
            background: #0b0b0d;
            border: 1px solid #333;
            border-radius: 6px;
            color: #fff;
            font-size: 0.95rem;
            outline: none;
            transition: 0.3s;
        }
        .input-wrapper input:focus {
            border-color: #ffcc00;
            box-shadow: 0 0 0 3px rgba(255, 204, 0, 0.1);
        }

        /* --- BOTÓN --- */
        .btn-register {
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
            margin-top: 15px;
        }
        .btn-register:hover {
            background: #e6b800;
        }

        /* --- MENSAJES --- */
        .alert {
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: center;
        }
        .alert-success {
            background: rgba(40, 167, 69, 0.15);
            border: 1px solid rgba(40, 167, 69, 0.3);
            color: #75b798;
        }
        .alert-error {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
        }

        /* --- LINKS --- */
        .links {
            margin-top: 20px;
            text-align: center;
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

<div class="register-card">
    
    <div class="header-section">
        <h1>Crear Cuenta</h1>
        <p>Únete a AZ Mecánica y gestiona tus servicios</p>
    </div>
    
    <%
        String mensaje = (String) request.getAttribute("mensaje");
        String tipoMensaje = (String) request.getAttribute("tipoMensaje");

        if (mensaje != null && !mensaje.isEmpty()) {
            String claseAlert = "alert-success";
            if ("error".equals(tipoMensaje)) {
                claseAlert = "alert-error";
            }
    %>
            <div class="alert <%= claseAlert %>">
                <%= mensaje %>
            </div>
    <%
        }
    %>

    <form action="RegistroServlet" method="POST">
        
        <div class="form-grid">
            <div class="input-group">
                <label for="nombre">Nombre *</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" id="nombre" name="nombre" placeholder="Tu nombre" required>
                </div>
            </div>

            <div class="input-group">
                <label for="apellido">Apellido</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user-tag"></i>
                    <input type="text" id="apellido" name="apellido" placeholder="Tus apellidos">
                </div>
            </div>

            <div class="input-group">
                <label for="usuario">DNI (Usuario) *</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-id-card"></i>
                    <input type="text" id="usuario" name="usuario" placeholder="Documento de identidad" required 
                           maxlength="8" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                </div>
            </div>

            <div class="input-group">
                <label for="celular">Celular</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-phone"></i>
                    <input type="tel" id="celular" name="celular" placeholder="999 999 999" 
                           maxlength="9" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                </div>
            </div>
        </div>
        <div class="input-group">
            <label for="direccion">Dirección</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-map-location-dot"></i>
                <input type="text" id="direccion" name="direccion" placeholder="Av. Ejemplo 123">
            </div>
        </div>
        
        <div class="input-group">
            <label for="correo">Correo Electrónico *</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" id="correo" name="correo" placeholder="ejemplo@correo.com" required>
            </div>
        </div>

        

        <div class="input-group">
            <label for="contrasena">Contraseña *</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-lock"></i>
                <input type="password" id="contrasena" name="contrasena" placeholder="Crea una contraseña segura" required>
            </div>
        </div>
        
        <button type="submit" class="btn-register">Registrarme</button>
    </form>
    
    <div class="links">
        ¿Ya tienes cuenta? <a href="login.jsp">Inicia Sesión</a>
    </div>
</div>

</body>
</html>