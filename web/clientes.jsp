<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Clientes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">


    </head>

    <body class="bg">

        <!-- TOP -->
        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
                    <span class="brand__label">Clientes</span>
                </div>
                <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
            </div>
        </header>

        <!-- NAV -->
        <nav class="tabs">
            <a href="index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a>Productos</a>
            <a>Inventario</a>
            <a href="citas.jsp">Citas</a>
            <a href="servicios">Servicios</a>
            <a class="active">Clientes</a>
            <a href="vehiculos.jsp">Vehículos</a>
        </nav>

        <main class="container">

            <!-- ===== Últimos clientes ===== -->
            <section class="card" id="ultimos">
                <div class="section-head">
                    <h2>Tabla de últimos clientes</h2>
                    <a class="btn btn-primary" href="cliente-form.jsp?action=create">+ Registrar cliente</a>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable">
                        <colgroup>
                            <col style="width:18%"><col style="width:12%"><col style="width:12%">
                            <col style="width:12%"><col style="width:14%"><col style="width:12%">
                            <col style="width:12%"><col style="width:8%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Cliente</th>
                                <th>Origen</th>
                                <th>N° Ref.</th> 

                                <th>Placa</th>
                                <th>Fecha</th>
                                <th>Monto</th>
                                <th>Método</th>
                                <th class="ta-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cliente" items="${listaClientes}">
                                <tr data-id="${cliente.dni}">
                                    <%-- Usamos Nombres y Apellidos concatenados para el campo Cliente --%>
                                    <td>${cliente.nombres} ${cliente.apellidos}</td>

                                    <%-- Campos de Servicio (vienen directamente del DAO) --%>

                                    <td><span class="tag">${cliente.origen}</span></td>
                                    <td>${cliente.nreferencia}</td> 
                                    <td>${cliente.placa}</td>

                                    <%-- NOTA: Debes agregar la Fecha y Monto a tu Modelo/BD para que sean reales --%>
                                    <td>N/A</td> <%-- Fecha (aún no existe en el modelo) --%>
                                    <td><span class="money">S/ N/A</span></td> <%-- Monto (aún no existe en el modelo) --%>

                                    <td>${cliente.metodo}</td>

                                    <td class="ta-center">
                                        <%-- 🛑 CORRECCIÓN: Apuntamos al SERVLET (/clientes) para que cargue los datos --%>
                                        <a class="chip" title="Ver" 
                                           href="${pageContext.request.contextPath}/clientes?action=view&dni=${cliente.dni}">👁</a>
                                        <a class="chip" title="Editar" 
                                           href="${pageContext.request.contextPath}/clientes?action=edit&dni=${cliente.dni}">✏</a>

                                        <%-- Formulario de eliminar (esto ya funcionaba bien) --%>
                                        <form method="POST" action="${pageContext.request.contextPath}/clientes/eliminar" style="display:inline-block;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="dni" value="${cliente.dni}">
                                            <button class="chip danger" type="submit" title="Eliminar" onclick="return confirm('¿Estás seguro de eliminar a ${cliente.nombres} ${cliente.apellidos} con DNI ${cliente.dni}?');">🗑</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaClientes}">
                                <tr>
                                    <td colspan="8" class="empty">No hay clientes registrados.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="center mt-16">
                    <a class="btn btn-secondary" href="#historial">Ver más</a>
                </div>
            </section>

            <!-- ===== Historial + filtros ===== -->
            <section class="card" id="historial">
                <div class="section-head">
                    <h2>Historial de clientes</h2>
                    <div class="filters">
                        <div class="field"><label>Cliente</label><input id="fNombre" type="text" placeholder="Buscar por nombre…"></div>
                        <div class="field">
                            <label>Origen</label>
                            <select id="fOrigen"><option value="">Todos</option><option>Orden</option><option>Proforma</option><option>Web</option></select>
                        </div>
                        <div class="field"><label>Desde</label><input id="fDesde" type="date"></div>
                        <div class="field"><label>Hasta</label><input id="fHasta" type="date"></div>
                        <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
                        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
                    </div>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable" id="tablaHistorial" data-empty="No hay registros para el filtro.">
                        <thead>
                            <tr>
                                <th>Cliente</th><th>Origen</th><th>N° Ref.</th><th>Placa</th>
                                <th>Fecha</th><th>Monto</th><th>Método</th><th class="ta-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="bodyHistorial"></tbody>
                    </table>
                </div>
            </section>
        </main>

        <footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

        <script>
            /* ------- Datos MOCK para historial ------- */
            const data = [
                {id: 1, nombre: 'Tyler Joseph', origen: 'Orden', ref: 'OR-0234', placa: 'C7L-394', fecha: '2025-02-03', monto: 235, metodo: 'Efectivo'},
                {id: 2, nombre: 'Luis Cáceres', origen: 'Proforma', ref: 'PF-1045', placa: 'BDP-213', fecha: '2025-01-27', monto: 198, metodo: 'Tarjeta'},
                {id: 3, nombre: 'Hernan Soto', origen: 'Proforma', ref: 'PF-1064', placa: 'DNW-407', fecha: '2025-01-26', monto: 156, metodo: 'Efectivo'},
                {id: 4, nombre: 'Ben Canela', origen: 'Orden', ref: 'OR-0239', placa: 'FEX-489', fecha: '2025-01-24', monto: 90, metodo: 'Yape'},
                {id: 5, nombre: 'Claudia Rojas', origen: 'Web', ref: 'WB-8842', placa: 'V4S-220', fecha: '2024-12-14', monto: 320, metodo: 'Tarjeta'},
                {id: 6, nombre: 'Diego Núñez', origen: 'Orden', ref: 'OR-0177', placa: 'CSS-101', fecha: '2024-11-09', monto: 145, metodo: 'Efectivo'}
            ];

            function render(rows) {
                const tbody = document.getElementById('bodyHistorial');
                tbody.innerHTML = '';
                rows.forEach(r => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
              <td>${r.nombre}</td>
              <td><span class="tag">${r.origen}</span></td>
              <td>${r.ref}</td>
              <td>${r.placa}</td>
              <td>${r.fecha}</td>
              <td><span class="money">S/ ${r.monto}</span></td>
              <td>${r.metodo}</td>
              <td class="ta-center">
                <a class="chip" href="cliente-form.jsp?action=view&id=${r.id}">👁</a>
                <a class="chip" href="cliente-form.jsp?action=edit&id=${r.id}">✏</a>
                <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
              </td>`;
                    tbody.appendChild(tr);
                });
                if (rows.length === 0) {
                    const tr = document.createElement('tr'); /* <- BUG resuelto (antes estaba 'ttr') */
                    tr.innerHTML = '<td colspan="8" class="empty">' + document.getElementById('tablaHistorial').dataset.empty + '</td>';
                    tbody.appendChild(tr);
                }
            }

            function applyFilter() {
                const q = document.getElementById('fNombre').value.toLowerCase().trim();
                const origen = document.getElementById('fOrigen').value;
                const d = document.getElementById('fDesde').value;
                const h = document.getElementById('fHasta').value;
                const rows = data.filter(r => {
                    const byName = r.nombre.toLowerCase().includes(q);
                    const byOrigen = !origen || r.origen === origen;
                    const byFecha = (!d || r.fecha >= d) && (!h || r.fecha <= h);
                    return byName && byOrigen && byFecha;
                });
                render(rows);
            }
            function clearFilter() {
                document.getElementById('fNombre').value = '';
                document.getElementById('fOrigen').value = '';
                document.getElementById('fDesde').value = '';
                document.getElementById('fHasta').value = '';
                render(data);
            }
            function fakeDelete(btn) {
                const tr = btn.closest('tr');
                tr.classList.add('fade');
                setTimeout(() => tr.remove(), 200);
            }
            document.getElementById('btnAplicar').addEventListener('click', applyFilter);
            document.getElementById('btnLimpiar').addEventListener('click', clearFilter);
            render(data);
        </script>
    </body>
</html>
