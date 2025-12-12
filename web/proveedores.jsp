<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // Protección de acceso
    String rolGuard = (String) session.getAttribute("rol");
    if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Previene volver con botón atrás
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AZ Mecánica | Proveedores</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

        <style>
            /* 🎨✨ --- MODAL MEJORADO --- ✨🎨 */
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

            .modal-card input,
            .modal-card select,
            .modal-card textarea {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #cfcfcf;
                border-radius: 6px;
                font-size: 15px;
                outline: none;
                transition: .2s;
            }
            .modal-card input:focus,
            .modal-card select:focus,
            .modal-card textarea:focus {
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

            /* Alertas */
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

            /* Tabla */
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
                    <span class="brand__label">Proveedores</span>
                </div>
                    <jsp:include page="saludoadmin.jsp" />
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
            <a class="active" href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
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
                <div>Catálogo de Proveedores</div>
                <button class="btn btn-primary btn-round" id="btn-open-create">+ Añadir Proveedor</button>
            </div>

            <div class="table-wrapper">
                <table class="table flat">
                    <thead>
                        <tr>
                            <th>RUC</th>
                            <th>Nombre</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Dirección</th>
                            <th class="center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${listaProveedores}">
                            <tr id="proveedor-${p.ruc}"
                                data-ruc="${fn:escapeXml(p.ruc)}"
                                data-nombre="${fn:escapeXml(p.nombre)}"
                                data-telefono="${fn:escapeXml(p.telefono)}"
                                data-email="${fn:escapeXml(p.email)}"
                                data-direccion="${fn:escapeXml(p.direccion)}">
                                <td>${p.ruc}</td>
                                <td>${p.nombre}</td>
                                <td>${p.telefono}</td>
                                <td>${p.email}</td>
                                <td>${p.direccion}</td>
                                <td class="center">
                                    <button class="icon-btn" title="Modificar" data-edit="${p.ruc}">✏️</button>
                                    <button class="icon-btn danger" title="Eliminar" data-delete="${p.ruc}">🗑️</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaProveedores}">
                            <tr><td colspan="6" class="center">No hay proveedores registrados.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </main>

        <!-- Modal CRUD Proveedor -->
        <div id="modal-crud-proveedor" class="modal hidden">
    <div class="modal-card">
        <h3 id="modal-title">Registrar Nuevo Proveedor</h3>

        <form method="post" action="${pageContext.request.contextPath}/proveedores" id="form-crud-proveedor">
            <input type="hidden" name="action" id="crud-action" value="registrar"/>

            <div class="grid2">
                <div>
                    <label>RUC *</label>
                    <input type="text" name="ruc" id="crud-ruc" maxlength="11" required 
                           placeholder="Ej: 20601234567">
                </div>
                <div>
                    <label>Nombre / Razón Social *</label>
                    <input type="text" name="nombre" id="crud-nombre" maxlength="100" required 
                           placeholder="Ej: Repuestos Arequipa S.A.C.">
                </div>
            </div>

            <div class="grid2">
                <div>
                    <label>Teléfono</label>
                    <input type="text" name="telefono" id="crud-telefono" maxlength="20" 
                           placeholder="Ej: 987 654 321">
                </div>
                <div>
                    <label>Email</label>
                    <input type="email" name="email" id="crud-email" maxlength="50" 
                           placeholder="contacto@empresa.com">
                </div>
            </div>

            <div>
                <label>Dirección</label>
                <input type="text" name="direccion" id="crud-direccion" maxlength="100" 
                       placeholder="Ej: Av. Ejército 1010, Yanahuara">
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-close>Cancelar</button>
                <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
            </div>
        </form>
    </div>
</div>

        <!-- Modal Eliminar -->
        <div id="modal-delete" class="modal hidden">
            <div class="modal-card small">
                <h3>¿Eliminar proveedor?</h3>
                <form method="post" action="${pageContext.request.contextPath}/proveedores">
                    <input type="hidden" id="delete-id" name="ruc">
                    <input type="hidden" name="action" value="eliminar">
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

            const modal = qs("#modal-crud-proveedor");
            const form = qs("#form-crud-proveedor");
            const title = qs("#modal-title");
            const submitBtn = qs("#crud-submit-btn");
            const actionInput = qs("#crud-action");

            const resetModal = () => {
                form.reset();
                actionInput.value = "registrar";
                title.textContent = "Registrar Nuevo Proveedor";
                submitBtn.textContent = "Registrar";
                qs("#crud-ruc").removeAttribute("readonly");
            };

            qs("#btn-open-create").addEventListener("click", () => {
                resetModal();
                open(modal);
            });

            // EDITAR
            document.addEventListener("click", e => {
                const btn = e.target.closest("[data-edit]");
                if (!btn)
                    return;

                const ruc = btn.dataset.edit;
                const row = qs("#proveedor-" + ruc);

                qs("#crud-ruc").value = row.dataset.ruc;
                qs("#crud-nombre").value = row.dataset.nombre;
                qs("#crud-telefono").value = row.dataset.telefono;
                qs("#crud-email").value = row.dataset.email;
                qs("#crud-direccion").value = row.dataset.direccion;

                qs("#crud-ruc").setAttribute("readonly", true);
                actionInput.value = "modificar";
                title.textContent = "Modificar Proveedor: " + row.dataset.ruc;
                submitBtn.textContent = "Guardar Cambios";

                open(modal);
            });

            // ELIMINAR
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
