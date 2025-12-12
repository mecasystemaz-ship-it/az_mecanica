<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    // Guardián de seguridad
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
        <title>AZ Mecánica | Citas</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

        <style>
            /* =========================
               ESTILOS ESPECÍFICOS DE CITAS
               ========================= */
            
            main.container { padding: 20px; }

            /* Cabecera del calendario */
            .calendar-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; }
            
            /* Grupo izquierdo de la cabecera (Navegador + Leyenda) */
            .head-controls { display: flex; align-items: center; gap: 20px; }

            /* Estilo del input date oscuro */
            .date-navigator {
                background: #333;
                color: #fff;
                border: 1px solid #555;
                padding: 6px 10px;
                border-radius: 20px; /* Redondeado como los chips */
                font-family: inherit;
                outline: none;
                cursor: pointer;
            }
            /* Icono del calendario en blanco */
            .date-navigator::-webkit-calendar-picker-indicator {
                filter: invert(1);
                cursor: pointer;
            }

            /* Caja del calendario */
            .calendar-box { background:#333; border-radius:12px; overflow:hidden; }
            .calendar { width:100%; border-collapse:collapse; text-align:center; }
            .calendar th { background:#222; color:#fff; padding:8px; }
            .calendar td { height:100px; vertical-align:top; padding:4px; border:1px solid #444; position:relative; background-color: #2a2a2a; }
            .calendar .day-num { font-weight:bold; color:#fff; font-size:14px; }
            .calendar td.is-other { background-color: #333; }

            /* Eventos */
            .event { background:#555; border-radius:6px; color:#fff; padding:2px 5px; margin:3px 0; cursor:pointer; text-align:left; font-size:12px; }
            .event.CONFIRMADA { background:#2ecc71; }
            .event.PENDIENTE { background:#f1c40f; color:#000; }
            .event.CANCELADA {     background: #AB0B23; color: white; }

            /* Panel Lateral */
            .sidepanel { 
                position:fixed; top:0; right:-450px; 
                width:420px; height:100%; background:#222; color:#fff; 
                transition:.3s; padding:20px; overflow-y:auto; 
                box-shadow: -5px 0 15px rgba(0,0,0,0.5); z-index: 1000; 
            }
            .sidepanel.open { right:0; }
            .sidepanel h3 { margin-top:0; }
            .hidden { display:none; }

            /* Overlay */
            #overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6); z-index: 999; opacity: 0; visibility: hidden; transition: opacity 0.3s, visibility 0.3s; }
            #overlay.visible { opacity: 1; visibility: visible; }

            /* Estilos Formulario */
            .field { margin-bottom:12px; display:flex; flex-direction:column; }
            .field label { font-weight:bold; margin-bottom:3px; }
            .field input, .field select, .field textarea { padding:8px; border:1px solid #444; background-color: #333; color: #fff; border-radius:6px; }
            .field select option { background-color: #333 !important; color: #fff !important; }
            .row { display:flex; gap:8px; }
            .row > .field { flex-grow: 1; }
            .btn { border:none; border-radius:8px; cursor:pointer; padding:8px 15px; font-weight:bold; text-decoration: none; }
            .btn-primary { background:#ffb800; color:#000; }
            .btn-danger-outline { border:1px solid #ff4444; color:#ff4444; background:transparent; }
            .btn-round { border-radius:20px; }
            
            
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

        <div id="overlay"></div>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo.png" alt="AZ" class="logo">
                    <span class="brand__label">Citas</span>
                </div>
                <jsp:include page="saludoadmin.jsp" />
                <a class="btn btn-outline" href="LogoutServlet">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/proformas">Proformas</a>
            <a href="${pageContext.request.contextPath}/pagos.html">Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a class="active" href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
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
            
            <div class="calendar-head">
                <div class="head-controls">
                    <div style="display:flex; align-items:center; gap:5px;">
                        <label for="gotoDate" style="font-size:0.85rem; color:#aaa;">Ir a:</label>
                        <input type="date" id="gotoDate" class="date-navigator" title="Seleccionar fecha específica">
                    </div>
                    
                    <div style="display:flex; gap:10px; margin-left: 10px;">
                        <span class="legend" style="color:#fff; font-size:0.9rem;"><i class="dot" style="background:#2ecc71;"></i> Confirmada</span>
                        <span class="legend" style="color:#fff; font-size:0.9rem;"><i class="dot" style="background:#f1c40f;"></i> Pendiente</span>
                        <span class="legend" style="color:#fff; font-size:0.9rem;"><i class="dot" style="background:#AB0B23;"></i> Cancelada</span>
                    </div>
                </div>
                
                <button id="btn-nueva" class="btn btn-primary btn-round">+ Nueva cita</button>
            </div>

            <div class="calendar-box">
                <header style="display:flex; justify-content:space-between; align-items:center; padding:10px; background-color: #333;">
                    <div>
                        <a href="CitaServlet?mes=${requestScope.mesAnterior}&anio=${requestScope.anioAnterior}" style="text-decoration:none; color:#ffb800; font-size: 1.2em; padding: 0 10px;">‹</a>
                        <strong style="color:#fff; font-size: 1.1em; text-transform: uppercase;">${requestScope.mesNombre} ${requestScope.anio}</strong>
                        <a href="CitaServlet?mes=${requestScope.mesSiguiente}&anio=${requestScope.anioSiguiente}" style="text-decoration:none; color:#ffb800; font-size: 1.2em; padding: 0 10px;">›</a>
                    </div>
                </header>

                <table class="calendar">
                    <thead>
                        <tr><th>Lun</th><th>Mar</th><th>Mié</th><th>Jue</th><th>Vie</th><th>Sáb</th><th>Dom</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sem" items="${requestScope.semanas}">
                            <tr>
                                <c:forEach var="dia" items="${sem.dias}">
                                    <td class="${dia.otroMes?'is-other':''}">
                                        <div class="day-num">${dia.numero}</div>
                                        <c:forEach var="ev" items="${dia.eventos}">
                                            <div class="event ${ev.estado}"
                                                 data-id="${ev.id}"
                                                 data-cliente="${ev.nombreCliente}"
                                                 data-fecha="${dia.fechaISO}"
                                                 data-hora="${ev.horaTxt}"
                                                 data-servicio="${ev.nombreServicio}"
                                                 data-estado="${ev.estado}">
                                                ${ev.horaTxt} - ${ev.nombreCliente}
                                            </div>
                                        </c:forEach>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <aside id="sidepanel" class="sidepanel">
                <div id="panel-new" class="hidden">
                    <h3>Nueva cita</h3>
                    <form method="post" action="CitaServlet">
                        <input type="hidden" name="action" value="create">
                        <div class="field">
                            <label for="dniCliente">Cliente</label>
                            <select id="dniCliente" name="dniCliente" required>
                                <option value="">Seleccione</option>
                                <c:forEach var="cli" items="${requestScope.clientes}">
                                    <option value="${cli.dni}">${cli.nombres} ${cli.apellidos}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="field">
                            <label for="placaVehiculo">Vehículo</label>
                            <select id="placaVehiculo" name="placaVehiculo" required>
                                <option value="">Seleccione un cliente primero</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="field"><label for="fecha">Fecha</label><input type="date" id="fecha" name="fecha" required></div>
                            <div class="field"><label for="hora">Hora</label><input type="time" id="hora" name="hora" required></div>
                        </div>
                        <div class="field">
                            <label for="idServicio">Servicio</label>
                            <select id="idServicio" name="idServicio" required>
                                <option value="">Seleccione</option>
                                <c:forEach var="servi" items="${requestScope.servicios}">
                                    <option value="${servi.idServicio}">${servi.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="field">
                            <label for="dniEmpleado">Empleado</label>
                            <select id="dniEmpleado" name="dniEmpleado">
                                <option value="">Sin asignar</option>
                                <c:forEach var="emp" items="${requestScope.empleados}">
                                    <option value="${emp.dni}">${emp.nombres}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="field">
                            <label for="notas">Notas</label>
                            <textarea id="notas" name="notas" rows="3"></textarea>
                        </div>
                        <div class="row" style="justify-content:end;">
                            <button type="submit" class="btn btn-primary">Guardar</button>
                            <button type="button" class="btn" data-close>Cerrar</button>
                        </div>
                    </form>
                </div>

                <div id="panel-detail" class="hidden">
                    <h3>Detalle de la cita</h3>
                    <form id="form-detalle" method="post" action="CitaServlet">
                        <input type="hidden" name="action" id="det-action" value="updateState"> 
                        <input type="hidden" id="det-id" name="id">
                        <div class="field"><label>Cliente</label><input id="det-cliente" readonly></div>
                        <div class="row">
                            <div class="field"><label>Fecha</label><input id="det-fecha" readonly></div>
                            <div class="field"><label>Hora</label><input id="det-hora" readonly></div>
                        </div>
                        <div class="field"><label>Servicio</label><input id="det-servicio" readonly></div>
                        <div class="field"><label>Estado</label><input id="det-estado" readonly></div>
                        <div class="row" style="justify-content:flex-end; gap: 8px; margin-top: 20px;">
                            <button type="button" id="btn-confirmar" class="btn btn-primary">Confirmar</button>
                            <button type="button" id="btn-cancelar" class="btn btn-danger-outline">Cancelar</button>
                            <a id="det-editar" class="btn btn-primary hidden" href="#">Editar</a>
                            <button type="button" class="btn" data-close>Cerrar</button>
                        </div>
                    </form>
                </div>
            </aside>
        </main>

        <script>
            const CONTEXT_PATH = '${pageContext.request.contextPath}';
            const VEHICULO_AJAX_URL = CONTEXT_PATH + '/VehiculoAjax';
            const CITA_SERVLET_URL = CONTEXT_PATH + '/CitaServlet';

            // --- 1. LÓGICA DEL NAVEGADOR DE FECHAS (NUEVO) ---
            const dateInput = document.getElementById('gotoDate');
            if(dateInput) {
                dateInput.addEventListener('change', function() {
                    if(this.value) {
                        const parts = this.value.split('-'); // YYYY-MM-DD
                        const anio = parts[0];
                        const mes = parseInt(parts[1]); // Quita el 0 inicial
                        // Redirigir al Servlet con el mes y año seleccionados
                        window.location.href = 'CitaServlet?action=list&mes=' + mes + '&anio=' + anio;
                    }
                });
            }

            // --- 2. FUNCIONES PANEL ---
            function getElements() {
                return {
                    panel: document.getElementById('sidepanel'),
                    overlay: document.getElementById('overlay'),
                    newPanel: document.getElementById('panel-new'),
                    detPanel: document.getElementById('panel-detail'),
                    btnCancelar: document.getElementById('btn-cancelar'),
                    btnConfirmar: document.getElementById('btn-confirmar'),
                    formDetalle: document.getElementById('form-detalle'),
                    detAction: document.getElementById('det-action'),
                    dniClienteSelect: document.getElementById("dniCliente"),
                    vehiculoSelect: document.getElementById("placaVehiculo")
                };
            }

            function openPanel(elements) {
                if (elements.panel && elements.overlay) {
                    elements.panel.classList.add('open');
                    elements.overlay.classList.add('visible');
                }
            }

            function closePanel(elements) {
                if (elements.panel) {
                    elements.panel.classList.remove('open');
                    elements.overlay.classList.remove('visible');
                    elements.newPanel.classList.add('hidden');
                    elements.detPanel.classList.add('hidden');
                }
            }

            function fillDetailPanel(ev, elements) {
                document.getElementById('det-id').value = ev.dataset.id;
                document.getElementById('det-cliente').value = ev.dataset.cliente;
                document.getElementById('det-fecha').value = ev.dataset.fecha;
                document.getElementById('det-hora').value = ev.dataset.hora;
                document.getElementById('det-servicio').value = ev.dataset.servicio;
                document.getElementById('det-estado').value = ev.dataset.estado;
                document.getElementById('det-editar').href = 'cita-form.jsp?id=' + ev.dataset.id;

                const estado = ev.dataset.estado;
                elements.btnConfirmar.classList.add('hidden');
                elements.btnCancelar.classList.add('hidden');

                if (estado === 'PENDIENTE') {
                    elements.btnConfirmar.classList.remove('hidden');
                    elements.btnCancelar.classList.remove('hidden');
                } else if (estado === 'CONFIRMADA') {
                    elements.btnCancelar.classList.remove('hidden');
                }

                elements.newPanel.classList.add('hidden');
                elements.detPanel.classList.remove('hidden');
                openPanel(elements);
            }

            function initPanelEvents(elements) {
                const btnNueva = document.getElementById('btn-nueva');
                if (btnNueva) {
                    btnNueva.onclick = () => {
                        elements.detPanel.classList.add('hidden');
                        elements.newPanel.classList.remove('hidden');
                        openPanel(elements);
                    };
                }

                document.querySelectorAll('[data-close]').forEach(b => b.onclick = () => closePanel(elements));
                elements.overlay.onclick = () => closePanel(elements);

                if (elements.btnConfirmar) {
                    elements.btnConfirmar.onclick = () => {
                        if (confirm('¿Seguro de confirmar la cita?')) {
                            elements.detAction.value = 'confirm';
                            elements.formDetalle.action = CITA_SERVLET_URL;
                            elements.formDetalle.submit();
                        }
                    };
                }
                if (elements.btnCancelar) {
                    elements.btnCancelar.onclick = () => {
                        if (confirm('¿Seguro de cancelar la cita?')) {
                            elements.detAction.value = 'cancel';
                            elements.formDetalle.action = CITA_SERVLET_URL;
                            elements.formDetalle.submit();
                        }
                    };
                }

                document.addEventListener('click', e => {
                    const ev = e.target.closest('.event');
                    if (ev) fillDetailPanel(ev, elements);
                });
            }

            // --- 3. AJAX PARA VEHÍCULOS ---
            function cargarVehiculos(dni, elements) {
                const vehiculoSelect = elements.vehiculoSelect;
                vehiculoSelect.innerHTML = '<option value="" disabled selected>Cargando...</option>';
                vehiculoSelect.disabled = true;

                const url = VEHICULO_AJAX_URL + '?dni=' + dni + '&_t=' + new Date().getTime();

                fetch(url)
                    .then(res => {
                        if (!res.ok) throw new Error(`Error HTTP: ${res.status}`);
                        return res.json();
                    })
                    .then(data => {
                        vehiculoSelect.innerHTML = '';
                        vehiculoSelect.disabled = false;

                        let defaultOption = document.createElement('option');
                        defaultOption.value = '';
                        defaultOption.textContent = 'Seleccione un Vehículo';
                        defaultOption.disabled = true;
                        defaultOption.selected = true;
                        vehiculoSelect.appendChild(defaultOption);

                        if (data && data.length > 0) {
                            data.forEach(v => {
                                const placa = v['placa'] ? v['placa'] : 'S/P';
                                const marca = v['marca'] ? v['marca'] : '';
                                let texto = placa + (marca ? " - " + marca : "");
                                
                                const option = document.createElement('option');
                                option.value = placa;
                                option.textContent = texto;
                                vehiculoSelect.appendChild(option);
                            });
                        } else {
                            let noVehiclesOption = document.createElement('option');
                            noVehiclesOption.value = '';
                            noVehiclesOption.textContent = 'Este cliente no tiene vehículos';
                            vehiculoSelect.appendChild(noVehiclesOption);
                        }
                    })
                    .catch(error => {
                        console.error('Error AJAX:', error);
                        vehiculoSelect.innerHTML = '<option>Error al cargar</option>';
                        vehiculoSelect.disabled = true;
                    });
            }

            document.addEventListener("DOMContentLoaded", function () {
                const elements = getElements();
                initPanelEvents(elements);

                if (elements.dniClienteSelect && elements.vehiculoSelect) {
                    elements.dniClienteSelect.addEventListener("change", function () {
                        const dni = this.value;
                        if (dni) {
                            cargarVehiculos(dni, elements);
                        } else {
                            elements.vehiculoSelect.innerHTML = '<option value="">Seleccione un cliente</option>';
                            elements.vehiculoSelect.disabled = true;
                        }
                    });
                }
            });
        </script>

    </body>
</html>