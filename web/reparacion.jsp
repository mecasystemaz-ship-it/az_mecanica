<%-- 
    Document   : reparacion.jsp
    Created on : 16 oct. 2025
    Author     : Usuario
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Servicios de Reparación | AZ Mecánica</title>

  <!-- MISMO CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>

<!-- ====== HEADER ====== -->
<header class="topbar">
  <div class="container topbar__inner">
    <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Inicio">
      <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="Logo AZ" class="brand__img">
    </a>

    <a href="tel:+51973608798" class="phone-badge">Llámanos: 973 608 798</a>

    <button class="menu-btn" aria-label="Abrir menú" aria-expanded="false" aria-controls="mainnav">☰</button>
  </div>

  <nav id="mainnav" class="nav">
    <div class="container nav__list">
      <a href="${pageContext.request.contextPath}/index.jsp" class="nav__link">Principal</a>
      <a href="${pageContext.request.contextPath}/reparacion.jsp" class="nav__link is-active">Reparacion</a>
      <a href="${pageContext.request.contextPath}/mantenimiento.jsp" class="nav__link">Mantenimiento</a>
      <a href="${pageContext.request.contextPath}/auxilio.jsp" class="nav__link">Auxilio</a>
      <a href="${pageContext.request.contextPath}/localizacion.jsp" class="nav__link">Localizacion</a>
    </div>
  </nav>
</header>

<!-- ====== HERO (2 imágenes) ====== -->
<section class="gallery container" 
         style="display:grid; grid-template-columns:repeat(2, 1fr); gap:1rem; align-items:center;">
  <img src="${pageContext.request.contextPath}/imgs/imgcar3.jpg" 
       alt="Reparación de motor" 
       class="gallery__img" 
       style="width:100%; height:auto; border-radius:10px; object-fit:cover;">

  <img src="${pageContext.request.contextPath}/imgs/imgcar.jpg" 
       alt="Taller AZ" 
       class="gallery__img" 
       style="width:100%; height:auto; border-radius:10px; object-fit:cover;">
</section>


<!-- ====== CONTENIDO ====== -->
<main class="container content">
  <!-- Faja de título -->
  <header class="content__header">
    <h1 class="content__title">Servicios de reparación</h1>
  </header>

  <!-- Intro + CTA -->
  <section class="content__grid" style="grid-template-columns: 1fr 220px;">
    <article class="content__text">
      <p>
        Atendemos fallas mecánicas y eléctricas populares en auto, pick up y SUV. De motor a frenos, de dirección
        a suspensión y transmisión. Diagnosticamos con escáner OBD, mediciones y pruebas dinámicas; trabajamos
        con repuestos de calidad y mano de obra garantizada.
      </p>
    </article>
    <aside class="content__cta" style="justify-content:flex-end;">
      <a class="btn btn--accent" href="tel:+51973608798">Llámanos ahora</a>
    </aside>
  </section>

  <!-- ====== LISTA DE PROBLEMAS (01–05) ====== -->
  <section style="margin:1rem 0; display:grid; gap:1rem;">
    <!-- 01 Motor -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">01</div>
      <div style="padding:.6rem;">
        <h3 class="card__title" style="text-transform:none; color:#fff;">Problemas en el motor</h3>
        <p class="card__text">Pérdida de potencia, consumo elevado, fallas de encendido, fugas de aceite/agua, sobrecalentamiento, sensores y actuadores.</p>
      </div>
    </article>

    <!-- 02 Dirección -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">02</div>
      <div style="padding:.6rem;">
        <h3 class="card__title" style="text-transform:none; color:#fff;">Problemas en el sistema de dirección</h3>
        <p class="card__text">Holguras, vibraciones, ruidos, fugas en cremallera, bomba hidráulica, alineación y balanceo asociado.</p>
      </div>
    </article>

    <!-- 03 Suspensión -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">03</div>
      <div style="padding:.6rem;">
        <h3 class="card__title" style="text-transform:none; color:#fff;">Problemas en el sistema de suspensión</h3>
        <p class="card__text">Amortiguadores, bujes, rótulas, bieletas, resortes y soportes. Eliminamos ruidos y mejoramos estabilidad/comfort.</p>
      </div>
    </article>

    <!-- 04 Frenos -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">04</div>
      <div style="padding:.6rem;">
        <h3 class="card__title" style="text-transform:none; color:#fff;">Problemas en el sistema de freno</h3>
        <p class="card__text">Pastillas y zapatas, discos y tambores, bombas y cilindros, fugas, ABS/ESC, rectificado y purgado.</p>
      </div>
    </article>

    <!-- 05 Transmisión -->
    <article class="card" style="display:grid; grid-template-columns:90px 1fr; align-items:start; border:2px solid var(--accent);">
      <div style="display:grid; place-items:center; padding:.75rem; border-right:2px solid var(--accent); font-weight:800; font-size:2rem; color:var(--accent);">05</div>
      <div style="padding:.6rem;">
        <h3 class="card__title" style="text-transform:none; color:#fff;">Problemas en el sistema de transmisión</h3>
        <p class="card__text">Embrague, caja manual/automática, homocinéticas, retenes, fugas y vibraciones en tren motriz.</p>
      </div>
    </article>
  </section>

  <!-- Cinta CTA inferior -->
  <div class="cta-strip">
    <span>¿Listo para agendar tu diagnóstico?</span>
    <a class="btn btn--dark" href="https://wa.me/51973608798" target="_blank" rel="noopener">Escríbenos</a>
  </div>
</main>

<!-- ====== FOOTER ====== -->
<footer class="footer">
  <div class="container footer__inner">
    <small>© <%= java.time.Year.now() %> AZ Mecánica — Reparación</small>
  </div>
  <a class="wa-fab" href="https://wa.me/51973608798" target="_blank" rel="noopener" aria-label="WhatsApp">💬</a>
</footer>

<!-- JS menú móvil -->
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
