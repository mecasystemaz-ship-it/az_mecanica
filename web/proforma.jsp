<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // Protección de acceso (Se mantiene igual)
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Previene volver con botón atrás (Se mantiene igual)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Gestión de Proformas</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

        <style>
            /* Estilos se mantienen igual */
            .modal.hidden {
                display: none;
            }
            .modal {
                position: fixed;
                inset: 0;
                backdrop-filter: blur(4px);
                background: rgba(0,0,0,0.45);
                display: flex;
                align-items: center;
                justify-content: center;
                animation: fadeIn .25s ease-out;
                z-index: 9999;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }
            .modal-card {
                background: #ffffff;
                width: 600px;
                padding: 25px;
                border-radius: 14px;
                box-shadow: 0 8px 28px rgba(0,0,0,0.25);
                animation: pop .25s ease-out;
                transform-origin: center;
            }
            .modal-card.small {
                width: 380px;
            }
            @keyframes pop {
                from {
                    transform: scale(.85);
                    opacity: 0;
                }
                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }
            .modal-card h3 {
                margin-bottom: 15px;
                font-size: 20px;
                color: #222;
                border-bottom: 2px solid #e8e8e8;
                padding-bottom: 8px;
            }
            .modal-card input, .modal-card select, .modal-card textarea {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #cfcfcf;
                border-radius: 6px;
                font-size: 15px;
                outline: none;
                transition: .2s;
            }
            .modal-card input:focus, .modal-card select:focus, .modal-card textarea:focus {
                border-color: #0066ff;
                box-shadow: 0 0 0 2px rgba(0,102,255,0.2);
            }
            .modal-footer {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
                gap: 12px;
            }
            .modal-footer.two {
                justify-content: space-between;
            }
            .btn {
                padding: 8px 16px;
                border-radius: 6px;
                border: none;
                cursor: pointer;
                font-size: 14px;
                transition: .2s;
            }
            .btn:hover {
                opacity: .85;
            }
            .btn-primary {
                background: #0066ff;
                color: #fff;
            }
            .btn-danger {
                background: #d93025;
                color: white;
            }
            textarea {
                resize: vertical;
                min-height: 70px;
            }
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

    <body>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" class="logo" alt="AZ">
                    <span class="brand__label">Proformas</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a class="active" href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.jsp">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
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

            <div class="toolbar">
                <div>Gestión de Proformas</div>
                <button class="btn btn-primary btn-round" id="btn-open-create">+ Crear Proforma</button>
            </div>

            <div class="table-wrapper">
                <table class="table flat">
                    <thead>
                        <tr>
                            <th>ID Proforma</th>
                            <th>Fecha</th>
                            <th>ID Cliente</th>
                            <th>Nombre Cliente</th> <%-- Columna del nombre completo --%>
                            <th>Monto Estimado</th>
                            <th>Estado</th>
                            <th class="center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${listaProformas}">
                            <tr id="proforma-${fn:escapeXml(p.idProforma)}"
                                data-id="${fn:escapeXml(p.idProforma)}"
                                data-cliente-id="${fn:escapeXml(p.idCliente)}"
                                data-monto="${p.montoEstimado}"
                                data-estado="${p.estado}">

                                <td>${p.idProforma}</td>
                                <td>${p.fecha}</td>
                                <td>${p.idCliente}</td>
                                <td>${p.nombreCliente}</td> <%-- Aquí se usa el campo concatenado --%>
                                <td>S/ ${p.montoEstimado}</td>
                                <td>${p.estado}</td>

                                <td class="center">
                                    <button class="icon-btn" title="Modificar" data-edit="${fn:escapeXml(p.idProforma)}">✏️</button>
                                    <button class="icon-btn danger" title="Eliminar" data-delete="${fn:escapeXml(p.idProforma)}">🗑️</button>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listaProformas}">
                            <tr><td colspan="7" class="center">No hay proformas registradas.</td></tr>
                        </c:if>

                    </tbody>
                </table>
            </div>

        </main>

        <div id="modal-crud-proforma" class="modal hidden">
            <div class="modal-card">
                <h3 id="modal-title">Registrar Nueva Proforma</h3>

                <form method="post" action="${pageContext.request.contextPath}/proformas/guardar" id="form-crud-proforma">

                    <div>
                        <label>ID Proforma *</label>
                        <input type="text" name="id_proforma" id="crud-id-proforma" required maxlength="15">
                    </div>

                    <div class="grid2">
                        <div>
                            <label>Cliente * (DNI/RUC)</label>
                            <select name="id_cliente" id="crud-id-cliente" required>
                                <option value="">-- Seleccione Cliente --</option>
                                <c:forEach var="cliente" items="${listaClientes}">
                                    <option value="${cliente.dni}">
                                        ${cliente.dni} - ${cliente.nombres} ${cliente.apellidos}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div>
                            <label>Monto Estimado (S/)</label>
                            <input type="number" step="0.01" id="crud-monto-estimado" name="monto_estimado" required min="0">
                        </div>
                    </div>

                    <div>
                        <label>Estado</label>
                        <select name="estado" id="crud-estado" required>
                            <option value="PENDIENTE">PENDIENTE</option>
                            <option value="ACEPTADA">ACEPTADA</option>
                            <option value="RECHAZADA">RECHAZADA</option>
                        </select>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
                    </div>

                </form>
            </div>
        </div>

        <div id="modal-delete" class="modal hidden">
            <div class="modal-card small">
                <h3>¿Eliminar Proforma?</h3>
                <form method="post" action="${pageContext.request.contextPath}/proformas/eliminar">
                    <input type="hidden" id="delete-id" name="id_proforma">
                    <div class="modal-footer two">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            const qs = s => document.querySelector(s);
            const open = m => m.classList.remove("hidden");
            const close = m => m.classList.add("hidden");

            document.querySelectorAll("[data-close]").forEach(btn =>
                btn.addEventListener("click", e => close(e.target.closest(".modal")))
            );

            const modal = qs("#modal-crud-proforma");
            const form = qs("#form-crud-proforma");
            const title = qs("#modal-title");
            const submitBtn = qs("#crud-submit-btn");

            const inputIdProforma = qs("#crud-id-proforma");

            const resetModal = () => {
                form.reset();
                inputIdProforma.value = "";
                inputIdProforma.readOnly = false; // Permitir edición para nuevo registro
                title.textContent = "Registrar Nueva Proforma";
                submitBtn.textContent = "Registrar";
            };

            qs("#btn-open-create").addEventListener("click", () => {
                resetModal();
                qs("#crud-estado").value = "PENDIENTE";
                open(modal);
            });

            // EDITAR
            document.addEventListener("click", e => {
                const btn = e.target.closest("[data-edit]");
                if (!btn)
                    return;

                const id = btn.dataset.edit;
                const row = qs("#proforma-" + id);

                inputIdProforma.value = row.dataset.id;
                inputIdProforma.readOnly = true; // No permitir cambiar el ID al editar

                // CAMBIO: ID Cliente
                qs("#crud-id-cliente").value = row.dataset.clienteId;

                qs("#crud-monto-estimado").value = row.dataset.monto;
                qs("#crud-estado").value = row.dataset.estado;

                title.textContent = "Modificar Proforma ID: " + id;
                submitBtn.textContent = "Guardar Cambios";

                open(modal);
            });

            // ELIMINAR (Se mantiene igual, ya que usa el atributo data-delete)
            document.addEventListener("click", e => {
                const btn = e.target.closest("[data-delete]");
                if (!btn)
                    return;

                qs("#delete-id").value = btn.dataset.delete;
                open(qs("#modal-delete"));
            });

        </script>

    </body>
</html>