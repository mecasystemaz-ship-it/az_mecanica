<%-- 
    Document : index.jsp
    Created on : 30 may. 2025
    Author : Hugo Hernan
    Description: Página principal con navegación dinámica.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Administración de Servicios | Mecánica AZ</title>
    <style>
        /* --- ESTILOS DEL ENCABEZADO (COPIADOS DE INDEX.JSP) --- */
        .header {
            background-color: #333;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            margin-right: 20px;
            font-weight: bold;
        }
        .user-info {
            color: #f0f0f0;
            display: flex;
            align-items: center;
        }
        .user-info a {
            color: #87CEEB; 
            text-decoration: none;
            margin-left: 15px;
            font-weight: bold;
        }

        /* --- ESTILOS DE CONTENIDO Y TABLA --- */
        body { margin: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .container { padding: 20px; }
        
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #e9e9e9; }
        
        .btn-add { 
            background-color: #007bff; 
            color: white; 
            padding: 10px 15px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-block; 
            margin-bottom: 20px;
        }
        
        /* Estilos para los botones de estado */
        .estado-btn { padding: 5px 10px; cursor: pointer; border: none; border-radius: 3px; font-size: 0.8em; margin-right: 5px; }
        .estado-pendiente { background-color: #ff9800; color: white; }
        .estado-proceso { background-color: #2196f3; color: white; }
        .estado-terminado { background-color: #4CAF50; color: white; }
        .estado-cancelado { background-color: #f44336; color: white; }
    </style>
</head>
<body>

    <%
        // Obtener el nombre de usuario de la sesión
        // Suponemos que al loguearse, el controlador guarda el nombre con setAttribute("nombreUsuario", ...)
        String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    %>

    <div class="header">
        <div class="nav-links">
            <a href="index.jsp">Inicio</a>
            <a href="admin_servicios.jsp">Servicios</a>
            <a href="vision_mision.jsp">Visión y Misión</a>
            <a href="nosotros.jsp">Nosotros</a>
        </div>

        <div class="user-info">
            <%
                if (nombreUsuario != null) {
                    // El usuario está logueado: mostrar su nombre y la opción de cerrar sesión
                    out.print("Hola, " + nombreUsuario + "!");
                    // NOTA: 'LogoutServlet' debe ser creado para invalidar la sesión
                    out.print("<a href=\"LogoutServlet\">Salir</a>"); 
                } else {
                    // El usuario NO está logueado: mostrar la opción de ingresar
                    out.print("Invitado");
                    out.print("<a href=\"login.jsp\">Ingresar</a>"); 
                }
            %>
        </div>
    </div>

    <div class="content">
        <h2>Bienvenido a Mecánica AZ</h2>
        <p>Tu mejor opción para el cuidado y mantenimiento de vehículos.</p>
        
        </div>

</body>
</html>