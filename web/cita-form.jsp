<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
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
  <title>AZ Mecánica | Inventario</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<!-- TOP -->
<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Inventario</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<!-- NAV -->
<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a>Registro de Pagos</a>
  <a>Productos</a>
  <a class="active">Inventario</a>
  <a href="citas.jsp">Citas</a>
  <a href="servicios.jsp">Servicios</a>
  <a href="clientes.jsp">Clientes</a>
  <a href="vehiculos.jsp">Vehículos</a>
</nav>

<main class="container">

  <!-- ===== Encabezado + acción ===== -->
  <section class="card" id="ultimos">
    <div class="section-head">
      <h2>Inventario de productos</h2>
      <a class="btn btn-primary" href="inventario-form.jsp?action=create">+ Agregar producto</a>
    </div>

    <!-- ===== Filtros ===== -->
    <div class="filters" style="margin-bottom:.5rem">
      <div class="field">
        <label>Código</label>
        <input id="fCodigo" type="text" placeholder="P0001, F0010…">
      </div>
      <div class="field">
        <label>Nombre</label>
        <input id="fNombre" type="text" placeholder="Buscar por nombre…">
      </div>
      <div class="field">
        <label>Categoría</label>
        <select id="fCategoria">
          <option value="">Todas</option>
          <option>Lubricantes</option>
          <option>Filtros</option>
          <option>Eléctricos</option>
          <option>Llantas</option>
          <option>Motor</option>
          <option>Hules</option>
          <option>Otros</option>
        </select>
      </div>
      <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
      <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
    </div>

    <!-- ===== Tabla ===== -->
    <div class="datatable-wrapper">
      <table class="datatable" id="tablaInv" data-empty="No hay productos para el filtro.">
        <colgroup>
          <col style="width:14%"><col style="width:32%"><col style="width:18%">
          <col style="width:12%"><col style="width:14%"><col style="width:10%">
        </colgroup>
        <thead>
          <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Categoría</th>
            <th>Stock</th>
            <th>Precio</th>
            <th class="ta-center">Acciones</th>
          </tr>
        </thead>
        <tbody id="bodyInv"></tbody>
      </table>
    </div>
  </section>

</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<script>
/* =======================
   MOCK: Productos de inventario
   ======================= */
const MIN_STOCK = 3;

const productos = [
  {id:1, codigo:'P0001', nombre:'Aceite de motor', categoria:'Lubricantes', stock:11, precio:19.9},
  {id:2, codigo:'P0002', nombre:'Filtro de aire',  categoria:'Filtros',      stock:4,  precio:15.0},
  {id:3, codigo:'P0003', nombre:'Pastillas de freno',categoria:'Hules',      stock:2,  precio:39.5}, // ALERTA
  {id:4, codigo:'P0004', nombre:'Bujías 12V',       categoria:'Eléctricos',  stock:3,  precio:12.0}, // ALERTA
  {id:5, codigo:'P0005', nombre:'Freno DOT 3',      categoria:'Eléctricos',  stock:8,  precio:9.9},
  {id:6, codigo:'P0006', nombre:'Llanta 195/65R15', categoria:'Llantas',     stock:5,  precio:210.0},
  {id:7, codigo:'P0007', nombre:'Correa distribución',categoria:'Motor',     stock:1,  precio:75.0}  // ALERTA
];

/* Render de filas con alerta visual cuando stock ≤ MIN_STOCK */
function renderInv(rows){
  const tb = document.getElementById('bodyInv');
  tb.innerHTML = '';

  rows.forEach(p=>{
    const low = p.stock <= MIN_STOCK;
    const tr = document.createElement('tr');
    if(low) tr.style.background = '#1a1416'; // leve contraste para alertar
    tr.innerHTML = `
      <td>${p.codigo}</td>
      <td>
        ${p.nombre}
        ${low ? ' <span class="icon danger" title="Stock mínimo">❗</span>' : ''}
      </td>
      <td><span class="tag">${p.categoria}</span></td>
      <td>${p.stock}</td>
      <td><span class="money">S/ ${p.precio.toFixed(2)}</span></td>
      <td class="ta-center">
        <a class="chip" href="inventario-form.jsp?action=view&id=${p.id}" title="Ver">👁</a>
        <a class="chip" href="inventario-form.jsp?action=edit&id=${p.id}" title="Editar">✏</a>
        <button class="chip danger" onclick="fakeDelete(this)" title="Eliminar">🗑</button>
      </td>
    `;
    tb.appendChild(tr);
  });

  if(rows.length === 0){
    const tr = document.createElement('tr');
    tr.innerHTML = <td colspan="6" class="empty">\${document.getElementById('tablaInv').dataset.empty}</td>;
    tb.appendChild(tr);
  }
}

/* Filtro simple por código / nombre / categoría */
function applyFilter(){
  const qCod = document.getElementById('fCodigo').value.trim().toLowerCase();
  const qNom = document.getElementById('fNombre').value.trim().toLowerCase();
  const qCat = document.getElementById('fCategoria').value;

  const out = productos.filter(p=>{
    const byCod = !qCod || p.codigo.toLowerCase().includes(qCod);
    const byNom = !qNom || p.nombre.toLowerCase().includes(qNom);
    const byCat = !qCat || p.categoria === qCat;
    return byCod && byNom && byCat;
  });
  renderInv(out);
}

function clearFilter(){
  document.getElementById('fCodigo').value='';
  document.getElementById('fNombre').value='';
  document.getElementById('fCategoria').value='';
  renderInv(productos);
}

/* Eliminar visual (mock) */
function fakeDelete(btn){
  const tr = btn.closest('tr');
  tr.classList.add('fade');
  setTimeout(()=>tr.remove(), 200);
}

document.getElementById('btnAplicar').addEventListener('click', applyFilter);
document.getElementById('btnLimpiar').addEventListener('click', clearFilter);

/* Pintar al cargar */
renderInv(productos);
</script>
</body>
</html>