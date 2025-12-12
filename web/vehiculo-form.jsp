<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%> <%-- Habilita el uso de ${...} --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 💡 Definimos el título dinámicamente usando JSTL/EL --%>
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
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
    <div class="container topbar__row">
        <div class="brand">
            <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
            <span class="brand__label">${pageTitle}</span> <%-- Título dinámico --%>
        </div>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos.jsp">← Volver</a>
    </div>
</header>

<main class="container">
    <section class="card narrow">
        <div class="form-title">
            <h2 id="title">${pageTitle}</h2> <%-- Título dinámico --%>
            <span class="form-badge">Ficha</span>
        </div>

        <form id="formVehiculo" class="form" method="POST" action="${pageContext.request.contextPath}/vehiculos/guardar">

            <div class="row col-12">
                <label class="label">Cliente Asociado <span class="required">*</span></label>
                <%-- El valor enviado es el DNI del cliente --%>
                <select class="select" name="dniCliente" id="selectCliente" required
                        ${param.action == 'view' ? 'disabled' : ''}>
                    <option value="">— Seleccionar Cliente —</option>

                    <%-- 💡 JSTL: Muestra el nombre y apellido del cliente (Requiere Cliente.getNombres/getApellidos) --%>
                    <c:forEach var="cliente" items="${requestScope.listaClientes}">
                        <option value="${cliente.dni}"
                            ${vehiculo.dniCliente == cliente.dni ? 'selected' : ''}>
                            ${cliente.nombres} ${cliente.apellidos} (${cliente.dni})
                        </option>
                    </c:forEach>
                </select>
                <c:if test="${param.action == 'edit'}">
                    <input type="hidden" name="placaOriginal" value="${vehiculo.placa}">
                </c:if>
            </div>

            <div class="row col-4">
                <label class="label">Placa <span class="required">*</span></label>
                <input class="input" name="placa" placeholder="ABC-123" required
                       value="${vehiculo.placa}"
                       ${param.action != 'create' ? 'readonly' : ''}>
            </div>

            <div class="row col-4">
                <label class="label">N. Motor</label>
                <input class="input" name="nMotor" placeholder="V-9879"
                       value="${vehiculo.nMotor}" ${param.action == 'view' ? 'readonly' : ''}>
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
                    <option ${vehiculo.transmision == 'Mecánica' ? 'selected' : ''}>Mecánica</option>
                    <option ${vehiculo.transmision == 'Automática' ? 'selected' : ''}>Automática</option>
                    <option ${vehiculo.transmision == 'CVT' ? 'selected' : ''}>CVT</option>
                </select>
            </div>

            <div class="form-actions col-12">
                <%-- Mostrar el botón solo si la acción NO es 'view' --%>
                <c:if test="${param.action != 'view'}">
                    <button type="submit" class="btn btn-primary">Guardar Vehículo</button>
                </c:if>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/vehiculos.jsp">Cancelar</a>
            </div>
        </form>
    </section>
</main>

<script>
    // --- Mock Data para Clientes (para propósitos de demo) ---
    const mockClientes = [
        { dni: '12345678', nombres: 'Tyler', apellidos: 'Joseph' },
        { dni: '87654321', nombres: 'Luis', apellidos: 'Cáceres' },
        { dni: '99887766', nombres: 'Clara', apellidos: 'Rojas' }
    ];

    // --- Mock Data para Vehículos (simulando que el Servlet ya lo precargó en ${vehiculo}) ---
    const mockVehiculosByPlaca = {
        'C7L-394': { dniCliente: '12345678', marca:'Kia', modelo:'Rio', tipo:'Sedán', anio:2021, color:'Rojo', combustible:'Gasolina', transmision:'Automática', placa:'C7L-394', nMotor:'V-9879', vin:'KNADH123456789012'},
        'BDP-213': { dniCliente: '87654321', marca:'Hyundai', modelo:'Elantra', tipo:'Sedán', anio:2018, color:'Plata', combustible:'Gasolina', transmision:'Mecánica', placa:'BDP-213', nMotor:'X-1223', vin:'KMHAB123456789012'}
    };

    // --- Lógica JS de Demo (Corregida para asegurar la visualización del nombre) ---
    const params = new URLSearchParams(location.search);
    const action = params.get('action') || 'create';
    const placa = params.get('id');

    const form = document.getElementById('formVehiculo');
    const selectCliente = document.getElementById('selectCliente');

    // 1. Llenar el Select de Clientes (Solo si JSTL no lo llenó)
    if (selectCliente.options.length === 1) {
        mockClientes.forEach(c => {
            const option = document.createElement('option');
            option.value = c.dni;
            // 🛑 CRÍTICO: Usar los campos nombres y apellidos. Si son nulos, usar una cadena vacía.
            option.textContent = `${c.nombres || ''} ${c.apellidos || ''} (${c.dni})`;
            selectCliente.appendChild(option);
        });
    }

    // 2. Simular precarga de datos para 'edit' o 'view'
    if(action === 'edit' || action === 'view'){
        const data = mockVehiculosByPlaca[placa];
        if(data){
            for(const k in data){
                const input = form.querySelector(`[name="${k}"]`);
                if(input) {
                    if (input.tagName === 'SELECT' || input.type === 'select-one') {
                        input.value = data[k];
                    } else {
                        input.value = data[k];
                    }
                }
            }
        }

        // Deshabilitar campos para 'view'
        if(action === 'view'){
            [...form.elements].forEach(el => {
                if (el.name !== 'placaOriginal' && el.type !== 'hidden') {
                    el.disabled = true;
                }
            });
        }
    }

    // 3. Manejo de Submit (Demo)
    form.addEventListener('submit', (e)=>{
        e.preventDefault();
        alert(`Vehículo con placa ${form.placa.value} asociado al cliente con DNI ${form.dniCliente.value} guardado (demo).`);
        location.href='${pageContext.request.contextPath}/vehiculos.jsp';
    });
</script>
</body>
</html>