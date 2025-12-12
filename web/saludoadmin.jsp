<%-- 
    Document   : header
    Created on : 30 nov. 2025, 00:45:02
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
                    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
                    String rol = (String) session.getAttribute("rol");
                    boolean isAdmin = (rol != null) && "ADMIN".equalsIgnoreCase(rol.trim());
                 %>
        
        
                <span style="color:#cfd1d6; font-size:.95rem;">
                    <%= (nombreUsuario != null) ? ("Hola, " + nombreUsuario + "!") : "Invitado"%>
                </span>