<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %> 
<%
    // Obtener la sesión y los atributos de usuario
    modelo.Usuario usuarioLogeado = (modelo.Usuario) session.getAttribute("usuarioLogeado");
    String rol = (String) session.getAttribute("rol");

    // 1. Verificación de Seguridad: Redirigir si no es ADMIN
    if (usuarioLogeado == null || rol == null || !"ADMIN".equalsIgnoreCase(rol)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // Variables para el Dashboard
    String nombreAdmin = usuarioLogeado.getNombre();

    // Variables necesarias para el Header/Navbar
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    boolean isAdmin = (rol != null) && "ADMIN".equalsIgnoreCase(rol.trim());
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard Admin | Mecánica AZ</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

        <style>
            /* 1. ESTILO GENERAL: Fondo claro (gris claro) y Texto Negro */
            body {
                background-color: #333333;
                color: #333333;
                font-family: Arial, sans-serif;
                padding-top: 0; /* Asegurar que no haya padding superior si el topbar ya lo cubre */
            }

            /* 2. CONTENEDOR PRINCIPAL: Card Blanca */
            .dashboard {
                max-width: 1000px;
                margin: 30px auto 60px auto; /* Más margen abajo para el footer */
                padding: 30px;
                background: gray;
                color: #333333;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border: 1px solid #ddd;
            }

            /* TÍTULOS Y SEPARADORES */
            .dashboard h1 {
                color: #ffcc00;
            }
            .dashboard h2 {
                color: #000000;
                border-bottom: 2px solid #ffcc00;
                padding-bottom: 10px;
                margin-top: 30px;
            }
            hr {
                border-color: #cccccc;
            }

            /* MÓDULOS DE GESTIÓN (Cards Secundarias) */
            .dashboard__menu {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 25px;
                margin-top: 20px;
            }
            .dashboard__item {
                background-color: #f0f0f0;
                color: #333333;
                padding: 25px;
                border-radius: 10px;
                text-align: center;
                text-decoration: none;
                transition: background-color 0.3s, transform 0.2s;
                border: 1px solid #ccc;
            }
            .dashboard__item:hover {
                background-color: #e0e0e0;
                transform: translateY(-5px);
            }
            .dashboard__item h3 {
                font-size: 2.5em;
                margin-bottom: 10px;
                color: #007bff;
            }
            .dashboard__item h4 {
                margin-top: 0;
                font-size: 1.1em;
                color: #333333;
            }
            .dashboard__item small {
                color: #666666;
            }

            /* Estilo para la cinta CTA */
            .cta-strip {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 20px;
                margin-top: 30px;
                background-color: #e0e0e0;
                border-radius: 8px;
                border: 1px solid #ffcc00;
            }
            .cta-strip span {
                font-weight: bold;
                color: #333333;
            }
            .cta-strip a.btn--dark {
                background-color: #ffcc00 !important;
                color: #141419 !important;
            }
        </style>
    </head>
    <body>

        <header class="topbar">
            <div class="container topbar__inner">
                <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Inicio">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="Logo AZ" class="brand__img">
                </a>

                <a href="tel:+51973608798" class="phone-badge">Llámanos: 973 608 798</a>

                <div class="user-info" style="display:flex; align-items:center; gap:.5rem; margin-left:.5rem;">
                    <span style="color:#cfd1d6; font-size:.95rem;">
                        <%= (nombreUsuario != null) ? ("Hola, " + nombreUsuario + "!") : "Invitado"%>
                    </span>
                    <%= (nombreUsuario != null)
                            ? "<a href=\"LogoutServlet\" class=\"nav__link\" style=\"padding:.3rem .6rem;\">Salir</a>"
                            : "<a href=\"login.jsp\" class=\"nav__link\" style=\"padding:.3rem .6rem;\">Ingresar</a>"%>
                </div>

                <button class="menu-btn" aria-label="Abrir menú" aria-expanded="false" aria-controls="mainnav">☰</button>
            </div>

            <nav id="mainnav" class="nav">
                <div class="container nav__list">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="nav__link">Principal</a>
                    <a href="${pageContext.request.contextPath}/reparacion.jsp" class="nav__link">Reparación</a>
                    <a href="${pageContext.request.contextPath}/mantenimiento.jsp" class="nav__link">Mantenimiento</a>
                    <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link">Auxilio</a>
                    <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link">Localización</a>

                    <% if (isAdmin) { %>
                    <a href="${pageContext.request.contextPath}/dashboard_admin.jsp" 
                       class="nav__link nav__link--admin is-active" 
                       style="background-color: #ffcc00; color: #141419; font-weight: bold;">
                        Dashboard Admin
                    </a>
                    <% }%>
                </div>
            </nav>


        </header>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Elimina 'is-active' de otros enlaces y lo pone en Dashboard Admin si existe
                document.querySelectorAll('#mainnav .nav__link').forEach(link => {
                    link.classList.remove('is-active');
                });
                const adminLink = document.querySelector('.nav__link--admin');
                if (adminLink) {
                    adminLink.classList.add('is-active');
                }
            });
        </script>

        <main class="dashboard">
            <h1 style="text-align: center;">⚙️ Panel de Administración</h1>
            <p style="font-size: 1.1em;">Bienvenido, <%= nombreAdmin%>!. Acceso total a la gestión del sistema.</p>

            <hr>

            <h2>Módulos de Gestión</h2>
            <div class="dashboard__menu">
                <a href="${pageContext.request.contextPath}/clientes" class="dashboard__item">
                    <h3>👥</h3>
                    <h4>Gestión de Clientes</h4>
                    <small>Ver, editar y eliminar usuarios.</small>
                </a>
                <a href="${pageContext.request.contextPath}/vehiculos.jsp" class="dashboard__item">
                    <h3>🚗</h3>
                    <h4>Gestión de Vehículos</h4>
                    <small>Registro y seguimiento de coches.</small>
                </a>
                <a href="${pageContext.request.contextPath}/servicios" class="dashboard__item">
                    <h3>🔧</h3>
                    <h4>Gestión de Servicios</h4>
                    <small>Catálogo de servicios y precios.</small>
                </a>
                <a href="${pageContext.request.contextPath}/citas.jsp" class="dashboard__item">
                    <h3>🗓️</h3>
                    <h4>Gestión de Citas</h4>
                    <small>Programación de citas y agenda.</small>
                </a>

                <!-- NUEVO MÓDULO DE PROVEEDORES -->
                <a href="${pageContext.request.contextPath}/proveedores" class="dashboard__item">
                    <h3>📦</h3>
                    <h4>Gestión de Proveedores</h4>
                    <small>Agregar, editar y eliminar proveedores.</small>
                </a>
            </div>

            <hr>

            <h2>Reportes Rápidos</h2>
            <p>Aquí se incluirán gráficos y estadísticas clave (ej. ingresos del mes, citas pendientes).</p>

            <div class="cta-strip">
                <span>Finalizar gestión y volver a la portada</span>
                <a class="btn btn--dark" href="${pageContext.request.contextPath}/LogoutServlet" style="background-color: #ffcc00; color: #141419;">Cerrar Sesión Segura</a>
            </div>
        </main>

        <footer class="footer">
            <div class="container footer__inner">
                <small>© <%= java.time.Year.now()%> AZ Mecánica — Todos los derechos reservados</small>
            </div>
            <a class="wa-fab" href="https://wa.me/51973698798" target="_blank" rel="noopener" aria-label="WhatsApp">💬</a>
        </footer>

        <script>
            (function () {
                const btn = document.querySelector('.menu-btn');
                const nav = document.getElementById('mainnav');
                if (btn && nav) {
                    btn.addEventListener('click', () => {
                        const open = nav.classList.toggle('is-open');
                        btn.setAttribute('aria-expanded', open ? 'true' : 'false');
                    });
                }
            })();
        </script>
    </body>
</html>