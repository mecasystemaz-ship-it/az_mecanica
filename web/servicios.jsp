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
        <title>AZ Mecánica | Catálogo de Servicios</title>
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

            textarea {
                resize: vertical;
                min-height: 70px;
            }

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

    <body>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" class="logo" alt="AZ">
                    <span class="brand__label">Servicios</span>
                </div>
                    
                    <jsp:include page="saludoadmin.jsp" />
                
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
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
            <a class="active" href="${pageContext.request.contextPath}/servicios">Servicios</a>
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
                <div>Catálogo de Servicios</div>
                <button class="btn btn-primary btn-round" id="btn-open-create">+ Añadir Servicio</button>
            </div>

            <div class="table-wrapper">
                <table class="table flat">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Servicio</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Tiempo</th>
                            <th class="center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:forEach var="s" items="${listaServicios}">
                            <tr id="servicio-${s.idServicio}"
                                data-id="${s.idServicio}"
                                data-nombre="${fn:escapeXml(s.nombre)}"
                                data-categoria="${fn:escapeXml(s.categoria)}"
                                data-precio="${s.precio}"
                                data-tiempo="${fn:escapeXml(s.tiempoEstimado)}"
                                data-descripcion="${fn:escapeXml(s.descripcion)}">

                                <td>${s.idServicio}</td>
                                <td>${s.nombre}</td>
                                <td>${s.categoria}</td>
                                <td>S/ ${s.precio}</td>
                                <td>${s.tiempoEstimado}</td>

                                <td class="center">
                                    <button class="icon-btn" title="Modificar" data-edit="${s.idServicio}">✏️</button>
                                    <button class="icon-btn danger" title="Eliminar" data-delete="${s.idServicio}">🗑️</button>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listaServicios}">
                            <tr><td colspan="6" class="center">No hay servicios registrados.</td></tr>
                        </c:if>

                    </tbody>
                </table>
            </div>

        </main>

        <!-- Modal CRUD -->
        <div id="modal-crud-service" class="modal hidden">
    <div class="modal-card">
        <h3 id="modal-title">Registrar Nuevo Servicio</h3>

        <form method="post" action="${pageContext.request.contextPath}/servicios/guardar" id="form-crud-service">

            <input type="hidden" id="crud-id-servicio" name="id_servicio">

            <div style="margin-bottom: 15px; background: #f9f9f9; padding: 10px; border-radius: 8px; border: 1px dashed #ccc;">
                <label style="font-weight: bold; display: block; margin-bottom: 5px;">⚡ Carga rápida (Opcional)</label>
                <select id="select-predefinido" style="width: 100%;">
                    <option value="">-- Seleccionar de la lista --</option>
                    </select>
            </div>

            <div class="grid2">
                <div>
                    <label>Nombre *</label>
                    <input type="text" name="nombre" id="crud-nombre" required placeholder="Ej: Cambio de Aceite">
                </div>

                <div>
                    <label>Categoría</label>
                    <select name="categoria" id="crud-categoria">
                        <option value="">Seleccione</option>
                        <option>Mantenimiento</option>
                        <option>Diagnóstico</option>
                        <option>Reparación</option>
                        <option>Sistema Eléctrico</option> <option>Frenos</option>
                        <option>Otro</option>
                    </select>
                </div>
            </div>

            <div class="grid2">
                <div>
                    <label>Precio (S/)</label>
                    <input type="number" step="0.01" id="crud-precio" name="precio" required placeholder="0.00">
                </div>

                <div>
                    <label>Tiempo estimado</label>
                    <input type="text" id="crud-tiempo" name="tiempo_estimado" placeholder="Ej: 2 horas">
                </div>
            </div>

            <div>
                <label>Descripción</label>
                <textarea name="descripcion" id="crud-descripcion" placeholder="Detalles del servicio..."></textarea>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn" data-close>Cancelar</button>
                <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
            </div>

        </form>
    </div>
</div>

        <!-- Modal Delete -->
        <div id="modal-delete" class="modal hidden">
            <div class="modal-card small">
                <h3>¿Eliminar servicio?</h3>
                <form method="post" action="${pageContext.request.contextPath}/servicios/eliminar">
                    <input type="hidden" id="delete-id" name="id_servicio">
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

    // --- BASE DE DATOS LOCAL DE SERVICIOS ---
    const serviciosPredefinidos = [
        { nombre: "Cambio de Aceite y Filtro", cat: "Mantenimiento", precio: 80.00, tiempo: "45 min", desc: "Cambio de aceite de motor sintético y reemplazo de filtro de aceite." },
        { nombre: "Afinamiento de Motor", cat: "Mantenimiento", precio: 250.00, tiempo: "3 horas", desc: "Limpieza de inyectores, cambio de bujías y filtros de aire/combustible." },
        { nombre: "Mantenimiento de Frenos", cat: "Frenos", precio: 120.00, tiempo: "2 horas", desc: "Limpieza, regulación y cambio de pastillas de freno (delanteras/traseras)." },
        { nombre: "Escaneo Electrónico (Scanner)", cat: "Diagnóstico", precio: 50.00, tiempo: "30 min", desc: "Diagnóstico computarizado de fallas con scanner OBD2." },
        { nombre: "Alineación y Balanceo", cat: "Mantenimiento", precio: 90.00, tiempo: "1.5 horas", desc: "Alineación de dirección 3D y balanceo de 4 ruedas." },
        { nombre: "Cambio de Kit de Embrague", cat: "Reparación", precio: 450.00, tiempo: "5 horas", desc: "Bajada de caja y reemplazo de disco, plato y collarín. (No incluye repuestos)" },
        { nombre: "Limpieza de Sistema de Inyección", cat: "Mantenimiento", precio: 180.00, tiempo: "2.5 horas", desc: "Limpieza profunda de inyectores y cuerpo de aceleración." },
        { nombre: "Reparación de Suspensión", cat: "Reparación", precio: 200.00, tiempo: "4 horas", desc: "Cambio de amortiguadores, trapecios y terminales de dirección." },
        { nombre: "Recarga de Aire Acondicionado", cat: "Mantenimiento", precio: 150.00, tiempo: "1 hora", desc: "Vacío del sistema, prueba de fugas y recarga de gas refrigerante." },
        { nombre: "Cambio de Correa de Distribución", cat: "Reparación", precio: 350.00, tiempo: "6 horas", desc: "Reemplazo preventivo del kit de distribución y bomba de agua." }
    ];

    // Llenar el select al cargar la página
    const selectPre = qs("#select-predefinido");
    serviciosPredefinidos.forEach((s, index) => {
        const option = document.createElement("option");
        option.value = index; // Usamos el índice para buscarlo rápido
        option.textContent = s.nombre;
        selectPre.appendChild(option);
    });

    // Evento: Cuando el usuario elige un servicio de la lista
    selectPre.addEventListener("change", function() {
        const idx = this.value;
        if (idx !== "") {
            const s = serviciosPredefinidos[idx];
            qs("#crud-nombre").value = s.nombre;
            // Intentar seleccionar la categoría si existe en el select, si no, dejarla o poner 'Otro'
            const catOption = Array.from(qs("#crud-categoria").options).find(opt => opt.value === s.cat);
            qs("#crud-categoria").value = catOption ? s.cat : "";
            
            qs("#crud-precio").value = s.precio;
            qs("#crud-tiempo").value = s.tiempo;
            qs("#crud-descripcion").value = s.desc;
        } else {
            // Si vuelve a "Seleccionar...", limpiamos (opcional)
            qs("#form-crud-service").reset();
            qs("#crud-id-servicio").value = ""; // Mantener limpio el ID
        }
    });

    // --- FUNCIONALIDAD EXISTENTE ---

    document.querySelectorAll("[data-close]").forEach(btn =>
        btn.addEventListener("click", e => close(e.target.closest(".modal")))
    );

    const modal = qs("#modal-crud-service");
    const form = qs("#form-crud-service");
    const title = qs("#modal-title");
    const submitBtn = qs("#crud-submit-btn");

    const resetModal = () => {
        form.reset();
        qs("#crud-id-servicio").value = "";
        qs("#select-predefinido").value = ""; // Resetear también el select especial
        title.textContent = "Registrar Nuevo Servicio";
        submitBtn.textContent = "Registrar";
    };

    qs("#btn-open-create").addEventListener("click", () => {
        resetModal();
        open(modal);
    });

    // EDITAR
    document.addEventListener("click", e => {
        const btn = e.target.closest("[data-edit]");
        if (!btn) return;

        const id = btn.dataset.edit;
        const row = qs("#servicio-" + id);

        resetModal(); // Limpiamos primero

        qs("#crud-id-servicio").value = row.dataset.id;
        qs("#crud-nombre").value = row.dataset.nombre;
        qs("#crud-categoria").value = row.dataset.categoria;
        qs("#crud-precio").value = row.dataset.precio;
        qs("#crud-tiempo").value = row.dataset.tiempo;
        qs("#crud-descripcion").value = row.dataset.descripcion;

        // En modo edición, quizás quieras bloquear el select de carga rápida para no confundir
        qs("#select-predefinido").value = ""; 
        
        title.textContent = "Modificar Servicio ID: " + id;
        submitBtn.textContent = "Guardar Cambios";

        open(modal);
    });

    // ELIMINAR
    document.addEventListener("click", e => {
        const btn = e.target.closest("[data-delete]");
        if (!btn) return;

        qs("#delete-id").value = btn.dataset.delete;
        open(qs("#modal-delete"));
    });

</script>

    </body>
</html>
