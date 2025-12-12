<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // Control de Acceso (Tomado del diseño de Clientes, pero usando equalsIgnoreCase de tu versión anterior para ser más flexible)
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equalsIgnoreCase(rolGuard)) { // Usamos equalsIgnoreCase
        System.out.println("Acceso denegado a Vehículos. Rol: " + rolGuard);
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
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                    <span class="brand__label">Vehículos</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/login.jsp">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.jsp">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a class="active" href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
        </nav>

        <main class="container">

            <section class="card" id="ultimos">
                <div class="section-head">
                    <h2>Tabla de vehículos registrados</h2>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/vehiculos/form?action=create">+ Añadir vehículo</a>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable">
                        <colgroup>
                            <col style="width:20%"><col style="width:12%"><col style="width:14%">
                            <col style="width:12%"><col style="width:10%"><col style="width:12%"><col style="width:12%"><col style="width:8%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Cliente</th>
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
                            <c:forEach var="v" items="${requestScope.listaVehiculos}">
                                <tr id="vehiculo-${v.placa}" 
                                    data-row='{
                                    "placa": "${fn:escapeXml(v.placa)}",
                                    "marca": "${fn:escapeXml(v.marca)}",
                                    "modelo": "${fn:escapeXml(v.modelo)}",
                                    "tipo": "${fn:escapeXml(v.tipo)}",
                                    "anio": ${v.anio},
                                    "color": "${fn:escapeXml(v.color)}",
                                    "kilometraje": ${v.kilometraje},
                                    "dniCliente": "${fn:escapeXml(v.dniCliente)}"
                                    }'>
                                    <td>${v.nombreCliente != null ? v.nombreCliente : v.dniCliente}</td>
                                    <td>${v.marca}</td>
                                    <td>${v.modelo}</td>
                                    <td><span class="tag">${v.tipo}</span></td>
                                    <td>${v.anio}</td>
                                    <td>${v.color}</td>
                                    <td><strong class="money">${v.placa}</strong></td>
                                    <td class="ta-center">
                                        <a class="chip" href="${pageContext.request.contextPath}/vehiculos/form?action=view&placa=${v.placa}">👁</a>
                                        <a class="chip" href="${pageContext.request.contextPath}/vehiculos/form?action=edit&placa=${v.placa}">✏</a>

                                        <form method="POST" action="${pageContext.request.contextPath}/vehiculos/eliminar" style="display:inline-block;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="placa" value="${v.placa}">
                                            <button class="chip danger" type="submit" title="Eliminar" 
                                                    onclick="return confirm('¿Estás seguro de eliminar el vehículo con placa ${v.placa}?');">🗑</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty requestScope.listaVehiculos}">
                                <tr>
                                    <td colspan="8" class="empty">No hay vehículos registrados en la base de datos.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="center mt-16">
                    <a class="btn btn-secondary" href="#historial">Ver historial completo</a>
                </div>
            </section>

            ---

            <section class="card" id="historial">
                <div class="section-head">
                    <h2>Historial de Vehículos y Servicios</h2>
                    <div class="filters">
                        <div class="field"><label>Placa/Cliente</label><input id="fQuery" type="text" placeholder="Buscar por placa o cliente…"></div>
                        <div class="field">
                            <label>Tipo</label>
                            <select id="fTipo"><option value="">Todos</option><option>Auto</option><option>Camioneta</option><option>Moto</option></select>
                        </div>
                        <div class="field"><label>Desde (Año)</label><input id="fDesdeAnio" type="number" placeholder="Ej: 2020" min="1900" max="<%= java.time.Year.now().getValue()%>"></div>
                        <div class="field"><label>Hasta (Año)</label><input id="fHastaAnio" type="number" placeholder="Ej: 2025" min="1900" max="<%= java.time.Year.now().getValue()%>"></div>
                        <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
                        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
                    </div>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable" id="tablaHistorial" data-empty="No hay vehículos para el filtro.">
                        <thead>
                            <tr>
                                <th>Cliente</th><th>Marca</th><th>Modelo</th><th>Tipo</th>
                                <th>Año</th><th>Color</th><th>Placa</th><th class="ta-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="bodyHistorial">
                        </tbody>
                    </table>
                </div>
            </section>
        </main>

        <footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

        <script>
            /* ------- Datos MOCK/Simulados para el historial ------- */
            // NOTA: En una aplicación real, este JSON debería ser cargado desde el Servidor (DAO/Servlet)
            const dataVehiculos = [
                // Estos son datos simulados, adapta a tu objeto Vehiculo si es necesario
                {placa: 'C7L-394', cliente: 'Tyler Joseph', marca: 'Toyota', modelo: 'Corolla', tipo: 'Auto', anio: 2020, color: 'Rojo'},
                {placa: 'BDP-213', cliente: 'Luis Cáceres', marca: 'Nissan', modelo: 'Frontier', tipo: 'Camioneta', anio: 2022, color: 'Negro'},
                {placa: 'DNW-407', cliente: 'Hernan Soto', marca: 'Honda', modelo: 'Civic', tipo: 'Auto', anio: 2018, color: 'Gris'},
                {placa: 'FEX-489', cliente: 'Ben Canela', marca: 'Suzuki', modelo: 'GSX-R', tipo: 'Moto', anio: 2023, color: 'Azul'},
                {placa: 'V4S-220', cliente: 'Claudia Rojas', marca: 'Kia', modelo: 'Sportage', tipo: 'Camioneta', anio: 2021, color: 'Blanco'},
                {placa: 'CSS-101', cliente: 'Diego Núñez', marca: 'Mazda', modelo: '3', tipo: 'Auto', anio: 2019, color: 'Plata'}
            ];

            function render(rows) {
                const tbody = document.getElementById('bodyHistorial');
                tbody.innerHTML = '';

                rows.forEach(r => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>${r.cliente}</td>
                        <td>${r.marca}</td>
                        <td>${r.modelo}</td>
                        <td><span class="tag">${r.tipo}</span></td>
                        <td>${r.anio}</td>
                        <td>${r.color}</td>
                        <td><strong class="money">${r.placa}</strong></td>
                        <td class="ta-center">
                            <a class="chip" href="vehiculo-form.jsp?action=view&placa=${r.placa}">👁</a>
                            <a class="chip" href="vehiculo-form.jsp?action=edit&placa=${r.placa}">✏</a>
                            <button class="chip danger" data-delete-placa="${r.placa}" onclick="handleDelete(event)">🗑</button>
                        </td>`;
                    tbody.appendChild(tr);
                });

                if (rows.length === 0) {
                    const tr = document.createElement('tr');
                    tr.innerHTML = '<td colspan="8" class="empty">' + document.getElementById('tablaHistorial').dataset.empty + '</td>';
                    tbody.appendChild(tr);
                }
            }

            function applyFilter() {
                const q = document.getElementById('fQuery').value.toLowerCase().trim();
                const tipo = document.getElementById('fTipo').value;
                const dAnio = parseInt(document.getElementById('fDesdeAnio').value) || 0;
                const hAnio = parseInt(document.getElementById('fHastaAnio').value) || 9999;

                const filteredRows = dataVehiculos.filter(r => {
                    const byText = r.placa.toLowerCase().includes(q) || r.cliente.toLowerCase().includes(q);
                    const byTipo = !tipo || r.tipo === tipo;
                    const byAnio = r.anio >= dAnio && r.anio <= hAnio;
                    return byText && byTipo && byAnio;
                });
                render(filteredRows);
            }

            function clearFilter() {
                document.getElementById('fQuery').value = '';
                document.getElementById('fTipo').value = '';
                document.getElementById('fDesdeAnio').value = '';
                document.getElementById('fHastaAnio').value = '';
                render(dataVehiculos); // Vuelve a renderizar todos los datos
            }

            // Función de eliminación visual simulada (para el historial en JS)
            function fakeDeleteVisual(btn) {
                const tr = btn.closest('tr');
                tr.classList.add('fade');
                setTimeout(() => tr.remove(), 200);
            }

            // Lógica para botones de acción (Eliminar)
            function handleDelete(e) {
                const deleteBtn = e.target.closest('[data-delete-placa]');
                if (deleteBtn) {
                    const placa = deleteBtn.getAttribute('data-delete-placa');
                    if (confirm(`¿Estás seguro de que deseas eliminar el vehículo con placa ${placa}?`)) {
                        // Si la eliminación se hace en el Servlet (como en el bloque JSTL de arriba), 
                        // deberías usar window.location.href o un POST real,
                        // pero aquí usamos la eliminación visual para el Historial simulado.
                        fakeDeleteVisual(deleteBtn);
                    }
                }
            }

            document.getElementById('btnAplicar').addEventListener('click', applyFilter);
            document.getElementById('btnLimpiar').addEventListener('click', clearFilter);

            // Inicializar la tabla del historial con los datos simulados
            render(dataVehiculos);
        </script>
    </body>
</html>