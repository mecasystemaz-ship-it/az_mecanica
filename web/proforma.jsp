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

    // Previene caché
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

        <link rel="stylesheet" 
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" 
              integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" 
              crossorigin="anonymous" referrerpolicy="no-referrer" />

        <style>
            /* --- Estilos existentes --- */
            .modal.hidden { display: none; }
            .modal { position: fixed; inset: 0; backdrop-filter: blur(4px); background: rgba(0,0,0,0.45); display: flex; align-items: center; justify-content: center; animation: fadeIn .25s ease-out; z-index: 9999; }
            @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
            .modal-card { background: #ffffff; width: 600px; padding: 25px; border-radius: 14px; box-shadow: 0 8px 28px rgba(0,0,0,0.25); animation: pop .25s ease-out; transform-origin: center; }
            .modal-card.small { width: 380px; }
            @keyframes pop { from { transform: scale(.85); opacity: 0; } to { transform: scale(1); opacity: 1; } }
            .modal-card h3 { margin-bottom: 15px; font-size: 20px; color: #222; border-bottom: 2px solid #e8e8e8; padding-bottom: 8px; }
            .modal-card input, .modal-card select, .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid #cfcfcf; border-radius: 6px; font-size: 15px; outline: none; transition: .2s; }
            .modal-card input:focus, .modal-card select:focus, .modal-card textarea:focus { border-color: #0066ff; box-shadow: 0 0 0 2px rgba(0,102,255,0.2); }
            .modal-footer { margin-top: 20px; display: flex; justify-content: flex-end; gap: 12px; }
            .modal-footer.two { justify-content: space-between; }
            .btn { padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; font-size: 14px; transition: .2s; }
            .btn:hover { opacity: .85; }
            .btn-primary { background: #0066ff; color: #fff; }
            .btn-danger { background: #d93025; color: white; }
            textarea { resize: vertical; min-height: 70px; }
            .alert { padding: 10px; margin-bottom: 20px; border-radius: 4px; }
            .alert-success { background: #d4edda; color: #155724; }
            .alert-danger { background: #f8d7da; color: #721c24; }
            .grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }

            /* 2. AGREGADO: Estilo para el botón PDF */
            .btn-pdf {
                background: #e74c3c; /* Rojo PDF */
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            .btn-pdf:hover {
                background: #c0392b;
                color: white;
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
                <jsp:include page="saludoadmin.jsp" />
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a class="active" href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
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
                            <th>Nombre Cliente</th>
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
                                <td>${p.nombreCliente}</td>
                                <td>S/ ${p.montoEstimado}</td>
                                <td>${p.estado}</td>

                                <td class="center">
                                    <button class="icon-btn" title="Modificar" data-edit="${fn:escapeXml(p.idProforma)}">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>

                                    <button type="button"
                                            title="Descargar en PDF"
            class="icon-btn" 
            style="background: #e74c3c; color: white;"
            onclick="descargarPDF('${p.idProforma}', '${p.nombreCliente}', '${p.idCliente}', '${p.fecha}', '${p.montoEstimado}')">
        <i class="fa-solid fa-file-pdf"></i>
    </button>

                                    <button class="icon-btn danger" title="Eliminar" data-delete="${fn:escapeXml(p.idProforma)}">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
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
                    
                    
         <div id="pdf-template" style="display: none;">
    <div style="padding: 30px; font-family: Arial, sans-serif; color: #333; background: white;">
        
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ffcc00; padding-bottom: 10px; margin-bottom: 20px;">
            <div>
                <img src="${pageContext.request.contextPath}/imgs/logo.png" style="height: 60px;" alt="Logo">
                <h2 style="margin: 5px 0 0 0; color: #333;">AZ MECÁNICA</h2>
                <p style="margin: 0; font-size: 12px; color: #777;">RUC: 20123456789 <br> Dirección: Av. Principal 123</p>
            </div>
            <div style="text-align: right;">
                <h1 style="color: #555; margin: 0;">PROFORMA</h1>
                <h3 id="pdf-id" style="margin: 5px 0; color: #ffcc00;">PF-0000</h3>
                <p id="pdf-fecha" style="margin: 0;">Fecha: 01/01/2025</p>
            </div>
        </div>

        <div style="background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <h4 style="margin-top: 0; border-bottom: 1px solid #ddd; padding-bottom: 5px;">Información del Cliente</h4>
            <p><strong>Cliente:</strong> <span id="pdf-cliente">Nombre del Cliente</span></p>
            <p><strong>ID/DNI:</strong> <span id="pdf-dni">00000000</span></p>
        </div>

        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
            <thead>
                <tr style="background: #333; color: white;">
                    <th style="padding: 10px; text-align: left;">Descripción</th>
                    <th style="padding: 10px; text-align: right;">Monto Estimado</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #ddd;">Servicio General / Repuestos (Estimación)</td>
                    <td id="pdf-monto" style="padding: 10px; text-align: right; border-bottom: 1px solid #ddd;">S/ 0.00</td>
                </tr>
            </tbody>
        </table>

        <div style="text-align: right;">
            <h2 style="margin: 0;">Total: <span id="pdf-total" style="color: #d93025;">S/ 0.00</span></h2>
            <p style="font-size: 12px; color: #777;">* Esta proforma tiene una validez de 15 días.</p>
        </div>
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
                inputIdProforma.readOnly = false;
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
                if (!btn) return;

                const id = btn.dataset.edit;
                const row = qs("#proforma-" + id);

                inputIdProforma.value = row.dataset.id;
                inputIdProforma.readOnly = true;

                qs("#crud-id-cliente").value = row.dataset.clienteId;
                qs("#crud-monto-estimado").value = row.dataset.monto;
                qs("#crud-estado").value = row.dataset.estado;

                title.textContent = "Modificar Proforma ID: " + id;
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
            
            
            function descargarPDF(id, nombre, dni, fecha, monto) {
    // 1. Llenar la plantilla con los datos recibidos
    document.getElementById('pdf-id').textContent = id;
    document.getElementById('pdf-cliente').textContent = nombre;
    document.getElementById('pdf-dni').textContent = dni;
    document.getElementById('pdf-fecha').textContent = fecha;
    document.getElementById('pdf-monto').textContent = 'S/ ' + parseFloat(monto).toFixed(2);
    document.getElementById('pdf-total').textContent = 'S/ ' + parseFloat(monto).toFixed(2);

    // 2. Seleccionar el elemento
    const elementoParaImprimir = document.getElementById('pdf-template');

    // 3. Configuración del PDF
    const opciones = {
        margin:       10, // Margen en mm
        filename:     'Proforma_' + id + '.pdf',
        image:        { type: 'jpeg', quality: 0.98 },
        html2canvas:  { scale: 2 }, // Mayor escala = mejor calidad
        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    // 4. Hacer visible temporalmente para la foto (truco)
    elementoParaImprimir.style.display = 'block';

    // 5. Generar y Descargar
    html2pdf()
        .set(opciones)
        .from(elementoParaImprimir)
        .save()
        .then(() => {
            // Ocultar de nuevo al terminar
            elementoParaImprimir.style.display = 'none';
        });
}
        </script>

    </body>
</html>