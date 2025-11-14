<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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
</head>
<body>
  <!-- NAV/TABS -->
  <header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Clientes</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>
        <nav class="tabs">
          <a href="index.jsp">Inicio</a>
          <a>Registro de Pagos</a>
          <a>Productos</a>
          <a>Inventario</a>
          <a href="citas.jsp">Citas</a>
          <a class="active">Servicios</a>
          <a href="clientes.jsp">Clientes</a>
          <a href="vehiculos.jsp">Vehículos</a>
        </nav>
  <main class="container">

    <!-- Barra superior: filtro “Cliente …” + botón Amarillo Añadir Servicio -->
    <div class="toolbar">
      <div class="toolbar-left">
        <button type="button" class="chip">Cliente <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">Origen <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">N° Ref. <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">Placa <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">Fecha <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">Monto <span class="chip-caret">▼</span></button>
        <button type="button" class="chip">Método <span class="chip-caret">▼</span></button>
        <span class="chip muted">Acciones</span>
      </div>

      <div class="toolbar-right">
        <button id="btn-open-create" class="btn btn-primary btn-round">
          + Añadir Servicio
        </button>
      </div>
    </div>

    <!-- Tabla principal como en las maquetas -->
    <div class="table-wrapper">
      <table class="table flat">
        <thead>
          <tr>
            <th>Cliente</th>
            <th>Origen</th>
            <th>N° Ref.</th>
            <th>Placa</th>
            <th>Fecha</th>
            <th>Monto</th>
            <th>Método</th>
            <th class="center">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="s" items="${servicios}">
            <tr>
              <td>${s.clienteNombre}</td>
              <td>${s.origen}</td>
              <td>${s.numeroRef}</td>
              <td>${s.placa}</td>
              <td>${s.fecha}</td>
              <td>S/ ${s.monto}</td>
              <td>${s.metodoPago}</td>
              <td class="center">
                <!-- íconos estilo redondos como en tu UI -->
                <button class="icon-btn" title="Modificar"
                        data-edit='${s.id}'
                        data-row='${fn:escapeXml(s.json)}'>
                  ✏️
                </button>
                <a class="icon-btn" title="Imprimir" href="ServicioServlet?action=print&id=${s.id}">🖨️</a>
                <button class="icon-btn danger" title="Eliminar" data-delete='${s.id}'>🗑️</button>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty servicios}">
            <tr><td colspan="8" class="center muted">Sin registros</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </main>

  <!-- =============== MODAL CREAR =============== -->
  <div id="modal-create" class="modal hidden">
    <div class="modal-card">
      <header class="modal-header">
        <h3>Servicios</h3>
      </header>

      <form method="post" action="ServicioServlet">
        <input type="hidden" name="action" value="create"/>

        <!-- Buscador (versión de mock de “Buscar Servicio”) -->
        <div class="field search">
          <input type="text" id="buscarServicio" placeholder="Buscar Servicio"/>
        </div>

        <!-- Datos base (Servicio / Tipo) -->
        <div class="grid2 gap">
          <div class="field">
            <label>Servicio</label>
            <input type="text" name="titulo" required/>
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
        </div>

        <!-- Lista de “Servicio Ofrecido” (marcar y setear precios) -->
        <section class="panel">
          <div class="panel-title">Servicio Ofrecido</div>

          <div id="ofertas" class="list-selectable">
            <c:forEach var="cata" items="${catalogoServicios}">
              <div class="row-offer">
                <label>
                  <input type="checkbox" name="items" value="${cata.id}" class="chk-item"/>
                  <span class="offer-name">${cata.nombre}</span>
                </label>
                <input type="number" step="0.01" min="0" class="price-input" name="precio_${cata.id}" placeholder="XXX"/>
              </div>
            </c:forEach>
            <button type="button" id="btn-add-custom" class="link">+ Nuevo Servicio</button>
          </div>
        </section>

        <footer class="modal-footer">
          <button type="button" class="btn" data-close>Cancelar</button>
          <button type="submit" class="btn btn-primary">Siguiente</button>
        </footer>
      </form>
    </div>
  </div>

  <!-- =============== MODAL EDITAR =============== -->
  <div id="modal-edit" class="modal hidden">
    <div class="modal-card">
      <header class="modal-header">
        <h3>Modificar Servicio</h3>
      </header>

      <form method="post" action="ServicioServlet" id="form-edit">
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-id"/>

        <div class="field search">
          <input type="text" id="buscarServicioEdit" placeholder="Buscar Servicio"/>
        </div>

        <div class="grid2 gap">
          <div class="field">
            <label>Servicio</label>
            <input type="text" name="titulo" id="edit-titulo" required/>
          </div>
          <div class="field">
            <label>Tipo</label>
            <select name="tipo" id="edit-tipo" required>
              <option value="">Seleccione</option>
              <option>Mantenimiento</option>
              <option>Diagnóstico</option>
              <option>Correctivo</option>
              <option>Preventivo</option>
            </select>
          </div>
        </div>

        <section class="panel">
          <div class="panel-title">Servicio Ofrecido</div>
          <div id="edit-ofertas" class="list-selectable">
            <!-- Se llena por JS con los ítems existentes -->
          </div>
          <button type="button" id="btn-add-custom-edit" class="link">+ Nuevo Servicio</button>
        </section>

        <footer class="modal-footer">
          <button type="button" class="btn" data-close>Cancelar</button>
          <button type="submit" class="btn btn-primary">Guardar</button>
        </footer>
      </form>
    </div>
  </div>

  <!-- =============== MODAL ELIMINAR =============== -->
  <div id="modal-delete" class="modal hidden">
    <div class="modal-card small">
      <header class="modal-header center">
        <h3>¿Estas seguro que deseas eliminar este servicio?</h3>
      </header>
      <form method="post" action="ServicioServlet">
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="id" id="delete-id"/>
        <footer class="modal-footer two">
          <button type="button" class="btn" data-close>Cancelar</button>
          <button type="submit" class="btn btn-danger">Confirmar</button>
        </footer>
      </form>
    </div>
  </div>

  <!-- JS mínimo (no rompe tu CSS) -->
  <script>
    // helpers modal
    const qs = s => document.querySelector(s);
    const qsa = s => Array.from(document.querySelectorAll(s));
    const open = el => el.classList.remove('hidden');
    const close = el => el.classList.add('hidden');
    qsa('[data-close]').forEach(b => b.addEventListener('click', e => close(e.target.closest('.modal'))));

    // Crear
    qs('#btn-open-create').addEventListener('click', () => open(qs('#modal-create')));

    // Agregar servicio custom en Crear
    const makeRow = (prefix='custom') => {
      const id = prefix + '_' + Date.now();
      const row = document.createElement('div');
      row.className = 'row-offer';
      row.innerHTML = `
        <label>
          <input type="checkbox" name="items" value="${id}" checked class="chk-item"/>
          <input type="text" name="nombre_${id}" placeholder="Nombre del servicio" required class="inline"/>
        </label>
        <input type="number" step="0.01" min="0" name="precio_${id}" placeholder="XXX" required/>
      `;
      return row;
    };
    qs('#btn-add-custom')?.addEventListener('click', () => qs('#ofertas').appendChild(makeRow()));

    // Editar: abrir y precargar (usa atributo data-row con JSON de tu backend)
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('[data-edit]');
      if (!btn) return;
      const dataRaw = btn.getAttribute('data-row');
      try {
        const data = JSON.parse(dataRaw); // {id,titulo,tipo,items:[{id,nombre,precio}]}
        qs('#edit-id').value = data.id;
        qs('#edit-titulo').value = data.titulo || '';
        qs('#edit-tipo').value = data.tipo || '';
        const wrap = qs('#edit-ofertas');
        wrap.innerHTML = '';
        (data.items || []).forEach(it => {
          const row = document.createElement('div');
          row.className = 'row-offer';
          row.innerHTML = `
        <label>
        <input type="checkbox" name="items" value="\${it.id}" \${it.activo!==false?'checked':''} class="chk-item"/>
        <span class="offer-name">\${it.nombre}</span>
        </label>
        <input type="number" step="0.01" min="0"
             name="precio_\${it.id}" value="\${it.precio ?? ''}" placeholder="XXX"/>
            `;

          wrap.appendChild(row);
        });
        open(qs('#modal-edit'));
      } catch (err) {
        console.error('JSON inválido en data-row', err);
      }
    });
    qs('#btn-add-custom-edit')?.addEventListener('click', () => qs('#edit-ofertas').appendChild(makeRow('customEdit')));

    // Eliminar
    document.addEventListener('click', (e) => {
      const b = e.target.closest('[data-delete]');
      if (!b) return;
      qs('#delete-id').value = b.getAttribute('data-delete');
      open(qs('#modal-delete'));
    });
  </script>
</body>
</html>
