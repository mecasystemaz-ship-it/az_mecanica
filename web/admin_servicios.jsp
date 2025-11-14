<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.ServicioDAO"%>
<%@page import="modelo.ServicioDAO.ServicioSolicitado"%>
<%@page import="java.util.List"%>

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
        // Obtener el nombre de usuario de la sesión para el encabezado
        String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    %>
    
    <%-- INICIO DEL ENCABEZADO --%>
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
                    // Usuario logueado: mostrar nombre y Salir
                    out.print("Hola, " + nombreUsuario + "!");
                    // Usamos LogoutServlet para cerrar la sesión
                    out.print("<a href=\"LogoutServlet\">Salir</a>"); 
                } else {
                    // Usuario NO logueado: mostrar Ingresar
                    out.print("Invitado");
                    out.print("<a href=\"login.jsp\">Ingresar</a>"); 
                }
            %>
        </div>
    </div>
    <%-- FIN DEL ENCABEZADO --%>

    <div class="container">
        <h1>Gestión de Servicios Solicitados</h1>

        <%
            // Mostrar mensajes de sesión (éxito o error)
            String msg = (String) session.getAttribute("msg");
            String errorMsg = (String) session.getAttribute("errorMsg");
            if (msg != null) {
                out.print("<p class='success'>" + msg + "</p>");
                session.removeAttribute("msg");
            }
            if (errorMsg != null) {
                out.print("<p class='error'>" + errorMsg + "</p>");
                session.removeAttribute("errorMsg");
            }
        %>

        <a href="nuevo_servicio.jsp" class="btn-add">Añadir Nuevo Servicio</a>

        <h2>Lista de Servicios</h2>
        <table>
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Vehículo</th>
                    <th>Placa</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // 1. Obtener la lista de servicios del DAO
                    List<ServicioSolicitado> servicios = ServicioDAO.listarServicios();
                    
                    if (servicios != null && !servicios.isEmpty()) {
                        for (ServicioSolicitado s : servicios) {
                            // Asigna una clase para estilizar la etiqueta de estado
                            String estadoClass = "estado-" + s.estado.toLowerCase().replace("_", "");
                %>
                <tr>
                    <td><%= s.clienteNombre %></td>
                    <td><%= s.vehiculoModelo %></td>
                    <td><%= s.placa %></td>
                    <td><%= s.servicioNombre %></td>
                    <td><strong class="<%= estadoClass %>"><%= s.estado.replace("_", " ") %></strong></td>
                    <td>
                        <a class="estado-btn estado-proceso" 
                           href="ServicioController?action=cambiarEstado&id=<%= s.id %>&estado=EN_PROCESO">En Proceso</a>
                        <a class="estado-btn estado-terminado" 
                           href="ServicioController?action=cambiarEstado&id=<%= s.id %>&estado=TERMINADO">Terminado</a>
                        <a class="estado-btn estado-cancelado" 
                           href="ServicioController?action=cambiarEstado&id=<%= s.id %>&estado=CANCELADO">Cancelar</a>
                        <a class="estado-btn estado-pendiente" 
                           href="ServicioController?action=cambiarEstado&id=<%= s.id %>&estado=PENDIENTE">Pendiente</a>
                    </td>
                </tr>
                <%
                        } // Fin del bucle for
                    } else {
                %>
                <tr>
                    <td colspan="6" style="text-align: center;">No hay servicios solicitados registrados.</td>
                </tr>
                <%
                    } // Fin del if/else de listado
                %>
            </tbody>
        </table>
    </div>
</body>
</html>