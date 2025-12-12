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

    .modal.hidden { display: none; }

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
        from { opacity: 0; }
        to { opacity: 1; }
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
        from { transform: scale(.85); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
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

    .btn:hover { opacity: .85; }

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
    .alert { padding: 10px; margin-bottom: 20px; border-radius: 4px; }
    .alert-success { background: #d4edda; color: #155724; }
    .alert-danger { background: #f8d7da; color: #721c24; }

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
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar sesión</a>
    </div>
</header>

<nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
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

            <div class="grid2">
                <div>
                    <label>Nombre *</label>
                    <input type="text" name="nombre" id="crud-nombre" required>
                </div>

                <div>
                    <label>Categoría</label>
                    <select name="categoria" id="crud-categoria">
                        <option value="">Seleccione</option>
                        <option>Mantenimiento</option>
                        <option>Diagnóstico</option>
                        <option>Reparación</option>
                        <option>Otro</option>
                    </select>
                </div>
            </div>

            <div class="grid2">
                <div>
                    <label>Precio (S/)</label>
                    <input type="number" step="0.01" id="crud-precio" name="precio" required>
                </div>

                <div>
                    <label>Tiempo estimado</label>
                    <input type="text" id="crud-tiempo" name="tiempo_estimado">
                </div>
            </div>

            <div>
                <label>Descripción</label>
                <textarea name="descripcion" id="crud-descripcion"></textarea>
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
        if (!btn)    return;

        const id = btn.dataset.edit;
        const row = qs("#servicio-" + id);

        qs("#crud-id-servicio").value = row.dataset.id;
        qs("#crud-nombre").value = row.dataset.nombre;
        qs("#crud-categoria").value = row.dataset.categoria;
        qs("#crud-precio").value = row.dataset.precio;
        qs("#crud-tiempo").value = row.dataset.tiempo;
        qs("#crud-descripcion").value = row.dataset.descripcion;

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
