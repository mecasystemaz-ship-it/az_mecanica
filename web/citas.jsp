<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    // Guardián de seguridad: Verifica si el rol es ADMIN
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
            /* Estilos del Calendario */
            main.container {
                padding: 20px;
            }
            .calendar-head {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:15px;
            }
            .calendar-box {
                background:#333; /* Fondo oscuro ajustado para coherencia */
                border-radius:12px;
                overflow:hidden;
            }
            .calendar {
                width:100%;
                border-collapse:collapse;
                text-align:center;
            }
            .calendar th {
                background:#222;
                color:#fff;
                padding:8px;
            }
            .calendar td {
                height:100px;
                vertical-align:top;
                padding:4px;
                border:1px solid #444; /* Borde ajustado para fondo oscuro */
                position:relative;
                background-color: #2a2a2a; /* Fondo de celdas */
            }
            .calendar .day-num {
                font-weight:bold;
                color:#fff;
                font-size:14px;
            }
            /* Estilos de Eventos */
            .event {
                background:#555; /* Fondo de evento por defecto */
                border-radius:6px;
                color:#fff;
                padding:2px 5px;
                margin:3px 0;
                cursor:pointer;
                text-align:left;
                font-size:12px;
            }
            .event.CONFIRMADA {
                background:#2ecc71;
            }
            .event.PENDIENTE {
                background:#f1c40f;
                color:#000;
            }
            .event.CANCELADA {
                background:#7f8c8d;
                color:#000;
            }
            .calendar td.is-other {
                background-color: #333; /* Fondo de días de otro mes */
            }

            /* Estilos del Panel Lateral (Sidepanel) */
            .sidepanel {
                position:fixed;
                top:0;
                right:-450px;
                width:420px;
                height:100%;
                background:#222;
                color:#fff;
                transition:.3s;
                padding:20px;
                overflow-y:auto;
                box-shadow: -5px 0 15px rgba(0,0,0,0.5); /* Sombra para resaltar */
                z-index: 1000; /* Asegurar que esté por encima de todo */
            }
            .sidepanel.open {
                right:0;
            }
            .sidepanel h3 {
                margin-top:0;
            }
            .hidden {
                display:none;
            }

            /* Overlay para oscurecer el fondo */
            #overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                z-index: 999; /* Justo debajo del sidepanel */
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.3s, visibility 0.3s;
            }
            #overlay.visible {
                opacity: 1;
                visibility: visible;
            }

            /* Estilos de Formulario y Botones */
            .field {
                margin-bottom:12px;
                display:flex;
                flex-direction:column;
            }
            .field label {
                font-weight:bold;
                margin-bottom:3px;
            }
            .field input, .field select, .field textarea {
                padding:8px; /* Aumentar padding un poco */
                border:1px solid #444; /* Borde sutil */
                background-color: #333; /* Fondo oscuro */
                color: #fff;
                border-radius:6px;
            }
            .row {
                display:flex;
                gap:8px;
            }
            .row > .field {
                flex-grow: 1; /* Permitir que los campos crezcan en el row */
            }
            .gap {
                gap:8px;
            }
            .btn {
                border:none;
                border-radius:8px;
                cursor:pointer;
                padding:8px 15px; /* Aumentar padding un poco */
                font-weight:bold;
                text-decoration: none; /* Para enlaces con estilo de botón */
            }
            .btn-primary {
                background:#ffb800;
                color:#000;
            }
            .btn-danger-outline {
                border:1px solid #ff4444;
                color:#ff4444;
                background:transparent;
            }
            .btn-round {
                border-radius:20px;
            }
        </style>
    </head>
    <body>

        <div id="overlay"></div>

        <header class="topbar">
            <div class="container topbar__row">
                <div class="brand">
                    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
                    <span class="brand__label">Citas</span>
                </div>
                <a class="btn btn-outline" href="logout.jsp">Cerrar sesión</a>
            </div>
        </header>

        <nav class="tabs">
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a>Registro de Pagos</a>
            <a href="${pageContext.request.contextPath}/proveedores">Proveedores</a>
            <a href="${pageContext.request.contextPath}/productos">Inventario</a>
            <a href="${pageContext.request.contextPath}/empleados">Empleados</a>
            <a class="active" href="${pageContext.request.contextPath}/CitaServlet">Citas</a>
            <a href="${pageContext.request.contextPath}/servicios">Servicios</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/vehiculos">Vehículos</a>
        </nav>

        <main class="container">
            <div class="calendar-head">
                <div>
                    <button type="button" class="btn chip">Mes</button>
                    <button type="button" class="btn chip">Semana</button>
                    <button type="button" class="btn chip">Día</button>
                    <span class="legend" style="color:#fff;"><i class="dot" style="background:#2ecc71;"></i> Confirmada</span>
                    <span class="legend" style="color:#fff;"><i class="dot" style="background:#f1c40f;"></i> Pendiente</span>
                    <span class="legend" style="color:#fff;"><i class="dot" style="background:#7f8c8d;"></i> Cancelada</span>
                </div>
                <button id="btn-nueva" class="btn btn-primary btn-round">+ Nueva cita</button>
            </div>

            <div class="calendar-box">
                <header style="display:flex; justify-content:space-between; align-items:center; padding:10px; background-color: #333;">
                    <div>
                        <a href="citas.jsp?mes=${requestScope.mesAnterior}&anio=${requestScope.anioAnterior}" style="text-decoration:none; color:#ffb800;">‹</a>
                        <strong style="color:#fff;">${requestScope.mesNombre} ${requestScope.anio}</strong>
                        <a href="citas.jsp?mes=${requestScope.mesSiguiente}&anio=${requestScope.anioSiguiente}" style="text-decoration:none; color:#ffb800;">›</a>
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
                                    <option value="${cli.dni}">${cli.nombres}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="field">
                            <label for="placaVehiculo">Vehiculo</label>
                            <select id="placaVehiculo" name="placaVehiculo" required>
                                <option value="">Seleccione</option>
                                <c:forEach var="vehi" items="${requestScope.vehiculos}">
                                    <option value="${vehi.placa}">${vehi.marca} (${vehi.placa})</option>
                                </c:forEach>
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
                            <button type="button" class="btn" data-close>Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar</button>
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
                            <button type="button" id="btn-confirmar" class="btn btn-primary">Confirmar cita</button>

                            <button type="button" id="btn-cancelar" class="btn btn-danger-outline">Cancelar cita</button>

                            <a id="det-editar" class="btn btn-primary hidden" href="#">Editar</a>
                            <button type="button" class="btn" data-close>Cerrar</button>
                        </div>
                    </form>
                </div>
            </aside>
        </main>

        <script>
            const panel = document.getElementById('sidepanel');
            const overlay = document.getElementById('overlay'); // Obtener el overlay
            const newPanel = document.getElementById('panel-new');
            const detPanel = document.getElementById('panel-detail');
            const btnCancelar = document.getElementById('btn-cancelar');

            const btnConfirmar = document.getElementById('btn-confirmar');
            const formDetalle = document.getElementById('form-detalle');
            const detAction = document.getElementById('det-action');

            btnConfirmar.onclick = () => {
                if (confirm('¿Estás seguro de que quieres CONFIRMAR esta cita?')) {
                    detAction.value = 'confirm'; // Establece la acción a 'confirm'
                    formDetalle.submit();
                }
            };

            btnCancelar.onclick = () => {
                if (confirm('¿Estás seguro de que quieres CANCELAR esta cita?')) {
                    detAction.value = 'cancel'; // Establece la acción a 'cancel'
                    formDetalle.submit();
                }
            };

            // Función para abrir el panel y el overlay
            function openPanel() {
                panel.classList.add('open');
                overlay.classList.add('visible');
            }

            // Función para cerrar el panel y el overlay
            function closePanel() {
                panel.classList.remove('open');
                overlay.classList.remove('visible');
                newPanel.classList.add('hidden');
                detPanel.classList.add('hidden');
            }

            // Abrir panel al hacer clic en "Nueva cita"
            document.getElementById('btn-nueva').onclick = () => {
                detPanel.classList.add('hidden');
                newPanel.classList.remove('hidden');
                openPanel();
            };

            // Cerrar panel al hacer clic en "Cancelar" o "Cerrar" dentro del panel
            document.querySelectorAll('[data-close]').forEach(b => {
                b.onclick = closePanel;
            });

            // Cerrar panel al hacer clic en el overlay (fondo oscuro)
            overlay.onclick = closePanel;

            // Manejador de eventos al hacer clic en una cita (evento)
            document.addEventListener('click', e => {
                const ev = e.target.closest('.event');
                if (!ev)
                    return;

                // Rellenar campos del panel de detalle
                document.getElementById('det-id').value = ev.dataset.id;
                document.getElementById('det-cliente').value = ev.dataset.cliente;
                document.getElementById('det-fecha').value = ev.dataset.fecha;
                document.getElementById('det-hora').value = ev.dataset.hora;
                document.getElementById('det-servicio').value = ev.dataset.servicio;
                document.getElementById('det-estado').value = ev.dataset.estado;
                document.getElementById('det-editar').href = 'cita-form.jsp?id=' + ev.dataset.id;

                // Mostrar/Ocultar el botón de cancelar según el estado
                if (ev.dataset.estado === 'PENDIENTE') {
                    btnConfirmar.classList.remove('hidden');
                    btnCancelar.classList.remove('hidden');
                } else if (ev.dataset.estado === 'CONFIRMADA') {
                    btnConfirmar.classList.add('hidden'); // No se puede confirmar si ya está confirmada
                    btnCancelar.classList.remove('hidden');
                } else if (ev.dataset.estado === 'CANCELADA') {
                    btnConfirmar.classList.add('hidden');
                    btnCancelar.classList.add('hidden'); // No se puede cancelar si ya está cancelada
                }

                newPanel.classList.add('hidden');
                detPanel.classList.remove('hidden');
                openPanel();
            });
        </script>
    </body>
</html>