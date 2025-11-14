<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
  <title>AZ Mecánica | Citas</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

  <style>
    main.container { padding: 20px; }
    .calendar-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; }
    .calendar-box { background:#fff1; border-radius:12px; overflow:hidden; }
    .calendar { width:100%; border-collapse:collapse; text-align:center; }
    .calendar th { background:#222; color:#fff; padding:8px; }
    .calendar td { height:100px; vertical-align:top; padding:4px; border:1px solid #333; position:relative; }
    .calendar .day-num { font-weight:bold; color:#fff; font-size:14px; }
    .event { background:#333; border-radius:6px; color:#fff; padding:2px 5px; margin:3px 0; cursor:pointer; text-align:left; font-size:12px; }
    .event.CONFIRMADA { background:#2ecc71; }
    .event.PENDIENTE { background:#f1c40f; color:#000; }
    .event.CANCELADA { background:#7f8c8d; color:#000; }

    /* panel lateral */
    .sidepanel { position:fixed; top:0; right:-450px; width:420px; height:100%; background:#222; color:#fff; transition:.3s; padding:20px; overflow-y:auto; }
    .sidepanel.open { right:0; }
    .sidepanel h3 { margin-top:0; }
    .hidden { display:none; }
    .field { margin-bottom:12px; display:flex; flex-direction:column; }
    .field label { font-weight:bold; margin-bottom:3px; }
    .field input, .field select, .field textarea { padding:6px; border:none; border-radius:6px; }
    .row { display:flex; gap:8px; }
    .gap { gap:8px; }
    .btn { border:none; border-radius:8px; cursor:pointer; padding:6px 12px; font-weight:bold; }
    .btn-primary { background:#ffb800; color:#000; }
    .btn-danger-outline { border:1px solid #ff4444; color:#ff4444; background:transparent; }
    .btn-round { border-radius:20px; }
  </style>
</head>
<body>

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Citas</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a>Registro de Pagos</a>
  <a>Productos</a>
  <a>Inventario</a>
  <a class="active">Citas</a>
  <a href="servicios.jsp">Servicios</a>
  <a href="clientes.jsp">Clientes</a>
  <a href="vehiculos.jsp">Vehículos</a>
</nav>

<main class="container">
  <div class="calendar-head">
    <div>
      <button class="btn chip">Mes</button>
      <button class="btn chip">Semana</button>
      <button class="btn chip">Día</button>
      <span class="legend"><i class="dot dot-green"></i> Confirmada</span>
      <span class="legend"><i class="dot dot-yellow"></i> Pendiente</span>
      <span class="legend"><i class="dot dot-gray"></i> Cancelada</span>
    </div>
    <button id="btn-nueva" class="btn btn-primary btn-round">+ Nueva cita</button>
  </div>

  <div class="calendar-box">
    <header style="display:flex; justify-content:space-between; align-items:center; padding:10px;">
      <div>
        <a href="#">‹</a>
        <strong>${requestScope.mesNombre} ${requestScope.anio}</strong>
        <a href="#">›</a>
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
                       data-cliente="${ev.cliente}"
                       data-fecha="${dia.fechaISO}"
                       data-hora="${ev.horaTxt}"
                       data-servicio="${ev.servicio}"
                       data-estado="${ev.estado}">
                    ${ev.horaTxt} - ${ev.cliente}
                  </div>
                </c:forEach>
              </td>
            </c:forEach>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- Panel lateral -->
  <aside id="sidepanel" class="sidepanel">
    <!-- Nueva Cita -->
    <div id="panel-new" class="hidden">
      <h3>Nueva cita</h3>
      <form method="post" action="CitaServlet">
        <input type="hidden" name="action" value="create">
        <div class="field">
          <label>Cliente</label>
          <select name="idCliente" required>
            <option value="">Seleccione</option>
            <c:forEach var="cli" items="${requestScope.clientes}">
              <option value="${cli.id}">${cli.nombre}</option>
            </c:forEach>
          </select>
        </div>

        <div class="row">
          <div class="field"><label>Fecha</label><input type="date" name="fecha" required></div>
          <div class="field"><label>Hora</label><input type="time" name="hora" required></div>
        </div>

        <div class="field">
          <label>Tipo</label>
          <select name="tipo" required>
            <option value="">Seleccione</option>
            <option>Mantenimiento</option>
            <option>Diagnóstico</option>
            <option>Correctivo</option>
            <option>Preventivo</option>
          </select>
        </div>

        <div class="field">
          <label>Empleado</label>
          <select name="idEmpleado">
            <option value="">Sin asignar</option>
            <c:forEach var="emp" items="${requestScope.empleados}">
              <option value="${emp.id}">${emp.nombres}</option>
            </c:forEach>
          </select>
        </div>

        <div class="field">
          <label>Notas</label>
          <textarea name="notas" rows="3"></textarea>
        </div>

        <div class="row" style="justify-content:end;">
          <button type="button" class="btn" data-close>Cancelar</button>
          <button class="btn btn-primary">Guardar</button>
        </div>
      </form>
    </div>

    <!-- Detalle/Cancelación -->
    <div id="panel-detail" class="hidden">
      <h3>Detalle de la cita</h3>
      <form method="post" action="CitaServlet">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" id="det-id" name="id">

        <div class="field"><label>Cliente</label><input id="det-cliente" readonly></div>
        <div class="row">
          <div class="field"><label>Fecha</label><input id="det-fecha" readonly></div>
          <div class="field"><label>Hora</label><input id="det-hora" readonly></div>
        </div>
        <div class="field"><label>Servicio</label><input id="det-servicio" readonly></div>

        <div class="row" style="justify-content:space-between;">
          <button class="btn btn-danger-outline">Cancelar cita</button>
          <a id="det-editar" class="btn btn-primary" href="#">Editar</a>
        </div>
      </form>
    </div>
  </aside>
</main>

<script>
const panel = document.getElementById('sidepanel');
const newPanel = document.getElementById('panel-new');
const detPanel = document.getElementById('panel-detail');

document.getElementById('btn-nueva').onclick = ()=>{
  detPanel.classList.add('hidden');
  newPanel.classList.remove('hidden');
  panel.classList.add('open');
};

document.querySelectorAll('[data-close]').forEach(b=>{
  b.onclick=()=>{ panel.classList.remove('open'); newPanel.classList.add('hidden'); detPanel.classList.add('hidden'); };
});

document.addEventListener('click', e=>{
  const ev=e.target.closest('.event');
  if(!ev)return;
  document.getElementById('det-id').value=ev.dataset.id;
  document.getElementById('det-cliente').value=ev.dataset.cliente;
  document.getElementById('det-fecha').value=ev.dataset.fecha;
  document.getElementById('det-hora').value=ev.dataset.hora;
  document.getElementById('det-servicio').value=ev.dataset.servicio;
  document.getElementById('det-editar').href='cita-form.jsp?id='+ev.dataset.id;

  newPanel.classList.add('hidden');
  detPanel.classList.remove('hidden');
  panel.classList.add('open');
});
</script>
</body>
</html>
