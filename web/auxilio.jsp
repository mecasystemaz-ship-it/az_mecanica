<%-- 
    Document   : Auxilio
    Created on : 16 oct. 2025
    Author     : Usuario
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Auxilio Mecánico | AZ Mecánica</title>

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
      <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link is-active">Auxilio</a>
      <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link">Localizacion</a>
    </div>
  </nav>
</header>

    <!-- Banner centrado y ancho igual a las tarjetas -->
<div class="banner-wrapper">
  <div class="container">
    <img src="${pageContext.request.contextPath}/imgs/imgcar11.jpg"
         alt="Auxilio 24 horas"
         class="banner-aux__img">
  </div>
</div>
         
<!-- ====== TÍTULO ====== -->
<main class="container content">
         
  <header class="content__header">
    <h1 class="content__title">Auxilio mecánico y asesoramiento técnico</h1>
  </header>

  <!-- ====== BLOQUES NUMERADOS ====== -->
  <section style="margin:1rem 0; display:grid; gap:1rem;">
    <!-- ITEM 01 -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">
        01
      </div>
      <div style="padding:.5rem .5rem;">
        <h3 class="card__title" style="text-transform:none; color:var(--ink); margin-top:.25rem;">
          Auxilio mecánico 24 horas
        </h3>
        <p class="card__text">
          Llegamos a ti. Realizamos asistencia en ruta para vehículos livianos y de trabajo: cambio de neumáticos,
          paso de corriente, revisión de niveles, detección de fugas y fallas eléctricas básicas. Si el problema requiere
          taller, coordinamos traslado seguro. Atención ágil y transparente, 24/7.
        </p>
      </div>
    </article>

    <!-- ITEM 02 -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">
        02
      </div>
      <div style="padding:.5rem .5rem;">
        <h3 class="card__title" style="text-transform:none; color:var(--ink); margin-top:.25rem;">
          Asesoramiento técnico para adquisición de vehículos
        </h3>
        <p class="card__text">
          ¿Compras un vehículo? Te acompañamos con inspección mecánica y electrónica previa, lectura de escáner,
          verificación de fugas, pruebas dinámicas y estimación de mantenimientos próximos. Recibe un informe claro
          para decidir con confianza y evitar gastos ocultos.
        </p>
      </div>
    </article>
  </section>

  <!-- Cinta CTA inferior -->
  <div class="cta-strip">
    <span>¿Necesitas auxilio ahora mismo?</span>
    <a class="btn btn--dark" href="https://wa.me/51947340388"" target="_blank" rel="noopener">Contactar por WhatsApp</a>
  </div>
</main>

<!-- ====== FOOTER ====== -->
<footer class="footer">
  <div class="container footer__inner">
    <small>© <%= java.time.Year.now() %> AZ Mecánica — Auxilio y asesoramiento</small>
  </div>

  <a class="wa-fab" href="https://wa.me/51947340388"" target="_blank" rel="noopener" aria-label="WhatsApp">💬</a>
</footer>

<!-- JS menú móvil (mismo de mantenimiento) -->
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