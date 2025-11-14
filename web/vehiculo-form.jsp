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
  <title>AZ Mecánica | Vehículo</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <style>
    .grid { display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: .75rem; }
    .grid .full { grid-column: 1 / -1; }
    .btn { padding:.55rem .9rem; border-radius:.65rem; border:1px solid var(--border); background:var(--card); color:var(--ink); cursor:pointer; }
    .btn-primary { background: var(--accent); color: var(--accent-ink); border-color: var(--accent); font-weight:600; }
    input, select { background:#fff; color:#000; padding:.55rem .7rem; border-radius:.5rem; border:1px solid var(--border);}
    label { color:var(--muted); font-size:.95rem; }
  </style>
</head>
<body>
<header class="topbar">
  <nav class="tabs">
    <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
  </nav>
</header>

<main class="container">
  <h2><c:choose><c:when test="${vehiculo != null && vehiculo.placa != null}">Editar Vehículo</c:when><c:otherwise>Nuevo Vehículo</c:otherwise></c:choose></h2>

  <form method="post" action="${pageContext.request.contextPath}/vehiculos" class="grid">
    <c:choose>
      <c:when test="${vehiculo != null && vehiculo.placa != null}">
        <input type="hidden" name="update" value="true"/>
        <label>Placa</label>
        <input name="placa" value="${vehiculo.placa}" readonly/>
      </c:when>
      <c:otherwise>
        <input type="hidden" name="update" value="false"/>
        <label>Placa</label>
        <input name="placa" required maxlength="10"/>
      </c:otherwise>
    </c:choose>

    <label>Marca</label>
    <input name="marca" value="${vehiculo.marca}" />
    <label>Tipo</label>
    <input name="tipo" value="${vehiculo.tipo}" />
    <label>Modelo</label>
    <input name="modelo" value="${vehiculo.modelo}" />
    <label>Año</label>
    <input name="anio" type="number" value="${vehiculo.anio}" />
    <label>Color</label>
    <input name="color" value="${vehiculo.color}" />
    <label>Combustible</label>
    <input name="combustible" value="${vehiculo.combustible}" />
    <label>Num. Motor</label>
    <input name="num_motor" value="${vehiculo.numMotor}" />
    <label>Kilometraje</label>
    <input name="kilometraje" type="number" value="${vehiculo.kilometraje}" />
    <label>SOAT</label>
    <input name="soat" value="${vehiculo.soat}" />
    <label>Tarjeta Propietario</label>
    <input name="tarjeta_propietario" value="${vehiculo.tarjetaPropietario}" />
    <label>DNI Cliente</label>
    <input name="dni_usuario" value="${vehiculo.dniUsuario}" required />

    <div class="full" style="display:flex; gap:.5rem;">
      <button class="btn btn-primary" type="submit">Guardar</button>
      <a class="btn" href="${pageContext.request.contextPath}/vehiculos">Cancelar</a>
    </div>
  </form>
</main>
</body>
</html>
