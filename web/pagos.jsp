<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>AZ Mecánica | Pagos</title>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
          integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body class="bg">

<!-- ========== TOPBAR / NAV (ajusta rutas según tu proyecto) ========== -->
<header class="topbar">
    <div class="container topbar__row">
        <div class="brand">
            <img src="img/logo-az.png" class="logo" alt="AZ Mecánica">
            <span class="brand__label">Panel de administración</span>
        </div>

        <a href="LogoutServlet" class="btn btn-outline">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </div>

    <nav class="nav nav--admin">
        <div class="container">
            <div class="tabs">
                <span class="nav__label">Módulos</span>
                <a href="clientes.jsp">Clientes</a>
                <a href="vehiculos.jsp">Vehículos</a>
                <a href="servicios.jsp">Servicios</a>
                <a href="proformas.jsp">Proformas</a>
                <a href="pagos.jsp" class="active">Pagos</a>
            </div>
        </div>
    </nav>
</header>

<main class="container">

    <!-- ========== TABLA DE ÚLTIMOS PAGOS ========== -->
    <!-- id="ultimos" para reutilizar estilos amarillos de la tabla -->
    <section id="ultimos" class="card">
        <div class="section-head">
            <h2>Tabla de últimos pagos</h2>

            <div class="actions">
                <button type="button" class="btn btn-primary" id="btnAbrirModal">
                    <i class="fa-solid fa-plus"></i> Registrar pago
                </button>
            </div>
        </div>

        <div class="datatable-wrapper">
            <table class="datatable">
                <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Origen</th>
                    <th>N° Ref.</th>
                    <th>Placa</th>
                    <th>Fecha</th>
                    <th>Monto</th>
                    <th>Método</th>
                    <th class="ta-center">Acciones</th>
                </tr>
                </thead>
                <tbody>
                <!-- EJEMPLO ESTÁTICO. Luego reemplazas por c:forEach con tu listaPagos -->
                <tr>
                    <td>Tyler Joseph</td>
                    <td><span class="tag">Orden</span></td>
                    <td>OR-0754</td>
                    <td>C7L-984</td>
                    <td>03/10/2025</td>
                    <td><span class="money">S/ 370.00</span></td>
                    <td>Efectivo</td>
                    <td class="ta-center">
                        <button type="button" class="chip"
                                title="Editar"
                                data-role="editar"
                                data-cliente="Tyler Joseph"
                                data-origen="Orden"
                                data-ref="OR-0754"
                                data-placa="C7L-984"
                                data-fecha="2025-10-03"
                                data-monto="370.00"
                                data-metodo="Efectivo"
                                data-notas="">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                    </td>
                </tr>

                <tr>
                    <td>Luis Caseros</td>
                    <td><span class="tag">Proforma</span></td>
                    <td>PF-1845</td>
                    <td>BDP-213</td>
                    <td>29/09/2025</td>
                    <td><span class="money">S/ 612.50</span></td>
                    <td>Tarjeta</td>
                    <td class="ta-center">
                        <button type="button" class="chip"
                                title="Editar"
                                data-role="editar"
                                data-cliente="Luis Caseros"
                                data-origen="Proforma"
                                data-ref="PF-1845"
                                data-placa="BDP-213"
                                data-fecha="2025-09-29"
                                data-monto="612.50"
                                data-metodo="Tarjeta"
                                data-notas="Pago con VISA crédito.">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                    </td>
                </tr>

                <!-- EJEMPLO CON BACKEND:
                <c:forEach var="p" items="${listaPagos}">
                    <tr>
                        <td>${p.clienteNombre}</td>
                        <td><span class="tag">${p.origen}</span></td>
                        <td>${p.numeroRef}</td>
                        <td>${p.placa}</td>
                        <td>${p.fechaFormateada}</td>
                        <td><span class="money">S/ ${p.monto}</span></td>
                        <td>${p.metodoPago}</td>
                        <td class="ta-center">
                            <button type="button" class="chip"
                                    data-role="editar"
                                    data-id="${p.id}"
                                    data-cliente="${p.clienteNombre}"
                                    data-origen="${p.origen}"
                                    data-ref="${p.numeroRef}"
                                    data-placa="${p.placa}"
                                    data-fecha="${p.fechaISO}"
                                    data-monto="${p.monto}"
                                    data-metodo="${p.metodoPago}"
                                    data-notas="${p.notas}">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                -->
                </tbody>
            </table>
        </div>

        <div class="center mt-16">
            <button type="button" class="btn btn-secondary">
                Ver más
            </button>
        </div>

        <!-- Mensaje de confirmación (front) -->
        <div id="msgConfirm" class="hint center" style="display:none; margin-top:.75rem;">
            ✅ Pago registrado correctamente.
        </div>
    </section>

</main>

<!-- ========== MODAL: REGISTRAR / EDITAR PAGO ========== -->
<div id="modalPago" class="modal az-hide">
    <div class="modal-card small">

        <header class="modal-header">
            <h3 id="tituloModal">Registrar pago</h3>
        </header>

        <!-- FRONT: cambia action y method cuando tengas tu servlet -->
        <form id="formPago" action="#" method="post">
            <div class="field">
                <label for="cliente">Cliente</label>
                <input type="text" id="cliente" name="cliente" placeholder="Nombre del cliente">
            </div>

            <div class="field">
                <label for="origen">Origen</label>
                <select id="origen" name="origen">
                    <option value="Orden">Orden</option>
                    <option value="Proforma">Proforma</option>
                </select>
            </div>

            <div class="field">
                <label for="ref">N° de referencia</label>
                <input type="text" id="ref" name="ref" placeholder="OR-0001 / PF-0001">
            </div>

            <div class="field">
                <label for="placa">Placa</label>
                <input type="text" id="placa" name="placa" placeholder="ABC-123">
            </div>

            <div class="field">
                <label for="monto">Monto</label>
                <input type="number" step="0.01" id="monto" name="monto" placeholder="0.00">
            </div>

            <div class="field">
                <label>Método de pago</label>
                <select id="metodoPago" name="metodoPago">
                    <option value="Efectivo">Efectivo</option>
                    <option value="Tarjeta">Tarjeta</option>
                    <option value="Yape">Yape</option>
                    <option value="Plin">Plin</option>
                </select>
            </div>

            <div class="field">
                <label for="fecha">Fecha</label>
                <input type="date" id="fecha" name="fecha">
            </div>

            <div class="field">
                <label for="notas">Notas</label>
                <textarea id="notas" name="notas" rows="3"
                          placeholder="Comentarios adicionales sobre el pago"></textarea>
            </div>

            <footer class="modal-footer">
                <button type="button" class="btn btn-secondary" id="btnCancelar">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary" id="btnGuardar">
                    Guardar
                </button>
            </footer>
        </form>
    </div>
</div>

<script>
    const modal = document.getElementById('modalPago');
    const btnAbrir = document.getElementById('btnAbrirModal');
    const btnCancelar = document.getElementById('btnCancelar');
    const form = document.getElementById('formPago');
    const tituloModal = document.getElementById('tituloModal');
    const msgConfirm = document.getElementById('msgConfirm');

    function abrirModal(modo) {
        tituloModal.textContent = (modo === 'editar') ? 'Editar pago' : 'Registrar pago';
        modal.classList.remove('az-hide');
    }

    function cerrarModal() {
        modal.classList.add('az-hide');
    }

    btnAbrir.addEventListener('click', () => {
        form.reset();
        abrirModal('nuevo');
    });

    btnCancelar.addEventListener('click', cerrarModal);

    // Cerrar clic fuera de la tarjeta
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            cerrarModal();
        }
    });

    // Editar: carga datos en el formulario
    document.querySelectorAll('button[data-role="editar"]').forEach(btn => {
        btn.addEventListener('click', () => {
            form.reset();
            document.getElementById('cliente').value = btn.dataset.cliente || '';
            document.getElementById('origen').value = btn.dataset.origen || 'Orden';
            document.getElementById('ref').value = btn.dataset.ref || '';
            document.getElementById('placa').value = btn.dataset.placa || '';
            document.getElementById('monto').value = btn.dataset.monto || '';
            document.getElementById('metodoPago').value = btn.dataset.metodo || btn.dataset.metodoPago || 'Efectivo';
            document.getElementById('fecha').value = btn.dataset.fecha || '';
            document.getElementById('notas').value = btn.dataset.notas || '';

            abrirModal('editar');
        });
    });

    // Guardar: confirmación (solo front)
    form.addEventListener('submit', (e) => {
        e.preventDefault();

        if (!confirm('¿Confirmar registro de pago?')) {
            return;
        }

        // Aquí luego harás el submit real:
        // form.action = 'PagoServlet';
        // form.method = 'post';
        // form.submit();

        cerrarModal();

        msgConfirm.style.display = 'block';
        setTimeout(() => msgConfirm.style.display = 'none', 3000);
    });
</script>

</body>
</html>
