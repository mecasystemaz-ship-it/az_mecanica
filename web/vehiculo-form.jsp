<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${param.action == 'edit'}">
        <c:set var="pageTitle" value="Editar Vehículo"/>
    </c:when>
    <c:when test="${param.action == 'view'}">
        <c:set var="pageTitle" value="Ficha del Vehículo"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="Registrar Vehículo"/>
    </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Vehículo</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
    </head>
    <body class="bg">

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                    <span class="brand__label">${pageTitle}</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos.jsp">← Volver</a>
            </div>
        </header>

        <main class="container">
            <section class="card narrow">
                <div class="form-title">
                    <h2 id="title">${pageTitle}</h2>
                    <span class="form-badge">Ficha</span>
                </div>

                <form id="formVehiculo" class="form" method="POST" action="${pageContext.request.contextPath}/vehiculos/guardar">

                    <input type="hidden" name="action" value="${param.action == 'edit' ? 'update' : 'insert'}">

                    <c:if test="${param.action == 'edit'}">
                        <input type="hidden" name="placaOriginal" value="${vehiculo.placa}">
                    </c:if>

                    <div class="row col-12">
                        <label class="label">Cliente Asociado <span class="required">*</span></label>
                        <select class="select" name="dniCliente" id="selectCliente" required ${param.action == 'view' ? 'disabled' : ''}>
                            <option value="">— Seleccionar Cliente —</option>
                            <c:forEach var="cliente" items="${requestScope.listaClientes}">
                                <option value="${cliente.dni}" ${vehiculo.dniCliente == cliente.dni ? 'selected' : ''}>
                                    ${cliente.nombres} ${cliente.apellidos} (${cliente.dni})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="row col-4">
                        <label class="label">Placa <span class="required">*</span></label>
                        <input class="input" name="placa" placeholder="ABC-123" required
                               value="${vehiculo.placa}" ${param.action != 'create' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-4">
                        <label class="label">N. Motor</label>
                        <input class="input" name="nummotor" placeholder="V-9879"
                               value="${vehiculo.nummotor}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-4">
                        <label class="label">VIN</label>
                        <input class="input" name="vin" maxlength="17" placeholder="17 caracteres"
                               value="${vehiculo.vin}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-3">
                        <label class="label">Marca <span class="required">*</span></label>
                        <input class="input" name="marca" required placeholder="Kia / Toyota…"
                               value="${vehiculo.marca}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-3">
                        <label class="label">Modelo <span class="required">*</span></label>
                        <input class="input" name="modelo" required placeholder="Rio / Hilux…"
                               value="${vehiculo.modelo}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-3">
                        <label class="label">Tipo <span class="required">*</span></label>
                        <select class="select" name="tipo" required ${param.action == 'view' ? 'disabled' : ''}>
                            <option value="">—</option>
                            <option ${vehiculo.tipo == 'Sedán' ? 'selected' : ''}>Sedán</option>
                            <option ${vehiculo.tipo == 'SUV' ? 'selected' : ''}>SUV</option>
                            <option ${vehiculo.tipo == 'Pick-up' ? 'selected' : ''}>Pick-up</option>
                            <option ${vehiculo.tipo == 'Hatchback' ? 'selected' : ''}>Hatchback</option>
                            <option ${vehiculo.tipo == 'Van' ? 'selected' : ''}>Van</option>
                        </select>
                    </div>

                    <div class="row col-3">
                        <label class="label">Año</label>
                        <input class="input" name="anio" type="number" min="1970" max="2099" placeholder="2021"
                               value="${vehiculo.anio}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-4">
                        <label class="label">Color</label>
                        <input class="input" name="color" placeholder="Rojo / Negro…"
                               value="${vehiculo.color}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-4">
                        <label class="label">Combustible</label>
                        <select class="select" name="combustible" ${param.action == 'view' ? 'disabled' : ''}>
                            <option value="">—</option>
                            <option ${vehiculo.combustible == 'Gasolina' ? 'selected' : ''}>Gasolina</option>
                            <option ${vehiculo.combustible == 'Diésel' ? 'selected' : ''}>Diésel</option>
                            <option ${vehiculo.combustible == 'GLP' ? 'selected' : ''}>GLP</option>
                            <option ${vehiculo.combustible == 'GNV' ? 'selected' : ''}>GNV</option>
                            <option ${vehiculo.combustible == 'Eléctrico' ? 'selected' : ''}>Eléctrico</option>
                        </select>
                    </div>

                    <div class="row col-4">
                        <label class="label">Transmisión</label>
                        <select class="select" name="transmision" ${param.action == 'view' ? 'disabled' : ''}>
                            <option value="">—</option>
                            <option value="Mecánica" ${vehiculo.transmision == 'Mecánica' ? 'selected' : ''}>Mecánica</option>
                            <option value="Automática" ${vehiculo.transmision == 'Automática' ? 'selected' : ''}>Automática</option>
                            <option value="CVT" ${vehiculo.transmision == 'CVT' ? 'selected' : ''}>CVT</option>
                        </select>
                    </div>

                    <div class="form-actions col-12">
                        <c:if test="${param.action != 'view'}">
                            <button type="submit" class="btn btn-primary">Guardar Vehículo</button>
                        </c:if>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos">Cancelar</a>
                    </div>

                </form>
            </section>
        </main>

    </body>
</html>
