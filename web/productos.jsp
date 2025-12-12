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
    <title>AZ Mecánica | Inventario de Productos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
    <style>
        /* ----- MODALES ----- */
        .modal {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex; justify-content: center; align-items: center;
            z-index: 1000;
        }
        .modal.hidden { display: none; }
        .modal-card {
            background: #fff; border-radius: 8px; padding: 1.5rem;
            width: 90%; max-width: 500px; box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }
        .modal-card h3 { margin-top: 0; margin-bottom: 1rem; font-size: 1.4rem; }
        .modal-footer { margin-top: 1.5rem; text-align: right; }
        .modal-footer.two { display: flex; justify-content: flex-end; gap: 0.5rem; }
        .grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        input, select { width: 100%; padding: 0.5rem; margin-top: 0.3rem; border: 1px solid #ccc; border-radius: 4px; }
        .btn-outline { background: none; border: 1px solid #007bff; color: #007bff; }
        .btn-primary { background: #007bff; color: #fff; border: none; }
        .btn-danger { background: #dc3545; color: #fff; border: none; }
        .btn, .btn-outline, .btn-primary, .btn-danger { padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; }
        /* Centrado de acciones en tabla */
        .table .center { text-align: center; }
        .icon-btn { background: none; border: none; cursor: pointer; font-size: 1.2rem; margin: 0 0.2rem; }
        .icon-btn.danger { color: #dc3545; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; font-size: 1.2rem; }
        .alert { padding: 0.8rem 1rem; border-radius: 4px; margin-bottom: 1rem; }
        .alert-success { background: #d4edda; color: #155724; }
        .alert-danger { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

<header class="topbar">
    <div class="container topbar__row">
        <div class="brand">
            <img src="${pageContext.request.contextPath}/imgs/logo.png" class="logo" alt="AZ">
            <span class="brand__label">Inventario</span>
        </div>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar sesión</a>
    </div>
</header>

<nav class="tabs">
    <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
    <a>Registro de Pagos</a>
    <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
    <a class="active" href="${pageContext.request.contextPath}/productos">Inventario</a>
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
        <div>Inventario de Productos</div>
        <button class="btn btn-primary btn-round" id="btn-open-create">+ Añadir Producto</button>
    </div>

    <div class="table-wrapper">
        <table class="table flat">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Cantidad Inicial</th>
                    <th>Costo (S/)</th>
                    <th>Proveedor</th>
                    <th class="center">Acciones</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${listaProductos}">
                <tr id="producto-${p.codProducto}"
                    data-id="${p.codProducto}"
                    data-nombre="${fn:escapeXml(p.nombre)}"
                    data-categoria="${fn:escapeXml(p.categoria)}"
                    data-cant="${p.cantInicial}"
                    data-costo="${p.costo}"
                    data-proveedor="${p.idProveedor}">
                    <td>${p.codProducto}</td>
                    <td>${p.nombre}</td>
                    <td>${p.categoria}</td>
                    <td>${p.cantInicial}</td>
                    <td>S/ ${p.costo}</td>
                    <td>
                        <c:forEach var="prov" items="${listaProveedores}">
                            <c:if test="${prov.ruc == p.idProveedor}">${prov.nombre}</c:if>
                        </c:forEach>
                    </td>
                    <td class="center">
                        <button class="icon-btn" title="Modificar" data-edit="${p.codProducto}">✏️</button>
                        <button class="icon-btn danger" title="Eliminar" data-delete="${p.codProducto}">🗑️</button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listaProductos}">
                <tr><td colspan="7" class="center">No hay productos registrados.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

</main>

<!-- Modal CRUD Producto -->
<div id="modal-crud-product" class="modal hidden">
    <div class="modal-card">
        <h3 id="modal-title">Registrar Nuevo Producto</h3>

        <form method="post" action="${pageContext.request.contextPath}/productos/guardar" id="form-crud-product">
            <input type="hidden" id="crud-id-producto" name="codProducto">

            <div class="grid2">
                <div>
                    <label>Nombre *</label>
                    <input type="text" name="nombre" id="crud-nombre" placeholder="Ej: Aceite de motor" required>
                </div>
                <div>
                    <label>Categoría</label>
                    <input type="text" name="categoria" id="crud-categoria" placeholder="Ej: Lubricantes">
                </div>
            </div>

            <div class="grid2">
                <div>
                    <label>Cantidad Inicial *</label>
                    <input type="number" name="cant_inicial" id="crud-cant" min="0" required>
                </div>
                <div>
                    <label>Costo (S/)*</label>
                    <input type="number" step="0.01" name="costo" id="crud-costo" min="0" required>
                </div>
            </div>

            <div>
                <label>Proveedor *</label>
                <select name="id_proveedor" id="crud-proveedor" required>
                    <option value="">-- Seleccionar Proveedor --</option>
                    <c:forEach var="prov" items="${listaProveedores}">
                        <option value="${prov.ruc}">${prov.nombre} (${prov.ruc})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-close>Cancelar</button>
                <button type="submit" id="crud-submit-btn" class="btn btn-primary">Registrar</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Delete Producto -->
<div id="modal-delete" class="modal hidden">
    <div class="modal-card small">
        <h3>¿Eliminar producto?</h3>
        <p>Esta acción no se puede deshacer.</p>
        <form method="post" action="${pageContext.request.contextPath}/productos/eliminar">
            <input type="hidden" id="delete-id" name="codProducto">
            <div class="modal-footer two">
                <button type="button" class="btn btn-outline" data-close>Cancelar</button>
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

    const modal = qs("#modal-crud-product");
    const form = qs("#form-crud-product");
    const title = qs("#modal-title");
    const submitBtn = qs("#crud-submit-btn");

    const resetModal = () => {
        form.reset();
        qs("#crud-id-producto").value = "";
        title.textContent = "Registrar Nuevo Producto";
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
        const row = qs("#producto-" + id);

        qs("#crud-id-producto").value = row.dataset.id;
        qs("#crud-nombre").value = row.dataset.nombre;
        qs("#crud-categoria").value = row.dataset.categoria;
        qs("#crud-cant").value = row.dataset.cant;
        qs("#crud-costo").value = row.dataset.costo;
        qs("#crud-proveedor").value = row.dataset.proveedor;

        title.textContent = "Modificar Producto ID: " + id;
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
