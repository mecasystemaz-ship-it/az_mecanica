<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String rolGuard = (String) session.getAttribute("rol");
  if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
  String flash = (String) session.getAttribute("flash");
  if (flash != null) { session.removeAttribute("flash"); }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Clientes</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <style>
    .btn { padding:.55rem .9rem; border-radius:.65rem; border:1px solid var(--border); background:var(--card); color:var(--ink); cursor:pointer; }
    .btn-primary { background: var(--accent); color: var(--accent-ink); border-color: var(--accent); font-weight:600; }
    .btn-danger { background:#b63a3a; color:#fff; border-color:#8c2c2c; }
    .btn-link { background:transparent; border:0; color:var(--accent); text-decoration:underline; cursor:pointer; }
    .chip { background:var(--panel); border:1px solid var(--border); padding:.35rem .6rem; border-radius:999px; }
    .controls input, .controls select { background:#fff; color:#000; }
    .flash { background:#1f4f2a; border:1px solid #2d7a3f; padding:.7rem 1rem; border-radius:.6rem; margin:.75rem 0; }
    .btn-vermas { background:var(--accent); color:var(--accent-ink); border: none; padding:.4rem .7rem; border-radius:.5rem; font-weight:600; }
  </style>
</head>
<body>
<header class="topbar">
  <nav class="tabs">
    <a href="${pageContext.request.contextPath}/home.jsp">Inicio</a>
    <a class="active" href="${pageContext.request.contextPath}/clientes">Clientes</a>
    <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
  </nav>
</header>

<main class="container">
  <h2>Clientes</h2>

  <c:if test="<%= flash != null %>">
    <div class="flash"><%= flash %></div>
  </c:if>

  <form class="controls" method="get" action="${pageContext.request.contextPath}/clientes" style="display:flex; gap:.5rem; align-items:center; flex-wrap: wrap;">
    <input type="hidden" name="accion" value="listar"/>
    <label class="chip">Filtro</label>
    <input type="text" name="q" value="${q}" placeholder="Buscar por DNI, nombre o apellido" />
    <button class="btn btn-primary" type="submit">Buscar</button>
    <a class="btn" href="${pageContext.request.contextPath}/clientes">Limpiar</a>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/clientes?accion=nuevo">Nuevo Cliente</a>
  </form>

  <div class="table-wrap" style="overflow:auto; margin-top:1rem;">
    <table class="table" style="width:100%; border-collapse:collapse;">
      <thead>
      <tr style="background:var(--panel);">
        <th>DNI</th><th>Nombre</th><th>Apellido</th><th>Teléfono</th><th>Email</th><th>Dirección</th><th>Acciones</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="c" items="${lista}">
        <tr style="border-top:1px solid var(--border);">
          <td>${c.dni}</td>
          <td>${c.nombre}</td>
          <td>${c.apellido}</td>
          <td>${c.telefono}</td>
          <td>${c.email}</td>
          <td>${c.direccion}</td>
          <td style="white-space:nowrap; display:flex; gap:.4rem;">
            <a class="btn-vermas" href="${pageContext.request.contextPath}/clientes?accion=editar&dni=${c.dni}">Ver más</a>
            <a class="btn btn-danger" href="${pageContext.request.contextPath}/clientes?accion=eliminar&dni=${c.dni}"
               onclick="return confirm('¿Eliminar cliente ${c.nombre} ${c.apellido}?')">Eliminar</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty lista}">
        <tr><td colspan="7">No hay resultados.</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
