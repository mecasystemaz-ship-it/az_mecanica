<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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
        <title>AZ Mecánica | Proveedores</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
        <style>
            /* Misma estilización que servicios */
            .alert {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .grid2 {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }
            .form-footer {
                margin-top: 20px;
                text-align: right;
            }
        </style>
    </head>
    <body>
        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
                    <span class="brand__label">Proveedores</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/login.jsp">Cerrar sesión</a>
            </div>
        </header>

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
                <div class="toolbar-left"><span>Catálogo de Proveedores</span></div>
                <div class="toolbar-right">
                    <button type="button" id="btn-open-create" class="btn btn-primary btn-round">+ Añadir Proveedor</button>
                </div>
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
                            data-row='{
                            "ruc": "${fn:escapeXml(p.ruc)}",
                            "nombre": "${fn:escapeXml(p.nombre)}",
                            "telefono": "${fn:escapeXml(p.telefono)}",
                            "email": "${fn:escapeXml(p.email)}",
                            "direccion": "${fn:escapeXml(p.direccion)}"
                            }'>
                            <td>${p.ruc}</td>
                            <td>${p.nombre}</td>
                            <td>${p.telefono}</td>
                            <td>${p.email}</td>
                            <td>${p.direccion}</td>
                            <td class="center">
                                <button class="icon-btn" title="Modificar" data-edit='${p.ruc}'>✏️</button>
                                <button class="icon-btn danger" title="Eliminar" data-delete='${p.ruc}'>🗑️</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listaProveedores}">
                        <tr><td colspan="6" class="center muted">No hay proveedores registrados.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <!-- Modal Registrar/Editar Proveedor -->
        <div id="modal-crud-proveedor" class="modal hidden">
            <div class="modal-card">
                <header class="modal-header">
                    <h3 id="modal-title">Registrar Nuevo Proveedor</h3>
                </header>

                <form method="post" action="${pageContext.request.contextPath}/proveedores" id="form-crud-proveedor">
                    <input type="hidden" name="action" id="crud-action" value="registrar"/>
                    <div class="grid2 gap">
                        <div class="field">
                            <label for="crud-ruc">RUC <span class="required">*</span></label>
                            <input type="text" id="crud-ruc" name="ruc" required maxlength="11"/>
                        </div>
                        <div class="field">
                            <label for="crud-nombre">Nombre <span class="required">*</span></label>
                            <input type="text" id="crud-nombre" name="nombre" required maxlength="100"/>
                        </div>
                    </div>
                    <div class="grid2 gap">
                        <div class="field">
                            <label for="crud-telefono">Teléfono</label>
                            <input type="text" id="crud-telefono" name="telefono" maxlength="20"/>
                        </div>
                        <div class="field">
                            <label for="crud-email">Email</label>
                            <input type="email" id="crud-email" name="email" maxlength="50"/>
                        </div>
                    </div>
                    <div class="field">
                        <label for="crud-direccion">Dirección</label>
                        <input type="text" id="crud-direccion" name="direccion" maxlength="100"/>
                    </div>

                    <footer class="modal-footer">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
                    </footer>
                </form>
            </div>
        </div>

        <!-- Modal Eliminar -->
        <div id="modal-delete" class="modal hidden">
            <div class="modal-card small">
                <header class="modal-header center">
                    <h3>¿Estás seguro que deseas eliminar este proveedor?</h3>
                </header>
                <form method="post" action="${pageContext.request.contextPath}/proveedores">
                    <input type="hidden" name="ruc" id="delete-id"/>
                    <input type="hidden" name="action" value="eliminar"/>
                    <footer class="modal-footer two">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" class="btn btn-danger">Confirmar</button>
                    </footer>
                </form>
            </div>
        </div>

        <script>
        // Helpers
            const qs = s => document.querySelector(s);
            const open = el => el.classList.remove('hidden');
            const close = el => el.classList.add('hidden');
            document.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', e => close(e.target.closest('.modal'))));

            const modal = qs('#modal-crud-proveedor');
            const form = qs('#form-crud-proveedor');
            const title = qs('#modal-title');
            const submitBtn = qs('#crud-submit-btn');
            const actionInput = qs('#crud-action');

        // Reset modal
            const resetModal = () => {
                form.reset();
                actionInput.value = 'registrar';
                title.textContent = 'Registrar Nuevo Proveedor';
                submitBtn.textContent = 'Registrar';
                qs('#crud-ruc').removeAttribute('readonly');
            };

        // Abrir modal CREAR
            qs('#btn-open-create').addEventListener('click', () => {
                resetModal();
                open(modal);
            });

        // Abrir modal EDITAR
            document.addEventListener('click', (e) => {
                const editBtn = e.target.closest('[data-edit]');
                if (!editBtn)
                    return;

                const ruc = editBtn.dataset.edit;
                const row = qs(`#proveedor-${ruc}`);
                const data = JSON.parse(row.getAttribute('data-row'));

                qs('#crud-ruc').value = data.ruc;
                qs('#crud-nombre').value = data.nombre;
                qs('#crud-telefono').value = data.telefono;
                qs('#crud-email').value = data.email;
                qs('#crud-direccion').value = data.direccion;

                qs('#crud-ruc').setAttribute('readonly', true);
                actionInput.value = 'modificar';
                title.textContent = 'Modificar Proveedor: ' + data.ruc;
                submitBtn.textContent = 'Guardar Cambios';
                open(modal);
            });

        // Abrir modal ELIMINAR
            document.addEventListener('click', (e) => {
                const delBtn = e.target.closest('[data-delete]');
                if (!delBtn)
                    return;
                qs('#delete-id').value = delBtn.dataset.delete;
                open(qs('#modal-delete'));
            });
        </script>
    </body>
</html>
