<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
  <style>
    .grid { display:grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: .75rem; }
    .grid .full { grid-column: 1 / -1; }
    .btn { padding:.55rem .9rem; border-radius:.65rem; border:1px solid var(--border); background:var(--card); color:var(--ink); cursor:pointer; }
    .btn-primary { background: var(--accent); color: var(--accent-ink); border-color: var(--accent); font-weight:600; }
    input { background:#fff; color:#000; padding:.55rem .7rem; border-radius:.5rem; border:1px solid var(--border);}
    label { color:var(--muted); font-size:.95rem; }
  </style>
</head>
<body>
<header class="topbar">
  <nav class="tabs">
    <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
  </nav>
</header>

<main class="container">
  <h2><c:choose><c:when test="${cliente != null && cliente.dni != null}">Editar Cliente</c:when><c:otherwise>Nuevo Cliente</c:otherwise></c:choose></h2>

  <form method="post" action="${pageContext.request.contextPath}/clientes" class="grid">
    <c:choose>
      <c:when test="${cliente != null && cliente.dni != null}">
        <input type="hidden" name="update" value="true"/>
        <label>DNI</label>
        <input name="dni" value="${cliente.dni}" readonly/>
      </c:when>
      <c:otherwise>
        <input type="hidden" name="update" value="false"/>
        <label>DNI</label>
        <input name="dni" required maxlength="8" />
      </c:otherwise>
    </c:choose>

    <label>Nombres</label>
    <input name="nombre" value="${cliente.nombre}" required />
    <label>Apellidos</label>
    <input name="apellido" value="${cliente.apellido}" required />
    <label>Teléfono</label>
    <input name="telefono" value="${cliente.telefono}" />
    <label>Email</label>
    <input type="email" name="email" value="${cliente.email}" />
    <label class="full">Dirección</label>
    <input class="full" name="direccion" value="${cliente.direccion}" />

    <div class="full" style="display:flex; gap:.5rem;">
      <button class="btn btn-primary" type="submit">Guardar</button>
      <a class="btn" href="${pageContext.request.contextPath}/clientes">Cancelar</a>
    </div>
  </form>
</main>
</body>
</html>
