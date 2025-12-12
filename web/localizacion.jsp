<%-- 
    Document   : Localizacion
    Created on : 16 oct. 2025
    Author     : Usuario
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Localización | AZ Mecánica</title>

  <!-- MISMO CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>

<!-- ====== HEADER ====== -->
<header class="topbar">
  <div class="container topbar__inner">
    <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Inicio">
      <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="Logo AZ" class="brand__img">
    </a>

    <a href="tel:+51947340388"" class="phone-badge">Llámanos: +51 947 340 388</a>

    <button class="menu-btn" aria-label="Abrir menú" aria-expanded="false" aria-controls="mainnav">☰</button>
  </div>

  <nav id="mainnav" class="nav">
    <div class="container nav__list">
      <a href="${pageContext.request.contextPath}/index.jsp" class="nav__link">Principal</a>
      <a href="${pageContext.request.contextPath}/reparacion.jsp" class="nav__link">Reparacion</a>
      <a href="${pageContext.request.contextPath}/mantenimiento.jsp" class="nav__link">Mantenimiento</a>
      <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link">Auxilio</a>
      <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link is-active">Localizacion</a>
    </div>
  </nav>
</header>

<!-- ====== TÍTULO ====== -->
<main class="container content">
  <header class="content__header">
    <h1 class="content__title">Localización</h1>
  </header>

  <!-- ====== GRID: INFO + MAPA ====== -->
  <section class="content__grid" style="grid-template-columns: 360px 1fr;">
    <!-- Columna izquierda: datos -->
    <aside class="content__text" style="padding-right:.5rem;">
      <h3 style="margin:.2rem 0 1rem; color:#fff; letter-spacing:.5px;">Estamos en:</h3>

      <p style="margin:.35rem 0;">
        <strong>AZ-MH Horacio Zeballos Gámez</strong><br>
        Mz. Z-12, Mz “Sección 2” Zona B,<br>
        Cercado – Arequipa
      </p>

      <p style="margin:.35rem 0;">
        <strong>Referencias:</strong><br>
        Accidente de Tránsito, Mecánicas y Auxilio Mecánico las 24 horas
      </p>

      <p style="margin:.35rem 0;">
        <strong>973698798</strong><br>
        Henry Añazco
      </p>

      <p style="margin:.35rem 0;">
        <strong>947340388</strong><br>
        Jesús Añazco
      </p>

      <a class="btn btn--accent" href="tel:+51973698798" style="display:inline-block; margin-top:.75rem;">¡Llámanos ahora!</a>
    </aside>

    <!-- Columna derecha: mapa -->
    <div style="background:#0f0f12; border:1px solid var(--border); border-radius:.35rem; overflow:hidden;">
      <!-- Reemplaza el src con tu iframe de Google Maps si corresponde -->
      <iframe 
        title="Ubicación AZ Mecánica"
        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3834.051657228211!2d-71.540!3d-16.398!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2sArequipa!5e0!3m2!1ses!2spe!4v1700000000000"
        width="100%" height="420" style="border:0;" allowfullscreen="" loading="lazy"
        referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>
  </section>

  <!-- Cinta CTA inferior -->
  <div class="cta-strip" style="margin-top:1rem;">
    <span>¿Necesitas dirección o envío de ubicación por WhatsApp?</span>
    <a class="btn btn--dark" href="https://wa.me/51947340388"" target="_blank" rel="noopener">Contáctanos</a>
  </div>
</main>

<!-- ====== FOOTER ====== -->
<footer class="footer">
  <div class="container footer__inner">
    <small>© <%= java.time.Year.now() %> AZ Mecánica — contacto: <span style="color:#ffd76a;">azmecanica@gmail.com</span></small>
  </div>

  <a class="wa-fab" href="https://wa.me/51947340388"" target="_blank" rel="noopener" aria-label="WhatsApp">💬</a>
</footer>

<!-- JS menú móvil (mismo de las otras páginas) -->
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