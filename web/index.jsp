<%-- 
    Document   : index.jsp
    Created on : 30 may. 2025
    Author     : Hugo Hernan / Jeff
    Description: Página principal con navegación dinámica (login) y estilo unificado.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Mecánica AZ - Inicio</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- MISMO CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
    <body>

        <%
            String nombreUsuario = (String) session.getAttribute("nombreUsuario");
            String rol = (String) session.getAttribute("rol");
            boolean isAdmin = (rol != null) && "ADMIN".equalsIgnoreCase(rol.trim());
        %>

        <!-- ====== HEADER ====== -->
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

            <!-- NAV PÚBLICO (siempre) -->
            <nav id="mainnav" class="nav">
                <div class="container nav__list">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="nav__link is-active">Principal</a>
                    <a href="${pageContext.request.contextPath}/reparacion.jsp" class="nav__link">Reparación</a>
                    <a href="${pageContext.request.contextPath}/mantenimiento.jsp" class="nav__link">Mantenimiento</a>
                    <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link">Auxilio</a>
                    <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link">Localización</a>
                </div>
            </nav>

            <!-- NAV ADMIN (solo si isAdmin = true) -->
            <% if (isAdmin) { %>
            <nav class="nav nav--admin">
                <div class="container nav__list">
                    <% if (isAdmin) { %>
                    <a href="${pageContext.request.contextPath}/dashboard_admin.jsp" 
                       class="nav__link nav__link--admin" 
                       style="background-color: #ffcc00; color: #141419; font-weight: bold;">
                        Dashboard Admin
                    </a>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/clientes" class="nav__link">Clientes</a>
                    <a href="${pageContext.request.contextPath}/vehiculos.jsp" class="nav__link">Vehículos</a>
                    <a href="${pageContext.request.contextPath}/servicios.jsp" class="nav__link">Servicios</a>
                    <a href="${pageContext.request.contextPath}/citas.jsp" class="nav__link">Citas</a>

                </div>
            </nav>
            <% }%>
        </header>


        <!-- ====== HERO: 2 imágenes ====== -->
        <section class="gallery container" style="grid-template-columns: repeat(2, 1fr);">
            <!-- Ajusta las rutas a tus fotos -->
            <img src="${pageContext.request.contextPath}/imgs/imgcar4.jpg" alt="Motor en reparación" class="gallery__img">
            <img src="${pageContext.request.contextPath}/imgs/imgcar7.jpg" alt="Vehículo clásico" class="gallery__img">
        </section>


        <!-- ====== FILA DE MARCAS ====== -->
        <section class="container">
            <div class="card" style="display:flex; justify-content:center; align-items:center; padding:1rem;">
                <img src="${pageContext.request.contextPath}/imgs/marcas.png"
                     alt="Marcas automotrices"
                     style="width:100%; height:auto; border-radius:10px; object-fit:contain;">
            </div>
        </section>



        <!-- ====== BOTONES DESTACADOS ====== -->
        <section class="container" style="margin-top:.6rem;">
            <div class="card" style="display:flex; gap:.75rem; flex-wrap:wrap; background:#141419;">
                <a class="btn btn--dark" href="${pageContext.request.contextPath}/reparacion.jsp">Problemas Mecánicos</a>
                <a class="btn btn--dark" href="${pageContext.request.contextPath}/mantenimiento.jsp">Diagnóstico Preventivo</a>
                <a class="btn btn--dark" href="${pageContext.request.contextPath}/auxilio.jsp">Auxilio Mecánico</a>
            </div>
        </section>

        <!-- ====== CONTENIDO PRINCIPAL: 3 columnas ====== -->
        <main class="container content" style="margin-top:.8rem;">
            <!-- Título (faja amarilla) -->
            <header class="content__header">
                <h1 class="content__title">¡Bienvenidos!</h1>
            </header>

            <!-- Grid 3 cols: 280 / 1fr / 320 -->
            <section class="content__grid" style="grid-template-columns: 280px 1fr 320px;">
                <!-- Columna izquierda: horario + contactos + mapa -->
                <aside>
                    <article class="card">
                        <h3 class="card__title" style="text-transform:none; color:#fff;">Horario de atención</h3>
                        <p class="card__text" style="margin:.4rem 0;">
                            <strong>Lunes – Sábado:</strong> 8:00 a. m. – 6:00 p. m.<br>
                            <strong>Domingos y feriados:</strong> emergencias coordinadas.
                        </p>
                        <p class="card__text" style="margin:.4rem 0;">
                            <strong>Dirección:</strong><br>
                            Mz. Z-12, Sección 2, Zona B – Cercado, Arequipa
                        </p>
                        <p class="card__text" style="margin:.4rem 0;">
                            <strong>Teléfonos:</strong><br>
                            973698798 – Henry Añazco<br>
                            947340388 – Jesús Añazco
                        </p>
                        <a class="btn btn--accent" href="tel:+51973698798">Llámanos ahora</a>
                    </article>

                    <article class="card" style="margin-top:1rem; overflow:hidden;">
                        <iframe 
                            title="Ubicación AZ Mecánica"
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3834.051657228211!2d-71.54!3d-16.398!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2sArequipa!5e0!3m2!1ses!2spe!4v1700000000000"
                            width="100%" height="220" style="border:0;" loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </article>
                </aside>

                <!-- Columna central: bienvenida / acerca -->
                <section>
                    <article class="card">
                        <h3 class="card__title" style="text-transform:none; color:#fff;">Bienvenidos</h3>
                        <p class="card__text">
                            Somos un taller de reparación de automóviles con base en Arequipa. Realizamos mantenimiento preventivo,
                            diagnóstico electrónico, mecánica rápida y correctiva. Trabajamos con procedimientos estandarizados,
                            repuestos de calidad y personal técnico calificado para garantizar seguridad y rendimiento.
                        </p>

                        <h3 class="card__title" style="text-transform:none; color:#fff; margin-top:.8rem;">Acerca de nosotros</h3>
                        <p class="card__text">
                            Nuestro propósito es prolongar la vida útil de tu vehículo y evitar averías costosas. Recomendamos planes de
                            mantenimiento según kilometraje, uso y estilo de conducción. Atendemos emergencias y brindamos
                            asesoramiento para compra de vehículos con inspección técnica previa.
                        </p>

                        <img src="${pageContext.request.contextPath}/public_html/imagenes/logo-az-mini.png" alt="AZ" style="height:56px; margin-top:.6rem;">
                    </article>
                </section>

                <!-- Columna derecha: lista de servicios -->
                <aside>
                    <article class="card">
                        <h3 class="card__title" style="text-transform:none; color:#fff;">Nuestros servicios</h3>
                        <ul class="card__text" style="margin:.2rem 0 0 1rem; padding-left:1rem; list-style: disc;">
                            <li>Mantenimiento preventivo completo</li>
                            <li>Diagnóstico electrónico OBD</li>
                            <li>Cambio de aceite y filtros</li>
                            <li>Sistema de frenos (pastillas, discos)</li>
                            <li>Suspensión y dirección</li>
                            <li>Embrague y tren motriz</li>
                            <li>Sistema eléctrico y baterías</li>
                            <li>Afinamiento de motor</li>
                            <li>Revisión pre-compra (peritaje)</li>
                            <li>Auxilio mecánico y traslado</li>
                        </ul>
                    </article>
                </aside>
            </section>

            <!-- Cinta CTA inferior -->
            <div class="cta-strip">
                <span>¿Necesitas una evaluación hoy?</span>
                <a class="btn btn--dark" href="https://wa.me/51973698798" target="_blank" rel="noopener">Escríbenos por WhatsApp</a>
            </div>
        </main>

        <!-- ====== FOOTER ====== -->
        <footer class="footer">
            <div class="container footer__inner">
                <small>© <%= java.time.Year.now()%> AZ Mecánica — Todos los derechos reservados</small>
            </div>
            <a class="wa-fab" href="https://wa.me/51973698798" target="_blank" rel="noopener" aria-label="WhatsApp">💬</a>
        </footer>

        <!-- ====== JS menú móvil (mismo patrón) ====== -->
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
