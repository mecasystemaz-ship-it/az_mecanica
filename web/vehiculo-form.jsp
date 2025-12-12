<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Vehículo</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">
        <c:choose>
          <c:when test="${modo eq 'editar'}">Editar vehículo</c:when>
          <c:otherwise>Registrar vehículo</c:otherwise>
        </c:choose>
      </span>
    </div>
    <!-- Volver SIEMPRE al servlet de listado -->
    <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos">← Volver</a>
  </div>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2 id="title">
        <c:choose>
          <c:when test="${modo eq 'editar'}">Editar vehículo</c:when>
          <c:otherwise>Registrar vehículo</c:otherwise>
        </c:choose>
      </h2>
      <span class="form-badge">Ficha</span>
    </div>

    

    <!-- FORM CONECTADO AL SERVLET -->
    <form id="formVehiculo"
          class="form"
          action="${pageContext.request.contextPath}/vehiculos"
          method="post">

      <!-- Modo: crear | editar (lo setea el servlet) -->
      <input type="hidden" name="modo" value="${modo}"/>

      <!-- ===== Relación con Cliente ===== -->
      <div class="row col-12">
        <label class="label" for="dni_cliente">DNI del cliente</label>
        <!-- Debe existir en clientes.dni (FK) -->
        <input class="input" id="dni_cliente" name="dni_cliente"
               maxlength="8" pattern="\\d{8}"
               value="${vehiculo.dniCliente}"
               placeholder="Ej. 12345678" required>
      </div>

      <!-- ===== Datos del vehículo ===== -->
      <div class="row col-4">
        <label class="label" for="placa">Placa</label>
        <input class="input" id="placa" name="placa"
               value="${vehiculo.placa}"
               placeholder="ABC-123" required
               <c:if test="${modo eq 'editar'}">readonly</c:if>>
      </div>

      <div class="row col-4">
        <label class="label" for="marca">Marca</label>
        <input class="input" id="marca" name="marca"
               value="${vehiculo.marca}"
               placeholder="Kia / Toyota…" required>
      </div>

      <div class="row col-4">
        <label class="label" for="modelo">Modelo</label>
        <input class="input" id="modelo" name="modelo"
               value="${vehiculo.modelo}"
               placeholder="Rio / Hilux…" required>
      </div>

      <div class="row col-4">
        <label class="label" for="tipo">Tipo</label>
        <select class="select" id="tipo" name="tipo" required>
          <option value="">—</option>
          <option ${vehiculo.tipo=='Sedán' ? 'selected' : ''}>Sedán</option>
          <option ${vehiculo.tipo=='SUV' ? 'selected' : ''}>SUV</option>
          <option ${vehiculo.tipo=='Pick-up' ? 'selected' : ''}>Pick-up</option>
          <option ${vehiculo.tipo=='Hatchback' ? 'selected' : ''}>Hatchback</option>
          <option ${vehiculo.tipo=='Van' ? 'selected' : ''}>Van</option>
        </select>
      </div>

      <div class="row col-4">
        <label class="label" for="anio">Año</label>
        <input class="input" id="anio" name="anio" type="number"
               min="1970" max="2099"
               value="${vehiculo.anio}"
               placeholder="2021">
      </div>

      <div class="row col-4">
        <label class="label" for="color">Color</label>
        <input class="input" id="color" name="color"
               value="${vehiculo.color}"
               placeholder="Rojo / Negro…">
      </div>

      <div class="row col-4">
        <label class="label" for="combustible">Combustible</label>
        <select class="select" id="combustible" name="combustible">
          <option value="">—</option>
          <option ${vehiculo.combustible=='Gasolina' ? 'selected' : ''}>Gasolina</option>
          <option ${vehiculo.combustible=='Diésel' ? 'selected' : ''}>Diésel</option>
          <option ${vehiculo.combustible=='GLP' ? 'selected' : ''}>GLP</option>
          <option ${vehiculo.combustible=='GNV' ? 'selected' : ''}>GNV</option>
          <option ${vehiculo.combustible=='Eléctrico' ? 'selected' : ''}>Eléctrico</option>
        </select>
      </div>

      <div class="row col-4">
        <label class="label" for="num_motor">N. Motor</label>
        <!-- OJO: el name exacto es num_motor (snake), el bean/EL es vehiculo.numMotor (camel) -->
        <input class="input" id="num_motor" name="num_motor"
               value="${vehiculo.numMotor}"
               placeholder="V-9879">
      </div>

      <div class="row col-4">
        <label class="label" for="kilometraje">Kilometraje</label>
        <input class="input" id="kilometraje" name="kilometraje" type="number" min="0"
               value="${vehiculo.kilometraje}"
               placeholder="Ej. 45000">
      </div>

      <div class="row col-4">
        <label class="label" for="soat">SOAT</label>
        <input class="input" id="soat" name="soat"
               value="${vehiculo.soat}"
               placeholder="Vigente / Fecha / Código">
      </div>

      <div class="row col-12">
        <label class="label" for="tarjeta_propietario">Tarjeta de Propiedad</label>
        <input class="input" id="tarjeta_propietario" name="tarjeta_propietario"
               value="${vehiculo.tarjetaPropietario}"
               placeholder="N° de tarjeta o referencia">
      </div>

      <div class="subtle col-12">
        * Este formulario guarda en la tabla <code>vehiculos</code> usando el
        <code>VehiculoServlet</code>. Asegúrate de que el <strong>DNI del cliente</strong> exista.
      </div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos">Cancelar</a>
      </div>
    </form>
  </section>
</main>

</body>
</html>
