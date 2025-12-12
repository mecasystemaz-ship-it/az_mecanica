<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
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
  <title>AZ Mecánica | Vehículos</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Vehículos</span>
    </div>
    <!-- Tip: idealmente haz un LogoutServlet -->
    <a class="btn btn-outline" href="${pageContext.request.contextPath}/login.jsp">Cerrar sesión</a>
  </div>
</header>

<nav class="tabs">
  <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
  <a>Registro de Pagos</a>
  <a>Productos</a>
  <a>Inventario</a>
  <a href="${pageContext.request.contextPath}/citas.jsp">Citas</a>
  <a href="${pageContext.request.contextPath}/servicios.jsp">Servicios</a>
  <a href="${pageContext.request.contextPath}/clientes.jsp">Clientes</a>
  <a class="active">Vehículos</a>
</nav>

<main class="container">

  <!-- Flash message ?msg=... -->
  <c:if test="${not empty param.msg}">
    <div class="alert">${fn:escapeXml(param.msg)}</div>
  </c:if>

  <!-- ===== Barra de búsqueda + Nuevo ===== -->
  <section class="card" id="buscador">
    <div class="section-head">
      <h2>Buscar vehículos</h2>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/vehiculos?accion=nuevo">+ Añadir vehículo</a>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/vehiculos" class="filters">
      <input type="text" name="q" value="${q}" placeholder="Placa, marca, modelo o DNI cliente">
      <button class="btn btn-primary" type="submit">Aplicar</button>
      <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos">Limpiar</a>
    </form>
  </section>

  <!-- ===== Últimos (primeros 4 del listado actual) ===== -->
  <section class="card" id="ultimos">
    <div class="section-head">
      <h2>Tabla de últimos vehículos</h2>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable">
        <colgroup>
          <col style="width:14%"><col style="width:14%"><col style="width:14%">
          <col style="width:12%"><col style="width:10%"><col style="width:12%"><col style="width:12%"><col style="width:12%">
        </colgroup>
        <thead>
        <tr>
          <th>DNI Cliente</th>
          <th>Marca</th>
          <th>Modelo</th>
          <th>Tipo</th>
          <th>Año</th>
          <th>Color</th>
          <th>Placa</th>
          <th class="ta-center">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty lista}">
          <tr><td colspan="8" class="empty">No hay vehículos.</td></tr>
        </c:if>
        <c:forEach var="v" items="${lista}" varStatus="st">
          <c:if test="${st.index < 4}">
            <tr>
              <td>${v.dniCliente}</td>
              <td>${v.marca}</td>
              <td>${v.modelo}</td>
              <td><span class="tag">${v.tipo}</span></td>
              <td>${v.anio}</td>
              <td>${v.color}</td>
              <td><strong class="money">${v.placa}</strong></td>
              <td class="ta-center">
                <a class="chip" href="${pageContext.request.contextPath}/vehiculos?accion=editar&placa=${v.placa}">✏</a>
                <a class="chip danger"
                   href="${pageContext.request.contextPath}/vehiculos?accion=eliminar&placa=${v.placa}"
                   onclick="return confirm('¿Eliminar ${v.placa}?')">🗑</a>
              </td>
            </tr>
          </c:if>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </section>

  <!-- ===== Historial (toda la lista) ===== -->
  <section class="card" id="historial">
    <div class="section-head">
      <h2>Historial de vehículos</h2>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable" id="tablaHistorial" data-empty="No hay vehículos para el filtro.">
        <thead>
        <tr>
          <th>DNI Cliente</th>
          <th>Marca</th>
          <th>Modelo</th>
          <th>Tipo</th>
          <th>Año</th>
          <th>Color</th>
          <th>Placa</th>
          <th class="ta-center">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty lista}">
          <tr><td colspan="8" class="empty">${fn:escapeXml(requestScope['tablaHistorial.empty'] != null ? requestScope['tablaHistorial.empty'] : 'No hay vehículos para el filtro.')}</td></tr>
        </c:if>
        <c:forEach var="v" items="${lista}">
          <tr>
            <td>${v.dniCliente}</td>
            <td>${v.marca}</td>
            <td>${v.modelo}</td>
            <td><span class="tag">${v.tipo}</span></td>
            <td>${v.anio}</td>
            <td>${v.color}</td>
            <td><strong class="money">${v.placa}</strong></td>
            <td class="ta-center">
              <a class="chip" href="${pageContext.request.contextPath}/vehiculos?accion=editar&placa=${v.placa}">✏</a>
              <a class="chip danger"
                 href="${pageContext.request.contextPath}/vehiculos?accion=eliminar&placa=${v.placa}"
                 onclick="return confirm('¿Eliminar ${v.placa}?')">🗑</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<!-- Sin scripts de mock: toda la lógica es del servlet -->
</body>
</html>
