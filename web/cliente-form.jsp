<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>  <%-- CRÍTICO: Asegura que ${...} funcione --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 💡 Definimos la variable de título según la acción --%>
<c:choose>
    <c:when test="${action == 'edit'}">
        <c:set var="pageTitle" value="Editar Cliente"/>
    </c:when>
    <c:when test="${action == 'view'}">
        <c:set var="pageTitle" value="Ficha del Cliente"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="Registrar Cliente"/>
    </c:otherwise>
</c:choose>
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
        <header class="topbar">
            <div class="brand">
                <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                <span id="title">${pageTitle}</span> <%-- 2. Título en el topbar --%>
            </div>
            <a class="btn btn-outline" href="clientes">← Volver</a>
        </header>

        <main class="container">
            <section class="card narrow">
                <div class="form-title">
                    <h2 id="title">${pageTitle}</h2> <%-- 3. Título principal --%>
                    <span class="form-badge">Ficha</span>
                </div>

                <%-- 💡 CRÍTICO: Bloque para mostrar errores --%>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px; padding: 10px; border: 1px solid red; background-color: #ffeaea; color: red;">
                        **${error}**
                    </div>
                </c:if>

                <form id="formCliente" class="form" method="POST" action="${pageContext.request.contextPath}/clientes/guardar">

                    <div class="row col-6">
                        <label class="label">DNI</label>
                        <%-- El DNI debe ser de solo lectura en modo edición/vista para que no se cambie --%>
                        <input class="input" name="dni" pattern="[0-9]{8}" maxlength="8" placeholder="00000000" 
                               value="${cliente.dni}" 
                               ${cliente != null ? 'readonly' : ''}> 
                    </div>

                    <div class="row col-6">
                        <label class="label">Nombres</label>
                        <input class="input" name="nombres" required placeholder="Nombres del cliente" 
                               value="${cliente.nombres}">
                    </div>
                    <div class="row col-6">
                        <label class="label">Apellidos</label>
                        <input class="input" name="apellidos" required placeholder="Apellidos del cliente" 
                               value="${cliente.apellidos}">
                    </div>

                    <div class="row col-6">
                        <label class="label">Teléfono</label>
                        <input class="input" name="telefono" placeholder="999888777" 
                               value="${cliente.telefono}">
                    </div>
                    <div class="row col-12">
                        <label class="label">Correo</label>
                        <input class="input" name="correo" type="email" placeholder="correo@dominio.com" 
                               value="${cliente.correo}">
                    </div>
                    <div class="row col-12">
                        <label class="label">Dirección</label>
                        <input class="input" name="direccion" placeholder="Calle, número, barrio" 
                               value="${cliente.direccion}">
                    </div>

                    <div class="row col-3">
                        <label class="label">Origen</label>
                        <select class="select" name="origen">
                            <option value="">—</option>
                            <option ${cliente.origen == 'Orden' ? 'selected' : ''}>Orden</option>
                            <option ${cliente.origen == 'Proforma' ? 'selected' : ''}>Proforma</option>
                            <option ${cliente.origen == 'Web' ? 'selected' : ''}>Web</option>
                        </select>
                    </div>
                    <div class="row col-3">
                        <label class="label">N° Ref.</label>
                        <input class="input" name="nreferencia" placeholder="OR-0000 / PF-0000"
                               value="${cliente.nreferencia}">
                    </div>
                    <div class="row col-3">
                        <label class="label">Placa</label>
                        <input class="input" name="placa" placeholder="ABC-123"
                               value="${cliente.placa}">
                    </div>
                    <div class="row col-3">
                        <label class="label">Método</label>
                        <select class="select" name="metodo">
                            <option value="">—</option>
                            <option ${cliente.metodo == 'Efectivo' ? 'selected' : ''}>Efectivo</option>
                            <option ${cliente.metodo == 'Tarjeta' ? 'selected' : ''}>Tarjeta</option>
                            <option ${cliente.metodo == 'Yape' ? 'selected' : ''}>Yape</option>
                            <option ${cliente.metodo == 'Plin' ? 'selected' : ''}>Plin</option>
                        </select>
                    </div>

                    <div class="form-actions col-12">
                        <%-- 💡 CAMBIO: Mostrar el botón solo si la acción NO es 'view' --%>
                        <c:if test="${action != 'view'}">
                            <button type="submit" class="btn btn-primary">Guardar</button>
                        </c:if>
                    </div>
                </form>
            </section>
        </main>


        <script>
            /* --- Soporte simple para modo crear / editar / ver --- */
            const params = new URLSearchParams(location.search);
            const action = params.get('action') || 'create';
            const id = params.get('id');

            const mockById = {
                1: {nombres: 'Tyler', apellidos: 'Joseph', dni: '12345678', telefono: '987654321', correo: 'tyler@mail.com',
                    direccion: 'Av. Siempre Viva 123', origen: 'Orden', ref: 'OR-0234', placa: 'C7L-394', metodo: 'Efectivo'},
                2: {nombres: 'Luis', apellidos: 'Cáceres', dni: '87654321', telefono: '945778812', correo: 'luis@mail.com',
                    direccion: 'Mz B Lt 3', origen: 'Proforma', ref: 'PF-1045', placa: 'BDP-213', metodo: 'Tarjeta'}
            };

            const form = document.getElementById('formCliente');
            const title = document.getElementById('title');

            if (action === 'edit' || action === 'view') {
                const data = mockById[id];
                if (data) {
                    for (const k in data) {
                        const input = form.querySelector(`[name="${k}"]`);
                        if (input)
                            input.value = data[k];
                    }
                }
                title.textContent = action === 'view' ? 'Ficha del cliente' : 'Editar cliente';
                if (action === 'view') {
                    [...form.elements].forEach(el => el.disabled = true);
                }
            }


        </script>
    </body>
</html>
