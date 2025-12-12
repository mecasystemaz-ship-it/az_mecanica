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
        <title>AZ Mecánica | Catálogo de Servicios</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
        <style>
            /* Estilos de ejemplo para alerts y modals */
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
                    <span class="brand__label">Servicios</span>
                </div>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/login.jsp">Cerrar sesión</a>
            </div>
        </header>
        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a>Productos</a>
            <a>Inventario</a>
            <a href="${pageContext.request.contextPath}/citas.jsp">Citas</a>
            <a class="active" href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/vehiculos.jsp">Vehículos</a>
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
                <div class="toolbar-left">
                    <span>Catálogo de Servicios</span>
                </div>

                <div class="toolbar-right">
                    <button type="button" id="btn-open-create" class="btn btn-primary btn-round">
                        + Añadir Servicio
                    </button>
                </div>
            </div>

            <div class="table-wrapper">
                <table class="table flat">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre del Servicio</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Tiempo Estimado</th>
                            <th class="center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${listaServicios}">
                            <tr id="servicio-${s.idServicio}" 
                                data-row='{
                                "idServicio": ${s.idServicio},
                                "nombre": "${fn:escapeXml(s.nombre)}", 
                                "categoria": "${fn:escapeXml(s.categoria)}", 
                                "precio": ${s.precio},
                                "tiempoEstimado": "${fn:escapeXml(s.tiempoEstimado)}", 
                                "descripcion": "${fn:escapeXml(s.descripcion)}" 
                                }'>
                                <td>${s.idServicio}</td>
                                <td>${s.nombre}</td>
                                <td>${s.categoria}</td>
                                <td>S/ ${s.precio}</td>
                                <td>${s.tiempoEstimado}</td>
                                <td class="center">
                                    <button class="icon-btn" title="Modificar" data-edit='${s.idServicio}'>
                                        ✏️
                                    </button>
                                    <button class="icon-btn danger" title="Eliminar" data-delete='${s.idServicio}'>🗑️</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaServicios}">
                            <tr><td colspan="6" class="center muted">No hay servicios en el catálogo.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <div id="modal-crud-service" class="modal hidden">
            <div class="modal-card">
                <header class="modal-header">
                    <h3 id="modal-title">Registrar Nuevo Servicio</h3>
                </header>

                <form method="post" action="${pageContext.request.contextPath}/servicios/guardar" id="form-crud-service">

                    <input type="hidden" name="id_servicio" id="crud-id-servicio" value=""/>

                    <div class="grid2 gap">
                        <div class="field">
                            <label for="crud-nombre">Nombre del Servicio <span class="required">*</span></label>
                            <input type="text" id="crud-nombre" name="nombre" required maxlength="100"/>
                        </div>
                        <div class="field">
                            <label for="crud-categoria">Categoría</label>
                            <select id="crud-categoria" name="categoria">
                                <option value="">Seleccione</option>
                                <option value="Mantenimiento">Mantenimiento</option>
                                <option value="Diagnóstico">Diagnóstico</option>
                                <option value="Reparación">Reparación</option>
                                <option value="Otro">Otro</option>
                            </select>
                        </div>
                    </div>

                    <div class="grid2 gap">
                        <div class="field">
                            <label for="crud-precio">Precio (S/) <span class="required">*</span></label>
                            <input type="number" id="crud-precio" name="precio" step="0.01" min="0" required/>
                        </div>
                        <div class="field">
                            <label for="crud-tiempo">Tiempo Estimado</label>
                            <input type="text" id="crud-tiempo" name="tiempo_estimado" maxlength="50" placeholder="Ej: 1 hora, 30 min"/>
                        </div>
                    </div>

                    <div class="field">
                        <label for="crud-descripcion">Descripción</label>
                        <textarea id="crud-descripcion" name="descripcion" rows="3" maxlength="150"></textarea>
                    </div>

                    <footer class="modal-footer">
                        <button type="button" class="btn" data-close>Cancelar</button>
                        <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
                    </footer>
                </form>
            </div>
        </div>

        <div id="modal-delete" class="modal hidden">
            <div class="modal-card small">
                <header class="modal-header center">
                    <h3>¿Estás seguro que deseas eliminar este servicio del catálogo?</h3>
                </header>
                <form method="post" action="${pageContext.request.contextPath}/servicios/eliminar">
                    <input type="hidden" name="id_servicio" id="delete-id"/>
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

            const modal = qs('#modal-crud-service');
            const form = qs('#form-crud-service');
            const title = qs('#modal-title');
            const submitBtn = qs('#crud-submit-btn');

            // Función para limpiar y resetear el modal
            const resetModal = () => {
                form.reset();
                qs('#crud-id-servicio').value = '';
                title.textContent = 'Registrar Nuevo Servicio';
                submitBtn.textContent = 'Registrar';
            };

            // 1. Abrir modal en modo CREAR
            qs('#btn-open-create').addEventListener('click', () => {
                resetModal();
                open(modal);
            });

            // 2. Abrir modal en modo EDITAR
            document.addEventListener('click', (e) => {
                // 1. Encuentra el botón que contiene el atributo data-edit
                const editBtn = e.target.closest('[data-edit]');
                if (!editBtn)
                    return;

                // 2. CORRECCIÓN CRÍTICA: Usar .dataset para leer el ID de forma segura
                // data-edit se lee como .dataset.edit
                const id = editBtn.dataset.edit;

                if (!id) {
                    console.error('DEBUG: ID (data-edit) no pudo leerse correctamente.');
                    return;
                }

                const rowSelector = `#servicio-${id}`;
                const row = qs(rowSelector);

                // 🚨 DEBUG CRÍTICO: Muestra qué está buscando y qué encuentra
                console.log('DEBUG: Selector de fila buscado:', rowSelector);
                console.log('DEBUG: Elemento row encontrado:', row);

                if (!row) {
                    console.error('Fila de servicio no encontrada para ID:', id);
                    return;
                }

                // Si la fila se encuentra, el modal se abre.
                try {
                    const data = JSON.parse(row.getAttribute('data-row'));

                    console.log('DEBUG: Objeto de datos parseado:', data);

                    // Rellenar campos del modal
                    qs('#crud-id-servicio').value = data.idServicio || '';
                    qs('#crud-nombre').value = data.nombre || '';
                    qs('#crud-categoria').value = data.categoria || '';
                    qs('#crud-precio').value = data.precio || '';
                    qs('#crud-tiempo').value = data.tiempoEstimado || '';
                    qs('#crud-descripcion').value = data.descripcion || '';

                    // Cambiar UI y abrir
                    title.textContent = 'Modificar Servicio ID: ' + (data.idServicio || id);
                    submitBtn.textContent = 'Guardar Cambios';
                    open(modal);

                } catch (err) {
                    console.error('ERROR CRÍTICO: Falló al parsear el JSON de la fila.', err);
                    console.log('JSON de la fila que falló:', row.getAttribute('data-row'));
                }
            });

            // 3. Abrir modal de Eliminación
            document.addEventListener('click', (e) => {
                const b = e.target.closest('[data-delete]');
                if (!b)
                    return;
                qs('#delete-id').value = b.getAttribute('data-delete');
                open(qs('#modal-delete'));
            });
        </script>
    </body>
</html>