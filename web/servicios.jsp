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
  <title>AZ Mecánica | Servicios</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <style>
    /* mínimos por si falta algo */
    .container{width:min(1200px,92%);margin:24px auto}
    .topbar, .tabs, .actions{display:flex;gap:12px;align-items:center}
    .card{background:var(--card,#1f1f24);border:1px solid var(--border,#2a2a30);border-radius:12px;padding:16px;box-shadow:var(--shadow)}
    .grid{display:grid;gap:12px}
    .grid-4{grid-template-columns:repeat(4,1fr)}
    .field{display:flex;flex-direction:column;gap:6px}
    .table{width:100%;border-collapse:collapse}
    .table th,.table td{border-bottom:1px solid var(--border,#2a2a30);padding:10px;text-align:left}
    .btn{background:var(--accent,#ffcc00);color:#000;padding:8px 12px;border-radius:8px;text-decoration:none;border:none;cursor:pointer}
    .btn.sec{background:transparent;color:var(--ink,#f5f5f5);border:1px solid var(--border,#2a2a30)}
    .right{margin-left:auto}
    .muted{color:var(--muted,#b7b7c2)}
    .inline{display:flex;gap:8px;align-items:center}
    .total{font-weight:700}
    .items thead th{position:sticky;top:0;background:var(--panel,#17171b)}
    .items input{width:100%}
    .pill{padding:2px 8px;border-radius:999px;border:1px solid var(--border)}
  </style>
</head>
<body class="bg">

<header class="topbar container">
  <div class="brand inline">
    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" style="height:32px">
    <span class="brand__label">Servicios</span>
  </div>
  <div class="right inline">
    <a class="btn" href="${pageContext.request.contextPath}/servicios?accion=nuevo">+ Nuevo servicio</a>
  </div>
</header>

<main class="container grid" style="gap:20px">
  <c:if test="${not empty param.msg}">
    <div class="card" style="border-color:#3a3">
      ✅ ${param.msg}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="card" style="border-color:#a33">
      ❌ ${error}
    </div>
  </c:if>

  <!-- ==== LISTADO + FILTROS ==== -->
  <c:if test="${empty servicio}">
    <section class="card" id="filtros">
      <form class="grid grid-4" method="get" action="${pageContext.request.contextPath}/servicios">
        <input type="hidden" name="accion" value="listar">
        <div class="field"><label>Cliente / DNI</label><input name="fNombre" type="text" value="${param.fNombre}"></div>
        <div class="field">
          <label>Origen</label>
          <select name="fOrigen">
            <option value="">Todos</option>
            <option ${param.fOrigen=='Orden'?'selected':''}>Orden</option>
            <option ${param.fOrigen=='Proforma'?'selected':''}>Proforma</option>
            <option ${param.fOrigen=='Web'?'selected':''}>Web</option>
          </select>
        </div>
        <div class="field"><label>Desde</label><input name="fDesde" type="date" value="${param.fDesde}"></div>
        <div class="field"><label>Hasta</label><input name="fHasta" type="date" value="${param.fHasta}"></div>
        <div class="inline" style="grid-column:1/-1;justify-content:flex-end">
          <button class="btn" type="submit">Aplicar</button>
          <a class="btn sec" href="${pageContext.request.contextPath}/servicios?accion=listar">Limpiar</a>
        </div>
      </form>
    </section>

    <section class="card">
      <div class="section-head inline" style="justify-content:space-between">
        <h2>Listado</h2>
        <a class="btn" href="${pageContext.request.contextPath}/servicios?accion=nuevo">+ Nuevo</a>
      </div>
      <div class="table-wrap" style="overflow:auto;max-height:60vh">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th><th>Fecha</th><th>Título</th><th>Cliente</th><th>Placa</th>
              <th>Origen</th><th>Ref</th><th>Tipo</th><th>Estado</th><th class="right">Total</th><th>Acciones</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="r" items="${lista}">
            <tr>
              <td>${r.id}</td>
              <td>${r.fecha}</td>
              <td>${r.titulo}</td>
              <td>${r.cliente} <span class="muted">(${r.dni_cliente})</span></td>
              <td>${r.placa}</td>
              <td>${r.origen}</td>
              <td><c:out value="${r.numero_ref}"/></td>
              <td>${r.tipo}</td>
              <td><span class="pill">${r.estado}</span></td>
              <td class="right">S/ ${r.monto_total}</td>
              <td class="inline">
                <a class="btn sec" href="${pageContext.request.contextPath}/servicios?accion=editar&id=${r.id}">Editar</a>
                <a class="btn sec" href="${pageContext.request.contextPath}/servicios?accion=estado&id=${r.id}&estado=Completado">Marcar OK</a>
                <a class="btn sec" href="${pageContext.request.contextPath}/servicios?accion=eliminar&id=${r.id}" onclick="return confirm('¿Eliminar servicio #${r.id}?');">Eliminar</a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty lista}">
            <tr><td colspan="11" class="muted">Sin resultados</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </section>
  </c:if>

  <!-- ==== FORM (crear/editar) ==== -->
  <c:if test="${not empty servicio}">
    <section class="card">
      <h2>${servicio.id == null ? "Nuevo servicio" : ("Editar servicio #"+servicio.id)}</h2>
      <form method="post" action="${pageContext.request.contextPath}/servicios" oninput="calcTotal()">
        <c:if test="${servicio.id != null}">
          <input type="hidden" name="id" value="${servicio.id}">
        </c:if>

        <div class="grid grid-4">
          <div class="field"><label>Título</label><input name="titulo" required value="${servicio.titulo}"></div>
          <div class="field"><label>Tipo</label>
            <select name="tipo">
              <c:set var="t" value="${servicio.tipo!=null?servicio.tipo:'Mantenimiento'}"/>
              <option ${t=='Mantenimiento'?'selected':''}>Mantenimiento</option>
              <option ${t=='Diagnóstico'?'selected':''}>Diagnóstico</option>
              <option ${t=='Correctivo'?'selected':''}>Correctivo</option>
              <option ${t=='Preventivo'?'selected':''}>Preventivo</option>
            </select>
          </div>
          <div class="field"><label>DNI Cliente</label><input name="dni_cliente" maxlength="8" required value="${servicio.dniCliente}"></div>
          <div class="field"><label>Placa</label><input name="placa_vehiculo" maxlength="10" required value="${servicio.placaVehiculo}"></div>

          <div class="field"><label>Origen</label>
            <select name="origen">
              <option ${servicio.origen=='Orden'?'selected':''}>Orden</option>
              <option ${servicio.origen=='Proforma'?'selected':''}>Proforma</option>
              <option ${servicio.origen=='Web'?'selected':''}>Web</option>
            </select>
          </div>
          <div class="field"><label>N° Ref</label><input name="numero_ref" value="${servicio.numeroRef}"></div>
          <div class="field"><label>Fecha</label><input type="date" name="fecha" value="<c:out value='${servicio.fecha}'/>" required></div>
          <div class="field"><label>Método de pago</label><input name="metodo_pago" value="${servicio.metodoPago}"></div>
          <div class="field"><label>Estado</label>
            <select name="estado">
              <c:set var="e" value="${servicio.estado!=null?servicio.estado:'Pendiente'}"/>
              <option ${e=='Pendiente'?'selected':''}>Pendiente</option>
              <option ${e=='En Proceso'?'selected':''}>En Proceso</option>
              <option ${e=='Completado'?'selected':''}>Completado</option>
              <option ${e=='Cancelado'?'selected':''}>Cancelado</option>
            </select>
          </div>
          <div class="field" style="grid-column:1/-1"><label>Observaciones</label>
            <textarea name="observaciones" rows="3">${servicio.observaciones}</textarea>
          </div>
        </div>

        <h3 style="margin-top:16px">Items</h3>
        <div style="overflow:auto;max-height:45vh">
          <table class="table items" id="items">
            <thead>
              <tr>
                <th style="width:32px">#</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th style="width:120px">Precio</th>
                <th style="width:90px">Cant.</th>
                <th style="width:80px"></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty servicio.items}">
                  <c:forEach var="it" items="${servicio.items}" varStatus="st">
                    <tr>
                      <td>${st.index+1}</td>
                      <td><input name="item_nombre[]" value="${it.nombreServicio}" required></td>
                      <td><input name="item_desc[]" value="${it.descripcion}"></td>
                      <td><input name="item_precio[]" type="number" min="0" step="0.01" value="${it.precio}"></td>
                      <td><input name="item_cantidad[]" type="number" min="1" step="1" value="${it.cantidad}"></td>
                      <td><button class="btn sec" type="button" onclick="delRow(this)">Quitar</button></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td>1</td>
                    <td><input name="item_nombre[]" placeholder="Cambio de aceite" required></td>
                    <td><input name="item_desc[]" placeholder="Detalle opcional"></td>
                    <td><input name="item_precio[]" type="number" min="0" step="0.01" value="0"></td>
                    <td><input name="item_cantidad[]" type="number" min="1" step="1" value="1"></td>
                    <td><button class="btn sec" type="button" onclick="delRow(this)">Quitar</button></td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <div class="inline" style="margin-top:10px;justify-content:space-between">
          <button class="btn sec" type="button" onclick="addRow()">+ Agregar item</button>
          <div class="total">Total estimado: <span id="totalView">S/ 0.00</span></div>
        </div>

        <div class="inline" style="margin-top:16px;justify-content:flex-end;gap:10px">
          <a class="btn sec" href="${pageContext.request.contextPath}/servicios?accion=listar">Volver</a>
          <button class="btn" type="submit">Guardar</button>
        </div>
      </form>
    </section>
  </c:if>
</main>

<script>
function addRow(){
  const tbody = document.querySelector('#items tbody');
  const tr = document.createElement('tr');
  tr.innerHTML = `
    <td></td>
    <td><input name="item_nombre[]" required></td>
    <td><input name="item_desc[]"></td>
    <td><input name="item_precio[]" type="number" min="0" step="0.01" value="0"></td>
    <td><input name="item_cantidad[]" type="number" min="1" step="1" value="1"></td>
    <td><button class="btn sec" type="button" onclick="delRow(this)">Quitar</button></td>
  `;
  tbody.appendChild(tr);
  renum();
  calcTotal();
}
function delRow(btn){
  const tr = btn.closest('tr');
  tr.parentNode.removeChild(tr);
  renum();
  calcTotal();
}
function renum(){
  document.querySelectorAll('#items tbody tr').forEach((tr,i)=>{
    tr.children[0].textContent = (i+1);
  });
}
function calcTotal(){
  let total = 0;
  document.querySelectorAll('#items tbody tr').forEach(tr=>{
    const p = parseFloat(tr.querySelector('input[name="item_precio[]"]').value||'0');
    const c = parseInt(tr.querySelector('input[name="item_cantidad[]"]').value||'1');
    total += p*c;
  });
  document.getElementById('totalView').textContent = 'S/ ' + (total.toFixed(2));
}
calcTotal();
</script>
</body>
</html>
