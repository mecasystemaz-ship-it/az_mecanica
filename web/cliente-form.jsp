<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
  String rolGuard = (String) session.getAttribute("rol");
  if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Cliente</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body class="bg">

<c:set var="editing" value="${not empty cliente}" />

<header class="topbar">
  <div class="brand">
    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
    <span id="title"><c:out value="${editing ? 'Editar cliente' : 'Registrar cliente'}"/></span>
  </div>
  <a class="btn btn-outline" href="${pageContext.request.contextPath}/clientes">← Volver</a>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2 id="title"><c:out value="${editing ? 'Editar cliente' : 'Registrar cliente'}"/></h2>
      <span class="form-badge">Ficha</span>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-error">${error}</div>
    </c:if>

    <!-- FORM REAL: guarda/actualiza vía ClienteServlet -->
    <form id="formCliente" method="post" action="${pageContext.request.contextPath}/clientes">
      <input type="hidden" name="action" value="guardar"/>

      <!-- DNI -->
      <div class="row col-6">
        <label class="label">DNI</label>
        <input class="input"
               name="dni"
               value="${editing ? cliente.dni : ''}"
               pattern="[0-9]{8}" maxlength="8"
               placeholder="00000000"
               required
               <c:if test="${editing}">readonly</c:if>>
      </div>

      <!-- Nombres -->
      <div class="row col-6">
        <label class="label">Nombres</label>
        <input class="input"
               name="nombre"
               value="${editing ? cliente.nombre : ''}"
               required
               placeholder="Nombres del cliente">
      </div>

      <!-- Apellidos -->
      <div class="row col-6">
        <label class="label">Apellidos</label>
        <input class="input"
               name="apellido"
               value="${editing ? cliente.apellido : ''}"
               required
               placeholder="Apellidos del cliente">
      </div>

      <!-- Teléfono -->
      <div class="row col-6">
        <label class="label">Teléfono</label>
        <input class="input"
               name="telefono"
               value="${editing ? cliente.telefono : ''}"
               placeholder="999888777">
      </div>

      <!-- Correo -->
      <div class="row col-12">
        <label class="label">Correo</label>
        <input class="input"
               name="email"
               type="email"
               value="${editing ? cliente.email : ''}"
               placeholder="correo@dominio.com">
      </div>

      <!-- Dirección -->
      <div class="row col-12">
        <label class="label">Dirección</label>
        <input class="input"
               name="direccion"
               value="${editing ? cliente.direccion : ''}"
               placeholder="Calle, número, barrio">
      </div>

      <!-- Acciones -->
      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">
          <c:out value="${editing ? 'Actualizar' : 'Guardar'}"/>
        </button>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/clientes">Cancelar</a>
      </div>
    </form>

  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>
</body>
</html>
