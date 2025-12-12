<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
    // Verificación de Sesión (Seguridad)
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
    <title>AZ Mecánica | Gestión de Pagos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

    <style>
        /* Estilos específicos para esta vista */
        .hidden { display: none !important; }
        
        .input-readonly { 
            background-color: #f2f2f2; 
            color: #555; 
            pointer-events: none; 
            border: 1px solid #ccc; 
            font-weight: 500; 
        }
        
        .section-table { 
            margin-bottom: 40px; 
            background: #2a2a2a; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
        }
        
        .section-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 15px; 
            border-bottom: 2px solid #eee; 
            padding-bottom: 10px; 
        }
        
        .section-header h2 { margin: 0; color: white; font-size: 1.2rem; }
        
        /* Botones */
        .btn-cita { background-color: #3498db; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-weight: bold;}
        .btn-cita:hover { background-color: #2980b9; }
        
        .btn-proforma { background-color: #e67e22; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-weight: bold;}
        .btn-proforma:hover { background-color: #d35400; }

        /* Modal */
        .modal.az-hide { display: none; }
        .modal { position: fixed; inset: 0; background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; z-index: 1000; }
        .modal-card { background: white; padding: 25px; border-radius: 8px; width: 600px; max-width: 95%; }
        
        .grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .field { margin-bottom: 12px; display: flex; flex-direction: column; }
        .field label { font-weight: bold; font-size: 0.9em; margin-bottom: 4px; color: #444; }
        input, select, textarea { padding: 9px; border: 1px solid #ddd; border-radius: 4px; width: 100%; box-sizing: border-box; }
        
        .modal-footer { margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px; }
    </style>
</head>
<body>

    <header class="topbar">
        <div class="container topbar__row">
            <div class="brand">
                <img src="${pageContext.request.contextPath}/imgs/logo.png" onerror="this.style.display='none'" class="logo" alt="AZ">
                <span class="brand__label">Tesorería</span>
            </div>
            <jsp:include page="saludoadmin.jsp" />
            <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
        </div>
    </header>
            
    <nav class="tabs">
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
        <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
        <a class="active" href="${pageContext.request.contextPath}/pagos">Pagos</a> <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
        <a href="${pageContext.request.contextPath}/productos">Inventario</a>
        <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
        <a href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
        <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
        <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
        <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
    </nav>

    <main class="container content" style="margin-top: 2rem;">
        
        <c:if test="${not empty sessionScope.mensajeExito}">
            <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 15px; text-align: center; font-weight: bold; border: 1px solid #c3e6cb;">
                <i class="fa-solid fa-check-circle"></i> ${sessionScope.mensajeExito}
            </div>
            <c:remove var="mensajeExito" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.mensajeError}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 15px; text-align: center; font-weight: bold; border: 1px solid #f5c6cb;">
                <i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.mensajeError}
            </div>
            <c:remove var="mensajeError" scope="session"/>
        </c:if>

        <section class="section-table">
            <div class="section-header">
                <h2><i class="fa-solid fa-calendar-check" style="color: #3498db;"></i> Historial de Pagos de Citas</h2>
                <button type="button" class="btn btn-cita" onclick="abrirModalPago('CITA')">
                    <i class="fa-solid fa-plus"></i> Registrar Pago Cita
                </button>
            </div>

            <div class="datatable-wrapper">
                <table class="datatable" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: #333; color: white;">
                            <th style="padding:10px;">ID Cita</th>
                            <th style="padding:10px;">Cliente</th>
                            <th style="padding:10px;">Vehículo</th>
                            <th style="padding:10px;">Fecha Pago</th>
                            <th style="padding:10px;">Hora Cita</th>
                            <th style="padding:10px;">Servicio</th>
                            <th style="padding:10px; text-align:right;">Monto Pagado</th>
                            <th style="padding:10px;">Método</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${pagosCitas}">
                            <tr style="border-bottom: 1px solid #ddd; color: #eee;">
                                <td style="padding:10px;">#${p.idReferencia}</td>
                                <td style="padding:10px;">${p.nombreCliente}</td>
                                <td style="padding:10px;">${p.placaVehiculo}</td>
                                <td style="padding:10px;">${p.fecha}</td>
                                <td style="padding:10px;">${p.horaCita}</td>
                                <td style="padding:10px;">${p.nombreServicio}</td>
                                <td style="padding:10px; text-align:right; color: #2ecc71; font-weight:bold;">S/ <fmt:formatNumber value="${p.monto}" minFractionDigits="2"/></td>
                                <td style="padding:10px;">${p.metodoPago}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pagosCitas}">
                            <tr><td colspan="8" style="text-align:center; padding:15px; color:#bbb;">No hay historial de pagos de citas.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="section-table">
            <div class="section-header">
                <h2><i class="fa-solid fa-file-invoice-dollar" style="color: #e67e22;"></i> Historial de Pagos de Proformas</h2>
                <button type="button" class="btn btn-proforma" onclick="abrirModalPago('PROFORMA')">
                    <i class="fa-solid fa-plus"></i> Registrar Pago Proforma
                </button>
            </div>

            <div class="datatable-wrapper">
                <table class="datatable" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: #333; color: white;">
                            <th style="padding:10px;">ID Prof.</th>
                            <th style="padding:10px;">Fecha Pago</th>
                            <th style="padding:10px;">Cliente</th>
                            <th style="padding:10px;">Monto Est.</th>
                            <th style="padding:10px; text-align:right;">Monto Pagado</th>
                            <th style="padding:10px;">Estado</th>
                            <th style="padding:10px;">Método</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="pf" items="${pagosProformas}">
                            <tr style="border-bottom: 1px solid #ddd; color: #eee;">
                                <td style="padding:10px;">#${pf.idReferencia}</td>
                                <td style="padding:10px;">${pf.fecha}</td>
                                <td style="padding:10px;">${pf.nombreCliente}</td> 
                                <td style="padding:10px;">S/ <fmt:formatNumber value="${pf.montoEstimado}" minFractionDigits="2"/></td>
                                <td style="padding:10px; text-align:right; color: #2ecc71; font-weight:bold;">S/ <fmt:formatNumber value="${pf.monto}" minFractionDigits="2"/></td>
                                <td style="padding:10px;">
                                    <span style="background: #444; color:white; padding: 2px 6px; border-radius: 4px; font-size: 0.8em;">${pf.estadoProforma}</span>
                                </td>
                                <td style="padding:10px;">${pf.metodoPago}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pagosProformas}">
                            <tr><td colspan="7" style="text-align:center; padding:15px; color:#bbb;">No hay historial de pagos de proformas.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <div id="modalPago" class="modal az-hide">
        <div class="modal-card">
            <header style="border-bottom: 2px solid #ddd; margin-bottom: 15px;">
                <h3 id="tituloModal" style="margin: 0 0 10px 0;">Registrar Pago</h3>
            </header>

            <form id="formPago" action="${pageContext.request.contextPath}/pagos/guardar" method="post">
                <input type="hidden" id="origen" name="origen">
                
                <div class="field">
                    <label id="lbl-select">Seleccione el Documento Pendiente</label>
                    
                    <select id="select-citas" class="hidden" onchange="cargarDatos('cita')">
                        <option value="">-- Elija Cita Pendiente --</option>
                        <c:forEach var="c" items="${listaCitasPendientes}">
                            <option value="${c.idCita}" 
                                    data-cliente="${c.nombreCliente}"
                                    data-monto="${c.precio}" 
                                    data-placa="${c.placaVehiculo}"
                                    data-servicio="${c.nombreServicio}">
                                #${c.idCita} - ${c.nombreCliente} (S/ ${c.precio})
                            </option>
                        </c:forEach>
                        <c:if test="${empty listaCitasPendientes}">
                            <option disabled>No hay citas pendientes de pago</option>
                        </c:if>
                    </select>

                    <select id="select-proformas" class="hidden" onchange="cargarDatos('proforma')">
                        <option value="">-- Elija Proforma Pendiente --</option>
                        <c:forEach var="pf" items="${listaProformasPendientes}">
                             <option value="${pf.idProforma}" 
                                    data-cliente="${pf.nombreCliente}"
                                    data-monto="${pf.montoEstimado}"
                                    data-placa="N/A"> 
                                #${pf.idProforma} - ${pf.nombreCliente} (S/ ${pf.montoEstimado})
                            </option>
                        </c:forEach>
                    </select>
                    
                    <input type="hidden" id="id_referencia_real" name="id_referencia">
                </div>

                <div class="grid2">
                    <div class="field">
                        <label>Cliente</label>
                        <input type="text" id="cliente" readonly class="input-readonly">
                    </div>
                    <div class="field">
                        <label>Placa / Vehículo</label>
                        <input type="text" id="placa" readonly class="input-readonly">
                    </div>
                </div>

                <div class="grid2">
                    <div class="field">
                        <label>Total Deuda</label>
                        <input type="text" id="deuda_total" readonly class="input-readonly" style="color: #d93025; font-weight: bold;">
                    </div>
                    <div class="field">
                        <label>Monto a Pagar (*)</label>
                        <input type="number" step="0.01" id="monto" name="monto" required style="border-color: #2ecc71; font-weight: bold;">
                    </div>
                </div>

                <div class="grid2">
                    <div class="field">
                        <label>Método</label>
                        <select name="metodoPago" required>
                            <option value="Efectivo">Efectivo</option>
                            <option value="Yape">Yape</option>
                            <option value="Plin">Plin</option>
                            <option value="Tarjeta">Tarjeta</option>
                            <option value="Transferencia">Transferencia</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Fecha</label>
                        <input type="date" id="fecha" name="fecha" required>
                    </div>
                </div>

                <div class="field">
                    <label>Notas</label>
                    <textarea name="notas" rows="2"></textarea>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="cerrarModal()">Cancelar</button>
                    <button type="submit" class="btn btn-cita">Guardar Pago</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const modal = document.getElementById('modalPago');
        const form = document.getElementById('formPago');
        
        function abrirModalPago(tipo) {
            form.reset();
            // Poner fecha de hoy
            document.getElementById('fecha').value = new Date().toISOString().split('T')[0];
            limpiarCampos();

            const selectCitas = document.getElementById('select-citas');
            const selectProformas = document.getElementById('select-proformas');
            const inputOrigen = document.getElementById('origen');
            const titulo = document.getElementById('tituloModal');

            inputOrigen.value = tipo;
            selectCitas.classList.add('hidden');
            selectProformas.classList.add('hidden');
            selectCitas.required = false;
            selectProformas.required = false;

            if (tipo === 'CITA') {
                titulo.textContent = "Registrar Pago de Cita";
                titulo.style.color = "#3498db"; 
                selectCitas.classList.remove('hidden');
                selectCitas.required = true;
            } else {
                titulo.textContent = "Registrar Pago de Proforma";
                titulo.style.color = "#e67e22"; 
                selectProformas.classList.remove('hidden');
                selectProformas.required = true;
            }
            modal.classList.remove('az-hide');
        }

        function cerrarModal() {
            modal.classList.add('az-hide');
        }

        window.cargarDatos = function(tipo) {
            let selectId = (tipo === 'proforma') ? 'select-proformas' : 'select-citas';
            const select = document.getElementById(selectId);
            const opcion = select.options[select.selectedIndex];
            
            if (!opcion.value) {
                limpiarCampos();
                return;
            }
            
            // Llenar inputs visuales
            const cliente = opcion.dataset.cliente || '';
            const placa = opcion.dataset.placa || '';
            const monto = opcion.dataset.monto;

            document.getElementById('cliente').value = cliente;
            document.getElementById('placa').value = placa;
            document.getElementById('deuda_total').value = 'S/ ' + (monto || '0.00');
            document.getElementById('monto').value = monto;
            document.getElementById('id_referencia_real').value = opcion.value;
        };

        function limpiarCampos() {
            document.getElementById('cliente').value = "";
            document.getElementById('placa').value = "";
            document.getElementById('deuda_total').value = "";
            document.getElementById('monto').value = "";
            document.getElementById('id_referencia_real').value = "";
        }

        form.addEventListener('submit', (e) => {
             const origen = document.getElementById('origen').value;
             if (!confirm(`¿Confirmar el pago para la ${origen}?`)) {
                 e.preventDefault();
             }
        });
        
        window.addEventListener('click', (e) => {
            if (e.target === modal) cerrarModal();
        });
    </script>
</body>
</html>