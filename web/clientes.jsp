<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
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
                <!-- a login.jsp -> lo conecto a tu LogoutServlet -->
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
            </div>
        </header>

        <!-- NAV -->
        <nav class="tabs">
            <a href="index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a>Productos</a>
            <a>Inventario</a>
            <a href="citas.jsp">Citas</a>
            <a href="servicios.jsp">Servicios</a>
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

                        <!-- ====== CONECTADO A BACK: requestScope.lista ====== -->
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty lista}">
                                    <c:forEach var="c" items="${lista}">
                                        <tr data-dni="${c.dni}">
                                            <td>${c.nombre} ${c.apellido}</td>
                                            <!-- Estos campos no existen en la tabla clientes; se muestran como '—' para mantener tu formato -->
                                            <td><span class="tag">—</span></td>
                                            <td>—</td>
                                            <td>—</td>
                                            <td>—</td>
                                            <td><span class="money">—</span></td>
                                            <td>—</td>
                                            <td class="ta-center">
                                                <!-- Ver: si ya manejas modo 'view' en el form, pasamos el dni -->
                                                <a class="chip" title="Ver" href="cliente-form.jsp?action=view&dni=${c.dni}">👁</a>
                                                <!-- Editar vía Servlet para precargar el form -->
                                                <a class="chip" title="Editar" href="${pageContext.request.contextPath}/clientes?action=editar&dni=${c.dni}">✏</a>
                                                <!-- Eliminar en backend conservando tu botón y estilo -->
                                                <button class="chip danger" title="Eliminar" onclick="deleteCliente('${c.dni}', this)">🗑</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Si lista viene vacía, dejamos un mensaje único (sin romper tu layout) -->
                                    <tr>
                                        <td colspan="8" class="empty">No hay clientes registrados.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="center mt-16">
                    <a class="btn btn-secondary" href="#historial">Ver más</a>
                </div>
            </section>

            <!-- ===== Historial + filtros (SE MANTIENE IGUAL/JS) ===== -->
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
            /* ------- Datos MOCK para historial (se mantiene) ------- */
            let data = []; // será llenado desde el backend

            async function loadHistorial() {
                try {
                    const params = new URLSearchParams({
                        action: 'historial'
                                // En el primer load no filtramos; los filtros usan applyFilter()
                    });
                    const res = await fetch(`${window.location.origin}${'${pageContext.request.contextPath}'}/clientes?` + params.toString(), {
                        headers: {'Accept': 'application/json'}
                    });
                    if (!res.ok)
                        throw new Error('HTTP ' + res.status);
                    data = await res.json();
                    render(data);
                } catch (e) {
                    console.error('Error cargando historial:', e);
                    data = [];
                    render(data);
                }
            }

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
                    const tr = document.createElement('tr');
                    tr.innerHTML = '<td colspan="8" class="empty">' + document.getElementById('tablaHistorial').dataset.empty + '</td>';
                    tbody.appendChild(tr);
                }
            }

            function applyFilter() {
                const q = document.getElementById('fNombre').value.toLowerCase().trim();
                const origen = document.getElementById('fOrigen').value;
                const d = document.getElementById('fDesde').value;
                const h = document.getElementById('fHasta').value;

                // Filtrado en cliente (igual que tu lógica original)
                const rows = data.filter(r => {
                    const byName = r.nombre.toLowerCase().includes(q);
                    const byOrigen = origen === "" || r.origen === origen;

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

            /* ====== Eliminar cliente en BACK manteniendo tu botón y estilos ====== */
            function deleteCliente(dni, btn) {
                if (!confirm('¿Eliminar cliente ' + dni + '?'))
                    return;
                fakeDelete(btn);
                window.location = '${pageContext.request.contextPath}/clientes?action=eliminar&dni=' + encodeURIComponent(dni);
            }

            document.getElementById('btnAplicar').addEventListener('click', applyFilter);
            document.getElementById('btnLimpiar').addEventListener('click', clearFilter);

        // Cargar historial real desde backend al iniciar
            loadHistorial();
        </script>
    </body>
</html>
