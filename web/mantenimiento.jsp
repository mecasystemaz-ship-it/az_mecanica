<%-- 
    Document   : Mantenimiento
    Created on : 16 oct. 2025, 9:16:58 p. m.
    Author     : Usuario
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimiento Preventivo | AZ Mecánica</title>

    <!-- CSS EXTERNO -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css">
    <!-- (Opcional) Fuente del sistema para mejor render -->
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>

<!-- ====== HEADER ====== -->
<header class="topbar">
    <div class="container topbar__inner">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Inicio">
            <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="Logo AZ" class="brand__img">
        </a>

        <a href="tel:+51947340388" class="phone-badge">Llámanos: +51 947 340 388</a>

        <button class="menu-btn" aria-label="Abrir menú" aria-expanded="false" aria-controls="mainnav">
            ☰
        </button>
    </div>

    <nav id="mainnav" class="nav">
        <div class="container nav__list">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav__link">Principal</a>
            <a href="${pageContext.request.contextPath}/reparacion.jsp" class="nav__link">Reparacion</a>
            <a href="${pageContext.request.contextPath}/mantenimiento.jsp" class="nav__link is-active">Mantenimiento</a>
            <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link">Auxilio</a>
            <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link">Localizacion</a>
        </div>
    </nav>
</header>

<!-- ====== HERO/GALERÍA ====== -->
<section class="gallery container">
    <!-- Insertar tus imágenes -->
    <img src="${pageContext.request.contextPath}/imgs/imgcar1.jpg" alt="Volante vehículo" class="gallery__img">
    <img src="${pageContext.request.contextPath}/imgs/imgcar2.jpg" alt="Panel vehículo" class="gallery__img">
    <img src="${pageContext.request.contextPath}/imgs/imgcar10.jpg" alt="Escáner automotriz" class="gallery__img">
</section>

<!-- ====== CUERPO PRINCIPAL ====== -->
<main class="container content">
    <header class="content__header">
        <h1 class="content__title">Mantenimiento preventivo</h1>
    </header>

    <div class="content__grid">
        <article class="content__text">
            <p>
                El mantenimiento preventivo es un servicio periódico y cuidadoso que se hace al vehículo con el objetivo
                de conservar su seguridad, rendimiento y vida útil. Incluye la revisión de niveles, el cambio de fluidos
                y filtros, el ajuste de componentes críticos y el escaneo electrónico para detectar fallas latentes.
                Realizarlo de manera oportuna evita averías costosas, mejora el consumo de combustible y mantiene
                la garantía de fábrica cuando aplica.
            </p>
            <p>
                En AZ Mecánica trabajamos con procedimientos estandarizados, repuestos de calidad y técnicos
                calificados. Recomendamos un plan según kilometraje, estilo de conducción y uso del vehículo.
            </p>
        </article>

        <aside class="content__cta">
            <a class="btn btn--accent" href="tel:+51947340388">¡Llámanos hoy!</a>
        </aside>
    </div>

    <!-- ====== TARJETAS DE SERVICIO ====== -->
    <section class="cards">
        <article class="card">
            <div class="card__icon" aria-hidden="true">⚙️</div>
            <h3 class="card__title">Revisión y cambio de fluidos y filtros</h3>
            <p class="card__text">
                Cambio de aceite y filtro de motor, revisión de niveles (frenos, refrigerante, dirección, transmisión),
                filtro de aire y de cabina. Se usa la viscosidad y especificación adecuada para tu vehículo.
            </p>
        </article>

        <article class="card">
            <div class="card__icon" aria-hidden="true">🧰</div>
            <h3 class="card__title">Ajustamiento, revisión y cambio de componentes</h3>
            <p class="card__text">
                Inspección de frenos, suspensión, dirección y correas; verificación de luces y limpiaparabrisas; par de
                apriete en elementos críticos. Se recomienda cambio cuando la medición supera los límites de desgaste.
            </p>
        </article>

        <article class="card">
            <div class="card__icon" aria-hidden="true">🧪</div>
            <h3 class="card__title">Escaneo electrónico completo</h3>
            <p class="card__text">
                Diagnóstico con escáner OBD para lectura/borrado de códigos, pruebas de actuadores y datos en vivo.
                Permite anticipar fallas de sensores, sistema de encendido, mezcla, ABS y más.
            </p>
        </article>
    </section>

    <!-- Cinta CTA inferior -->
    <div class="cta-strip">
        <span>¿Listo para tu próximo mantenimiento?</span>
        <a class="btn btn--dark" href="https://wa.me/51947340388"" target="_blank" rel="noopener">Agendar por WhatsApp</a>
    </div>
</main>

<!-- ====== FOOTER ====== -->
<footer class="footer">
    <div class="container footer__inner">
        <small>© <%= java.time.Year.now() %> AZ Mecánica — Mantenimiento preventivo</small>
    </div>

    <!-- Botón flotante WhatsApp -->
    <a class="wa-fab" href="https://wa.me/51947340388" target="_blank" rel="noopener" aria-label="WhatsApp">
        💬
    </a>
</footer>

<!-- JS opcional para menú móvil -->
<script>
    (function(){
        const btn = document.querySelector('.menu-btn');
        const nav = document.getElementById('mainnav');
        if(btn && nav){
            btn.addEventListener('click', () => {
                const open = nav.classList.toggle('is-open');
                btn.setAttribute('aria-expanded', open ? 'true' : 'false');
            });
        }
    })();
</script>
</body>
</html>