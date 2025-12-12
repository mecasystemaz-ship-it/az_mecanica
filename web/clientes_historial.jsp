<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // 1. SEGURIDAD: Verificar sesión y rol de ADMIN
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equalsIgnoreCase(rolGuard)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // 2. SEGURIDAD: Evitar que el navegador guarde caché de esta página
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Historial Clientes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
    </head>

    <body class="bg">

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                    <span class="brand__label">Historial de Clientes</span>
                </div>
                
                <jsp:include page="saludoadmin.jsp" />
                
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/clientes" style="font-weight: bold; border: 1px solid #444;">
                ← Volver a Gestión
            </a>
            
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a class="active" href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
        </nav>

        <main class="container">
            
            <section class="card" id="historial" style="margin-top: 20px;">
                <div class="section-head">
                    <h2>Búsqueda Avanzada y Estadísticas</h2>
                    
                    <div class="filters">
                        <div class="field">
                            <label>Buscar</label>
                            <input id="fQuery" type="text" placeholder="DNI, Nombre, Apellido, Correo...">
                        </div>
                        
                        <div class="field">
                            <label>Filtro Rápido</label>
                            <select id="fTipo">
                                <option value="">Todos</option>
                                <option value="con_autos">Con Vehículos</option>
                                <option value="frecuentes">Clientes Frecuentes</option>
                            </select>
                        </div>
                        
                        <button class="btn btn-primary" id="btnAplicar">Filtrar</button>
                        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
                    </div>
                </div>

                <div class="datatable-wrapper">
                    <table class="datatable">
                        <thead>
                            <tr>
                                <th>DNI</th>
                                <th>Cliente</th>
                                <th>Teléfono / Correo</th>
                                <th class="ta-center">Autos</th>
                                <th class="ta-center">Citas</th>
                                <th class="ta-center">Estado</th> </tr>
                        </thead>
                        <tbody id="bodyHistorial">
                            </tbody>
                    </table>
                </div>
            </section>

        </main>

        <footer class="footer">
            <div class="container footer__inner">
                <small>© <%= java.time.Year.now()%> AZ Mecánica</small>
            </div>
        </footer>

        <script>
            // 1. Cargar datos reales desde el servidor (Java) a un objeto JavaScript
            // Usamos fn:escapeXml para evitar errores si los nombres tienen comillas
            const dataClientes = [
                <c:forEach var="c" items="${requestScope.listaClientes}" varStatus="status">
                {
                    dni: "${fn:escapeXml(c.dni)}",
                    nombres: "${fn:escapeXml(c.nombres)}",
                    apellidos: "${fn:escapeXml(c.apellidos)}",
                    telefono: "${fn:escapeXml(c.telefono)}",
                    correo: "${fn:escapeXml(c.correo)}",
                    // Datos estadísticos (Si son null, ponemos 0)
                    autos: ${c.totalVehiculos != null ? c.totalVehiculos : 0},
                    citas: ${c.totalCitas != null ? c.totalCitas : 0}
                }${!status.last ? ',' : ''}
                </c:forEach>
            ];

            // 2. Función para dibujar la tabla (SOLO LECTURA)
            function render(rows) {
                const tbody = document.getElementById('bodyHistorial');
                tbody.innerHTML = '';

                if (rows.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="empty">No se encontraron resultados para tu búsqueda.</td></tr>';
                    return;
                }

                rows.forEach(r => {
                    const tr = document.createElement('tr');
                    const nombreCompleto = r.nombres + " " + r.apellidos;

                    // Badges visuales (Icono de auto y Estrella de frecuente)
                    let badgeAutos = r.autos > 0 
                        ? `<span style="color:#ffb800; font-weight:bold;">🚗 \${r.autos}</span>` 
                        : `<span style="color:#555">-</span>`;

                    let badgeCitas = r.citas > 0 
                        ? `<span class="tag" style="background:#d4edda; color:#155724;">⭐ \${r.citas}</span>` 
                        : `<span>\${r.citas}</span>`;

                    tr.innerHTML = `
                        <td><span class="tag">\${r.dni}</span></td>
                        <td><strong>\${nombreCompleto}</strong></td>
                        <td>
                            <div>\${r.telefono}</div>
                            <div style="font-size:0.85em; color:#888">\${r.correo}</div>
                        </td>
                        <td class="ta-center">\${badgeAutos}</td>
                        <td class="ta-center">\${badgeCitas}</td>
                        
                        <td class="ta-center">
                            <span style="color:#aaa; font-size:0.85em; font-style:italic;">
                                🔒 Solo lectura
                            </span>
                        </td>`;
                    tbody.appendChild(tr);
                });
            }

            // 3. Lógica de Filtros
            function applyFilter() {
                const q = document.getElementById('fQuery').value.toLowerCase().trim();
                const tipo = document.getElementById('fTipo').value;

                const filtered = dataClientes.filter(r => {
                    // Buscar coincidencia en DNI, Nombre, Apellido o Correo
                    const textMatch = 
                        r.dni.toLowerCase().includes(q) || 
                        r.nombres.toLowerCase().includes(q) || 
                        r.apellidos.toLowerCase().includes(q) ||
                        r.correo.toLowerCase().includes(q);
                    
                    // Lógica de filtros especiales (Select)
                    let typeMatch = true;
                    if (tipo === 'con_autos') typeMatch = r.autos > 0;
                    if (tipo === 'frecuentes') typeMatch = r.citas > 0; 

                    return textMatch && typeMatch;
                });
                render(filtered);
            }

            function clearFilter() {
                document.getElementById('fQuery').value = '';
                document.getElementById('fTipo').value = '';
                render(dataClientes);
            }

            // Eventos
            document.getElementById('btnAplicar').addEventListener('click', applyFilter);
            document.getElementById('btnLimpiar').addEventListener('click', clearFilter);
            
            // Búsqueda en tiempo real al escribir
            document.getElementById('fQuery').addEventListener('keyup', applyFilter);
            document.getElementById('fTipo').addEventListener('change', applyFilter);

            // Iniciar renderizado al cargar la página
            render(dataClientes);
        </script>

    </body>
</html>