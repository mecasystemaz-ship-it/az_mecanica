<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // Control de Acceso
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equalsIgnoreCase(rolGuard)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Vehículos</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
        
        <style>
            /* Otros estilos ya existentes (se dejan intactos) */
            .alert {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-success {
                background: #d4edda;
                color: #155724;
            }
            .alert-danger {
                background: #f8d7da;
                color: #721c24;
            }

            .grid2 {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

        </style>
        
    </head>

    <body class="bg">
        
        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                    <span class="brand__label">Vehículos</span>
                </div>
                <jsp:include page="saludoadmin.jsp" />
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a class="active" href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
        </nav>

        <main class="container">
            
            <c:if test="${not empty sessionScope.mensajeExito}">
                <div class="alert alert-success">${sessionScope.mensajeExito}</div>
                <c:remove var="mensajeExito" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.mensajeError}">
                <div class="alert alert-danger">${sessionScope.mensajeError}</div>
                <c:remove var="mensajeError" scope="session"/>
            </c:if>
            

            <section class="card" id="gestion">
                <div class="section-head">
                    <h2>Gestión de Vehículos</h2>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/vehiculos/form?action=create">+ Añadir vehículo</a>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable">
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
                                <tr>
                                    <td>${v.nombreCliente != null ? v.nombreCliente : v.dniCliente}</td>
                                    <td>${v.marca}</td>
                                    <td>${v.modelo}</td>
                                    <td><span class="tag">${v.tipo}</span></td>
                                    <td>${v.anio}</td>
                                    <td>${v.color}</td>
                                    <td><strong class="money">${v.placa}</strong></td>
                                    <td class="ta-center">
                                        <a class="chip" href="${pageContext.request.contextPath}/vehiculos/form?action=view&placa=${v.placa}" title="Ver Detalle">👁</a>
                                        <a class="chip" href="${pageContext.request.contextPath}/vehiculos/form?action=edit&placa=${v.placa}" title="Editar">✏</a>
                                        
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
                                <tr><td colspan="8" class="empty">No hay vehículos registrados.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="card" id="historial">
                <div class="section-head">
                    <h2>Búsqueda Avanzada / Historial</h2>
                    <div class="filters">
                        <div class="field"><label>Placa/Cliente</label><input id="fQuery" type="text" placeholder="Buscar..."></div>
                        <div class="field">
                            <label>Tipo</label>
                            <select id="fTipo">
                                <option value="">Todos</option>
                                <option>Sedán</option>
                                <option>SUV</option>
                                <option>Pick-up</option>
                                <option>Hatchback</option>
                                <option>Van</option>
                            </select>
                        </div>
                        <div class="field"><label>Desde (Año)</label><input id="fDesdeAnio" type="number" placeholder="2000"></div>
                        <div class="field"><label>Hasta (Año)</label><input id="fHastaAnio" type="number" placeholder="<%= java.time.Year.now().getValue()%>"></div>
                        <button class="btn btn-primary" id="btnAplicar">Filtrar</button>
                        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
                    </div>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable">
                        <thead>
                            <tr>
                                <th>Cliente</th><th>Marca</th><th>Modelo</th><th>Tipo</th>
                                <th>Año</th><th>Color</th><th>Placa</th><th class="ta-center">Ver</th>
                            </tr>
                        </thead>
                        <tbody id="bodyHistorial">
                            </tbody>
                    </table>
                </div>
            </section>
        </main>

        <footer class="footer">
            <div class="container footer__inner">
                <small>© <%= java.time.Year.now()%> AZ Mecánica — Todos los derechos reservados</small>
            </div>
        </footer>

        <script>
            // 1. CONVERTIR DATOS DEL SERVIDOR (JAVA) A JAVASCRIPT
            // Esto toma la lista real de la base de datos y crea un Array JS para poder filtrar sin recargar
            const dataVehiculos = [
                <c:forEach var="v" items="${requestScope.listaVehiculos}" varStatus="status">
                {
                    placa: "${v.placa}",
                    cliente: "${v.nombreCliente != null ? v.nombreCliente : v.dniCliente}", 
                    marca: "${v.marca}",
                    modelo: "${v.modelo}",
                    tipo: "${v.tipo}",
                    anio: ${v.anio != null ? v.anio : 0},
                    color: "${v.color}"
                }${!status.last ? ',' : ''}
                </c:forEach>
            ];

            // 2. FUNCIÓN DE RENDERIZADO
            function render(rows) {
                const tbody = document.getElementById('bodyHistorial');
                tbody.innerHTML = '';

                if (rows.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="empty">No se encontraron resultados.</td></tr>';
                    return;
                }

                rows.forEach(r => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>\${r.cliente}</td>
                        <td>\${r.marca}</td>
                        <td>\${r.modelo}</td>
                        <td><span class="tag">\${r.tipo}</span></td>
                        <td>\${r.anio}</td>
                        <td>\${r.color}</td>
                        <td><strong class="money">\${r.placa}</strong></td>
                        <td class="ta-center">
                            <a class="chip" href="${pageContext.request.contextPath}/vehiculos/form?action=view&placa=\${r.placa}">👁</a>
                        </td>`;
                    tbody.appendChild(tr);
                });
            }

            // 3. LÓGICA DE FILTRADO
            function applyFilter() {
                const q = document.getElementById('fQuery').value.toLowerCase().trim();
                const tipo = document.getElementById('fTipo').value;
                const dAnio = parseInt(document.getElementById('fDesdeAnio').value) || 0;
                const hAnio = parseInt(document.getElementById('fHastaAnio').value) || 9999;

                const filteredRows = dataVehiculos.filter(r => {
                    // Filtrar por Texto (Placa o Cliente)
                    const textMatch = r.placa.toLowerCase().includes(q) || r.cliente.toLowerCase().includes(q);
                    // Filtrar por Tipo (Exacto)
                    const tipoMatch = !tipo || r.tipo === tipo;
                    // Filtrar por Año (Rango)
                    const anioMatch = r.anio >= dAnio && r.anio <= hAnio;

                    return textMatch && tipoMatch && anioMatch;
                });
                render(filteredRows);
            }

            // 4. LIMPIAR FILTROS
            function clearFilter() {
                document.getElementById('fQuery').value = '';
                document.getElementById('fTipo').value = '';
                document.getElementById('fDesdeAnio').value = '';
                document.getElementById('fHastaAnio').value = '';
                render(dataVehiculos);
            }

            // Eventos
            document.getElementById('btnAplicar').addEventListener('click', applyFilter);
            document.getElementById('btnLimpiar').addEventListener('click', clearFilter);
            
            // Búsqueda en tiempo real (opcional)
            document.getElementById('fQuery').addEventListener('keyup', applyFilter);

            // Inicializar tabla
            render(dataVehiculos);
        </script>
    </body>
</html>