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
        <title>AZ Mecánica | Empleados</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

        <style>
            /* ----------- ESTILOS DEL MODAL ----------- */

            .modal.hidden {
                display: none;
            }

            .modal {
                position: fixed;
                inset: 0;
                backdrop-filter: blur(4px);
                background: rgba(0, 0, 0, 0.45);
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
                background: #fff;
                width: 600px;
                padding: 25px;
                border-radius: 14px;
                box-shadow: 0 8px 28px rgba(0,0,0,0.25);
                animation: pop .25s ease-out;
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
                color: #fff;
            }

            .modal-card input[readonly],
            .modal-card input[disabled],
            .modal-card select[disabled] {
                background-color: #f7f7f7;
                cursor: not-allowed;
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
            .grid3 {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }

            .tag {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 13px;
            }

            .tag.success {
                background: #d4edda;
                color: #155724;
            }
            .tag.danger {
                background: #f8d7da;
                color: #721c24;
            }

            /* Estilo para los botones de la tabla */
            .icon-btn.danger {
                background: #d93025;
                color: #fff;
            }
            .icon-btn.success {
                background: #28a745;
                color: #fff;
            }
        </style>
    </head>

    <body>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" class="logo" alt="AZ">
                    <span class="brand__label">Empleados</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/login.jsp">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a class="active" href="${pageContext.request.contextPath}/empleados">Empleados</a>
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
                <div>Gestión de Empleados</div>
                <button class="btn btn-primary btn-round" id="btn-open-create">+ Registrar Empleado</button>
            </div>

            <div class="table-wrapper">
                <table class="table flat">
                    <thead>
                        <tr>
                            <th>DNI</th>
                            <th>Nombre Completo</th>
                            <th>Cargo</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Fecha Contratación</th>
                            <th>Estado</th>
                            <th class="center">Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="e" items="${listaEmpleados}">
                            <tr id="empleado-${e.dni}"
                                data-dni="${e.dni}"
                                data-nombres="${fn:escapeXml(e.nombres)}"
                                data-apellidos="${fn:escapeXml(e.apellidos)}"
                                data-telefono="${fn:escapeXml(e.telefono)}"
                                data-email="${fn:escapeXml(e.email)}"
                                data-cargo="${fn:escapeXml(e.cargo)}"
                                data-fecha-contratacion="${e.fechaContratacion}"
                                data-salario="${e.salario}"
                                data-estado="${e.estado}">

                                <td>${e.dni}</td>
                                <td>${e.nombres} ${e.apellidos}</td>
                                <td><span class="tag">${e.cargo}</span></td>
                                <td>${e.telefono}</td>
                                <td>${e.email}</td>
                                <td>${e.fechaContratacion}</td>
                                <td>
                                    <span class="tag ${e.estado ? 'success' : 'danger'}">
                                        ${e.estado ? 'Activo' : 'Inactivo'}
                                    </span>
                                </td>

                                <td class="center">
                                    <button class="icon-btn" title="Ver" data-view="${e.dni}">👁️</button>
                                    <button class="icon-btn" title="Modificar" data-edit="${e.dni}">✏️</button>

                                    <c:set var="nombreCompleto"
                                           value="${fn:escapeXml(e.nombres)} ${fn:escapeXml(e.apellidos)}"/>

                                    <button class="icon-btn ${e.estado ? 'danger' : 'success'}"
                                            title="${e.estado ? 'Desactivar' : 'Activar'}"
                                            data-toggle-status="${e.dni}"
                                            data-nombre-completo="${nombreCompleto}"
                                            data-estado-actual="${e.estado ? 'Activo' : 'Inactivo'}">
                                        ${e.estado ? '🚫' : '✅'}
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listaEmpleados}">
                            <tr><td colspan="8" class="center">No hay empleados registrados.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </main>

        <div id="modal-crud-empleado" class="modal hidden">
            <div class="modal-card">
                <h3 id="modal-title">Registrar Nuevo Empleado</h3>

                <form method="post" action="${pageContext.request.contextPath}/empleados/guardar" id="form-crud-empleado">

                    <div class="grid2">
                        <div>
                            <label>DNI *</label>
                            <input type="text" name="dni" id="crud-dni" required maxlength="15">
                        </div>
                        <div>
                            <label>Teléfono</label>
                            <input type="text" name="telefono" id="crud-telefono" maxlength="20">
                        </div>
                    </div>

                    <div class="grid2">
                        <div>
                            <label>Nombres *</label>
                            <input type="text" name="nombres" id="crud-nombres" required>
                        </div>
                        <div>
                            <label>Apellidos *</label>
                            <input type="text" name="apellidos" id="crud-apellidos" required>
                        </div>
                    </div>

                    <div class="grid3">
                        <div>
                            <label>Email</label>
                            <input type="email" name="email" id="crud-email">
                        </div>

                        <div>
                            <label>Cargo</label>
                            <select name="cargo" id="crud-cargo">
                                <option value="Mecánico">Mecánico</option>
                                <option value="Asesor de Servicio">Asesor de Servicio</option>
                                <option value="Administrador">Administrador</option>
                                <option value="Otros">Otros</option>
                            </select>
                        </div>

                        <div>
                            <label>Salario (S/)</label>
                            <input type="number" step="0.01" id="crud-salario" name="salario" required min="0">
                        </div>
                    </div>

                    <div>
                        <label>Fecha Contratación</label>
                        <input type="date" name="fecha_contratacion" id="crud-fecha-contratacion" required>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="modal-toggle-estado" class="modal hidden">
            <div class="modal-card small">
                <h3 id="toggle-title">Cambiar Estado de Empleado</h3>

                <p id="toggle-message">
                    ¿Estás seguro de cambiar el estado del empleado
                    <strong id="toggle-name-display"></strong>
                    (<strong id="toggle-dni-display"></strong>)
                    de <strong id="toggle-estado-actual"></strong>
                    a <strong id="toggle-nuevo-estado"></strong>?
                </p>

                <form method="post" action="${pageContext.request.contextPath}/empleados/cambiarEstado"
                      id="form-toggle-estado">

                    <input type="hidden" id="toggle-dni-input" name="dni">
                    <input type="hidden" id="toggle-nombre-completo-input" name="nombre_completo">

                    <div class="modal-footer two">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" id="toggle-submit-btn" class="btn btn-danger">Confirmar</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            const qs = s => document.querySelector(s);
            const open = m => m.classList.remove("hidden");
            const close = m => m.classList.add("hidden");

            // Modal y elementos CRUD
            const modalCRUD = qs("#modal-crud-empleado");
            const formCRUD = qs("#form-crud-empleado");
            const titleCRUD = qs("#modal-title");
            const submitBtnCRUD = qs("#crud-submit-btn");
            const inputDni = qs("#crud-dni");
            const modalFooter = qs("#modal-crud-empleado .modal-footer");

            // Modal y elementos Toggle Status
            const modalToggle = qs("#modal-toggle-estado");
            const formToggle = qs("#form-toggle-estado");
            const toggleNameDisplay = qs("#toggle-name-display");
            const toggleDniDisplay = qs("#toggle-dni-display");
            const toggleEstadoActual = qs("#toggle-estado-actual");
            const toggleNuevoEstado = qs("#toggle-nuevo-estado");
            const toggleDniInput = qs("#toggle-dni-input");
            const toggleSubmitBtn = qs("#toggle-submit-btn");


            // Función para poner inputs en readonly o habilitados
            function setFormReadOnly(isReadOnly) {
                formCRUD.querySelectorAll("input, select").forEach(el => {
                    if (el.id !== 'crud-dni') {
                        el.readOnly = isReadOnly;
                        el.disabled = isReadOnly;
                    }
                });

                if (isReadOnly) {
                    submitBtnCRUD.style.display = 'none';
                    modalFooter.querySelector('[data-close]').textContent = 'Cerrar';
                } else {
                    submitBtnCRUD.style.display = 'block';
                    modalFooter.querySelector('[data-close]').textContent = 'Cancelar';
                }
            }

            // Reset modal para crear nuevo empleado
            const resetModal = () => {
                formCRUD.reset();
                inputDni.value = "";
                inputDni.removeAttribute("readonly");
                inputDni.disabled = false;

                // Remover cualquier input hidden de edición
                const hidden = formCRUD.querySelector('input[name="dni_edit"]');
                if (hidden)
                    hidden.remove();

                formCRUD.setAttribute('action', '${pageContext.request.contextPath}/empleados/guardar');
                setFormReadOnly(false);
                titleCRUD.textContent = "Registrar Nuevo Empleado";
                submitBtnCRUD.textContent = "Registrar";
            };

            // Abrir modal de creación
            qs("#btn-open-create").addEventListener("click", () => {
                resetModal();
                open(modalCRUD);
            });

            // Cargar datos de empleado en el formulario
            function loadEmployeeData(dni) {
                const row = qs("#empleado-" + dni);
                qs("#crud-dni").value = row.dataset.dni;
                qs("#crud-nombres").value = row.dataset.nombres;
                qs("#crud-apellidos").value = row.dataset.apellidos;
                qs("#crud-telefono").value = row.dataset.telefono;
                qs("#crud-email").value = row.dataset.email;
                qs("#crud-cargo").value = row.dataset.cargo;
                qs("#crud-fecha-contratacion").value = row.dataset.fechaContratacion;
                qs("#crud-salario").value = row.dataset.salario;
            }

            // Manejo de cierres de modales
            document.querySelectorAll('[data-close]').forEach(btn => {
                btn.addEventListener('click', () => {
                    close(modalCRUD);
                    close(modalToggle);
                });
            });

            // Manejo de clics en tabla (Ver, Editar, Cambiar Estado)
            document.addEventListener("click", e => {
                const btnEdit = e.target.closest("[data-edit]");
                const btnView = e.target.closest("[data-view]");
                const btnToggle = e.target.closest("[data-toggle-status]"); // Nuevo botón

                // --- Lógica para MODAL CRUD (Ver/Editar) ---
                if (btnEdit || btnView) {
                    close(modalToggle); // Cierra el otro modal por si acaso

                    const dni = btnEdit ? btnEdit.dataset.edit : btnView.dataset.view;
                    const isViewMode = !!btnView;

                    resetModal();
                    loadEmployeeData(dni);

                    if (isViewMode) {
                        // Solo lectura
                        setFormReadOnly(true);
                        inputDni.readOnly = true;
                        inputDni.disabled = true;
                        titleCRUD.textContent = "Ver Detalles del Empleado (DNI: " + dni + ")";
                    } else {
                        // Edición
                        let inputHidden = document.createElement("input");
                        inputHidden.type = "hidden";
                        inputHidden.name = "dni_edit";
                        inputHidden.value = dni;
                        formCRUD.appendChild(inputHidden);

                        setFormReadOnly(false);
                        inputDni.setAttribute("readonly", true);
                        inputDni.disabled = false;

                        formCRUD.setAttribute('action', '${pageContext.request.contextPath}/empleados/guardar');
                        titleCRUD.textContent = "Modificar Empleado (DNI: " + dni + ")";
                        submitBtnCRUD.textContent = "Guardar Cambios";
                    }
                    open(modalCRUD);
                    return;
                }

                // --- Lógica para MODAL CAMBIO DE ESTADO ---
                if (btnToggle) {
                    close(modalCRUD); // Cierra el otro modal por si acaso

                    const dni = btnToggle.dataset.toggleStatus;
                    const nombreCompleto = btnToggle.dataset.nombreCompleto;
                    const estadoActualText = btnToggle.dataset.estadoActual;

                    // Determinar nuevo estado y estilo del botón
                    const isActivo = estadoActualText === 'Activo';
                    const nuevoEstadoText = isActivo ? 'Inactivo' : 'Activo';
                    const actionUrl = '${pageContext.request.contextPath}/empleados/cambiarEstado';

                    // Llenar el modal de cambio de estado
                    toggleNameDisplay.textContent = nombreCompleto;
                    toggleDniDisplay.textContent = dni;
                    toggleEstadoActual.textContent = estadoActualText;
                    toggleNuevoEstado.textContent = nuevoEstadoText;

                    toggleDniInput.value = dni;

                    // Cambiar el texto y clase del botón de confirmación
                    toggleSubmitBtn.textContent = isActivo ? 'Desactivar' : 'Activar';
                    toggleSubmitBtn.classList.remove('btn-danger', 'btn-success');
                    toggleSubmitBtn.classList.add(isActivo ? 'btn-danger' : 'btn-success');

                    // Asegúrate de que la acción del formulario envíe la información correcta
                    // Se asume que el backend (Servlet) recibirá 'dni' y manejará el toggle
                    formToggle.setAttribute('action', actionUrl);

                    // Abrir el modal
                    open(modalToggle);
                    return;
                }
            });
        </script>


    </body>
</html>