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
            /* === ESTILO GENERAL DEL DASHBOARD === */
            
            /* Fondo general oscuro suave (coherente con el tema 'dark' profesional) */
            body {
                background-color: #f4f6f8; /* Fondo gris muy claro para contraste limpio */
                color: #333;
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            }

            /* Contenedor principal */
            .dashboard {
                max-width: 1100px;
                margin: 40px auto 80px auto;
                padding: 0 20px;
            }

            /* Cabecera del Dashboard */
            .dashboard-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .dashboard-header h1 {
                font-size: 2.2rem;
                color: #1a1a1a;
                margin-bottom: 10px;
                font-weight: 700;
            }
            .dashboard-header p {
                font-size: 1.1rem;
                color: #666;
                margin: 0;
            }
            .dashboard-header .highlight {
                color: #d4a000; /* Dorado oscuro */
                font-weight: 600;
            }

            /* Separador sutil */
            hr.divider {
                border: 0;
                height: 1px;
                background: #e0e0e0;
                margin: 30px 0;
            }

            /* Títulos de Sección */
            .section-title {
                font-size: 1.4rem;
                color: #1a1a1a;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .section-title::after {
                content: "";
                flex: 1;
                height: 1px;
                background: #e0e0e0;
                margin-left: 15px;
            }

            /* GRID DE MÓDULOS (Tarjetas) */
            .dashboard__menu {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
            }

            .dashboard__item {
                background-color: #ffffff;
                color: #333;
                padding: 30px 20px;
                border-radius: 12px;
                text-align: center;
                text-decoration: none;
                transition: all 0.3s ease;
                border: 1px solid #e1e4e8;
                box-shadow: 0 2px 4px rgba(0,0,0,0.02);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                min-height: 180px;
            }

            /* Efecto Hover Profesional (Elevación suave) */
            .dashboard__item:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 24px rgba(0,0,0,0.08);
                border-color: #ffcc00; /* Borde amarillo al pasar el mouse */
            }

            .dashboard__item h3 {
                font-size: 3rem;
                margin: 0 0 15px 0;
                line-height: 1;
                filter: grayscale(0.2); /* Iconos ligeramente desaturados para elegancia */
            }
            
            .dashboard__item h4 {
                margin: 0;
                font-size: 1.15rem;
                font-weight: 600;
                color: #111;
            }

            .dashboard__item small {
                display: block;
                margin-top: 8px;
                color: #777;
                font-size: 0.9rem;
                line-height: 1.4;
            }

            /* Panel de Reportes (Estilo diferenciado) */
            .reports-panel {
                background: #fff;
                border-radius: 12px;
                padding: 30px;
                border: 1px solid #e1e4e8;
                text-align: center;
                color: #666;
                margin-bottom: 30px;
            }

            /* Cinta CTA inferior */
            .cta-strip-admin {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 30px;
                background-color: #1a1a1d; /* Fondo oscuro */
                border-radius: 10px;
                color: #fff;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .cta-strip-admin span {
                font-weight: 500;
                font-size: 1.05rem;
            }
            .cta-strip-admin .btn-logout {
                background-color: #ffcc00;
                color: #000;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 700;
                transition: background 0.2s;
            }
            .cta-strip-admin .btn-logout:hover {
                background-color: #e6b800;
            }

            /* Ajuste responsivo */
            @media (max-width: 600px) {
                .cta-strip-admin {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" class="logo" alt="AZ">
                    <span class="brand__label">DASHBOARD ADMIN</span>
                </div>
                <jsp:include page="saludoadmin.jsp" />
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
        </nav>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
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
            
            <div class="dashboard-header">
                <h1>Panel de Control</h1>
                <p>Bienvenido de nuevo, <span class="highlight"><%= nombreAdmin%></span>.
                <br> ¿Qué deseas gestionar hoy?</p>
            </div>

            <h2 class="section-title">Módulos Principales</h2>
            
            <div class="dashboard__menu">
                <a href="${pageContext.request.contextPath}/clientes" class="dashboard__item">
                    <h3>👥</h3>
                    <h4>Clientes</h4>
                    <small>Base de datos de usuarios y contacto.</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/vehiculos" class="dashboard__item">
                    <h3>🚗</h3>
                    <h4>Vehículos</h4>
                    <small>Historial y registro de automóviles.</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/servicios" class="dashboard__item">
                    <h3>🔧</h3>
                    <h4>Servicios</h4>
                    <small>Catálogo de reparaciones y precios.</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/CitaServlet" class="dashboard__item">
                    <h3>🗓️</h3>
                    <h4>Agenda</h4>
                    <small>Programación y control de citas.</small>
                </a>

                <a href="${pageContext.request.contextPath}/proveedores" class="dashboard__item">
                    <h3>📦</h3>
                    <h4>Proveedores</h4>
                    <small>Gestión de suministros externos.</small>
                </a>

                <a href="${pageContext.request.contextPath}/productos" class="dashboard__item">
                    <h3>🛒</h3>
                    <h4>Inventario</h4>
                    <small>Stock de repuestos y productos.</small>
                </a>
            </div>

            <br><br>

            <h2 class="section-title">Resumen y Reportes</h2>
            <div class="reports-panel">
                <p>📊 <strong>Área de Métricas:</strong> Próximamente visualización de ingresos mensuales y citas pendientes.</p>
            </div>

            <div class="cta-strip-admin">
                <span>¿Terminaste tu gestión por hoy?</span>
                <a class="btn-logout" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar Sesión Segura</a>
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