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

                    <!-- SECCIÓN CLIENTE (INTACTA) -->
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

                    <!-- DATOS VEHÍCULO -->
                    <div class="row col-6">
                        <label class="label">Placa <span class="required">*</span></label>
                        <input class="input" name="placa" placeholder="ABC-123" required
                               value="${vehiculo.placa}" ${param.action != 'create' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-6">
                        <label class="label">N. Motor</label>
                        <input class="input" name="nummotor" placeholder="V-9879"
                               value="${vehiculo.nummotor}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-6">
                        <label class="label">VIN</label>
                        <input class="input" name="vin" maxlength="17" placeholder="17 caracteres"
                               value="${vehiculo.vin}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <!-- === AQUÍ ESTÁ EL CAMBIO: MARCA CON SELECT === -->
                    <div class="row col-6">
    <label class="label">Marca <span class="required">*</span></label>
    <select class="select" name="marca" id="selectMarca" required ${param.action == 'view' ? 'disabled' : ''}>
        <option value="">— Seleccionar Marca —</option>
        <option value="Toyota">Toyota</option>
        <option value="Hyundai">Hyundai</option>
        <option value="Kia">Kia</option>
        <option value="Chevrolet">Chevrolet</option>
        <option value="Nissan">Nissan</option>
        <option value="Honda">Honda</option>
        <option value="Mazda">Mazda</option>
        <option value="Ford">Ford</option>
        <option value="Mercedes">Mercedes</option>
        <option value="BMW">BMW</option>
    </select>
</div>

                    <!-- === AQUÍ ESTÁ EL CAMBIO: MODELO CON SELECT DEPENDIENTE === -->
                    <div class="row col-6">
    <label class="label">Modelo <span class="required">*</span></label>
    <select class="select" name="modelo" id="selectModelo" required ${param.action == 'view' ? 'disabled' : ''}>
        <option value="">— Seleccione Marca primero —</option>
    </select>
</div>

                    <div class="row col-6">
    <label class="label">Tipo <span class="required">*</span></label>
    <select class="select" name="tipo" id="selectTipo" required ${param.action == 'view' ? 'disabled' : ''}>
        <option value="">—</option>
        <option value="Sedán" ${vehiculo.tipo == 'Sedán' ? 'selected' : ''}>Sedán</option>
        <option value="SUV" ${vehiculo.tipo == 'SUV' ? 'selected' : ''}>SUV</option>
        <option value="Pick-up" ${vehiculo.tipo == 'Pick-up' ? 'selected' : ''}>Pick-up</option>
        <option value="Hatchback" ${vehiculo.tipo == 'Hatchback' ? 'selected' : ''}>Hatchback</option>
        <option value="Van" ${vehiculo.tipo == 'Van' ? 'selected' : ''}>Van</option>
        <option value="Coupé" ${vehiculo.tipo == 'Coupé' ? 'selected' : ''}>Coupé</option>
        <option value="Convertible" ${vehiculo.tipo == 'Convertible' ? 'selected' : ''}>Convertible</option>
    </select>
</div>

                    <div class="row col-6">
                        <label class="label">Año</label>
                        <input class="input" name="anio" type="number" min="1970" max="2099" placeholder="2021"
                               value="${vehiculo.anio}" ${param.action == 'view' ? 'readonly' : ''}>
                    </div>

                    <div class="row col-6">
    <label class="label">Color</label>
    <select class="select" name="color" ${param.action == 'view' ? 'disabled' : ''}>
        <option value="">— Seleccionar —</option>
        <option value="Blanco" ${vehiculo.color == 'Blanco' ? 'selected' : ''}>Blanco</option>
        <option value="Negro" ${vehiculo.color == 'Negro' ? 'selected' : ''}>Negro</option>
        <option value="Gris" ${vehiculo.color == 'Gris' ? 'selected' : ''}>Gris / Plata</option>
        <option value="Rojo" ${vehiculo.color == 'Rojo' ? 'selected' : ''}>Rojo</option>
        <option value="Azul" ${vehiculo.color == 'Azul' ? 'selected' : ''}>Azul</option>
        <option value="Beige" ${vehiculo.color == 'Beige' ? 'selected' : ''}>Beige</option>
        <option value="Marrón" ${vehiculo.color == 'Marrón' ? 'selected' : ''}>Marrón</option>
        <option value="Verde" ${vehiculo.color == 'Verde' ? 'selected' : ''}>Verde</option>
        <option value="Amarillo" ${vehiculo.color == 'Amarillo' ? 'selected' : ''}>Amarillo</option>
        <option value="Naranja" ${vehiculo.color == 'Naranja' ? 'selected' : ''}>Naranja</option>
        <option value="Otro" ${vehiculo.color == 'Otro' ? 'selected' : ''}>Otro</option>
    </select>
</div>

                    <div class="row col-6">
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

                    <div class="row col-6">
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

        <!-- SCRIPT PARA CARGAR MODELOS DINÁMICAMENTE -->
<script>
    // 1. BASE DE DATOS DE MODELOS CON SU TIPO
    // Tipos disponibles en el select: Sedán, SUV, Pick-up, Hatchback, Van, Coupé, Convertible
    const modelosData = {
        "Toyota": [
            {n: "Yaris", t: "Sedán"}, {n: "Corolla", t: "Sedán"}, {n: "Hilux", t: "Pick-up"}, 
            {n: "RAV4", t: "SUV"}, {n: "Fortuner", t: "SUV"}, {n: "Etios", t: "Sedán"}, 
            {n: "Avanza", t: "Van"}, {n: "Land Cruiser", t: "SUV"}, {n: "Prado", t: "SUV"}, {n: "Rush", t: "SUV"}
        ],
        "Hyundai": [
            {n: "Accent", t: "Sedán"}, {n: "Elantra", t: "Sedán"}, {n: "Tucson", t: "SUV"}, 
            {n: "Santa Fe", t: "SUV"}, {n: "Creta", t: "SUV"}, {n: "i10", t: "Hatchback"}, 
            {n: "Grand i10", t: "Sedán"}, {n: "i20", t: "Hatchback"}, {n: "Sonata", t: "Sedán"}, {n: "Palisade", t: "SUV"}
        ],
        "Kia": [
            {n: "Rio", t: "Sedán"}, {n: "Cerato", t: "Sedán"}, {n: "Sportage", t: "SUV"}, 
            {n: "Sorento", t: "SUV"}, {n: "Picanto", t: "Hatchback"}, {n: "Soluto", t: "Sedán"}, 
            {n: "Seltos", t: "SUV"}, {n: "Soul", t: "SUV"}, {n: "Carnival", t: "Van"}, {n: "Mohave", t: "SUV"}
        ],
        "Chevrolet": [
            {n: "Sail", t: "Sedán"}, {n: "Spark", t: "Hatchback"}, {n: "Cruze", t: "Sedán"}, 
            {n: "Tracker", t: "SUV"}, {n: "Captiva", t: "SUV"}, {n: "Onix", t: "Sedán"}, 
            {n: "Prisma", t: "Sedán"}, {n: "Colorado", t: "Pick-up"}, {n: "D-Max", t: "Pick-up"}, {n: "Tahoe", t: "SUV"}
        ],
        "Nissan": [
            {n: "Sentra", t: "Sedán"}, {n: "Versa", t: "Sedán"}, {n: "Tiida", t: "Sedán"}, 
            {n: "Frontier", t: "Pick-up"}, {n: "X-Trail", t: "SUV"}, {n: "Qashqai", t: "SUV"}, 
            {n: "Kicks", t: "SUV"}, {n: "Pathfinder", t: "SUV"}, {n: "Patrol", t: "SUV"}, {n: "March", t: "Hatchback"}
        ],
        "Honda": [
            {n: "Civic", t: "Sedán"}, {n: "Accord", t: "Sedán"}, {n: "CR-V", t: "SUV"}, 
            {n: "Pilot", t: "SUV"}, {n: "HR-V", t: "SUV"}, {n: "City", t: "Sedán"}, 
            {n: "Fit", t: "Hatchback"}, {n: "Jazz", t: "Hatchback"}, {n: "WR-V", t: "SUV"}, {n: "Ridgeline", t: "Pick-up"}
        ],
        "Mazda": [
            {n: "Mazda 2", t: "Hatchback"}, {n: "Mazda 3", t: "Sedán"}, {n: "Mazda 6", t: "Sedán"}, 
            {n: "CX-3", t: "SUV"}, {n: "CX-30", t: "SUV"}, {n: "CX-5", t: "SUV"}, 
            {n: "CX-9", t: "SUV"}, {n: "CX-50", t: "SUV"}, {n: "BT-50", t: "Pick-up"}, {n: "MX-5", t: "Convertible"}
        ],
        "Ford": [
            {n: "Fiesta", t: "Hatchback"}, {n: "Focus", t: "Sedán"}, {n: "Ranger", t: "Pick-up"}, 
            {n: "Explorer", t: "SUV"}, {n: "EcoSport", t: "SUV"}, {n: "Mustang", t: "Coupé"}, 
            {n: "F-150", t: "Pick-up"}, {n: "Edge", t: "SUV"}, {n: "Escape", t: "SUV"}, {n: "Territory", t: "SUV"}
        ],
        "Mercedes": [
            {n: "Clase A", t: "Sedán"}, {n: "Clase C", t: "Sedán"}, {n: "Clase E", t: "Sedán"}, 
            {n: "GLA", t: "SUV"}, {n: "GLC", t: "SUV"}, {n: "GLE", t: "SUV"}, 
            {n: "Clase S", t: "Sedán"}, {n: "CLA", t: "Coupé"}, {n: "CLS", t: "Coupé"}, {n: "Clase G", t: "SUV"}
        ],
        "BMW": [
            {n: "Serie 1", t: "Hatchback"}, {n: "Serie 2", t: "Coupé"}, {n: "Serie 3", t: "Sedán"}, 
            {n: "Serie 5", t: "Sedán"}, {n: "X1", t: "SUV"}, {n: "X3", t: "SUV"}, 
            {n: "X4", t: "SUV"}, {n: "X5", t: "SUV"}, {n: "X6", t: "SUV"}, {n: "M3", t: "Sedán"}
        ]
    };

    const selectMarca = document.getElementById('selectMarca');
    const selectModelo = document.getElementById('selectModelo');
    const selectTipo = document.getElementById('selectTipo');

    // 2. FUNCIÓN PARA CARGAR MODELOS
    function cargarModelos(marcaSeleccionada, modeloPreseleccionado = null) {
        // Limpiar opciones
        selectModelo.innerHTML = '<option value="">— Seleccionar —</option>';

        if (marcaSeleccionada && modelosData[marcaSeleccionada]) {
            const modelos = modelosData[marcaSeleccionada];
            
            // Ordenar alfabéticamente por nombre
            modelos.sort((a, b) => a.n.localeCompare(b.n));

            modelos.forEach(obj => {
                const option = document.createElement('option');
                option.value = obj.n;
                option.textContent = obj.n;
                
                // GUARDAMOS EL TIPO EN UN ATRIBUTO DATA PARA LEERLO LUEGO
                option.setAttribute('data-tipo', obj.t);
                
                if (modeloPreseleccionado && obj.n === modeloPreseleccionado) {
                    option.selected = true;
                }
                
                selectModelo.appendChild(option);
            });
            selectModelo.disabled = false;
        } else {
            selectModelo.innerHTML = '<option value="">— Seleccione Marca primero —</option>';
            selectModelo.disabled = true;
        }
    }

    // 3. EVENTO CAMBIO DE MARCA -> Cargar Modelos
    if (selectMarca) {
        selectMarca.addEventListener('change', function() {
            // Al cambiar marca, limpiamos modelo y tipo
            cargarModelos(this.value);
            selectTipo.value = ""; 
        });
    }

    // 4. EVENTO CAMBIO DE MODELO -> Automatizar Tipo
    if (selectModelo) {
        selectModelo.addEventListener('change', function() {
            // Obtenemos la opción seleccionada actualmente
            const opcionSeleccionada = this.options[this.selectedIndex];
            
            // Leemos el atributo data-tipo que guardamos en el paso 2
            const tipoAutomatico = opcionSeleccionada.getAttribute('data-tipo');
            
            if (tipoAutomatico) {
                selectTipo.value = tipoAutomatico;
            } else {
                selectTipo.value = "";
            }
        });
    }

    // 5. INICIALIZACIÓN (Modo Edición)
    document.addEventListener('DOMContentLoaded', function() {
        const marcaGuardada = "${vehiculo.marca}";
        const modeloGuardado = "${vehiculo.modelo}";
        const tipoGuardado = "${vehiculo.tipo}"; // Importante para respetar lo que ya estaba en BD

        if (marcaGuardada) {
            selectMarca.value = marcaGuardada;
            cargarModelos(marcaGuardada, modeloGuardado);
            
            // Si ya venía un tipo guardado de la BD, lo respetamos (sobrescribe la automatización inicial)
            if(tipoGuardado) {
                selectTipo.value = tipoGuardado;
            }
        }
        
        // Bloquear en modo View
        const isViewMode = "${param.action}" === "view";
        if(isViewMode) {
            if(selectMarca) selectMarca.disabled = true;
            if(selectModelo) selectModelo.disabled = true;
            if(selectTipo) selectTipo.disabled = true;
        }
    });
</script>



    </body>
</html>