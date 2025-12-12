<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Editar cita | AZ Mecánica</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <style>
    form { max-width:600px; margin:40px auto; background:#111; padding:20px; border-radius:12px; color:#fff; }
    label { font-weight:bold; }
    input, select, textarea { width:100%; padding:6px; border-radius:6px; margin-bottom:10px; }
    .btn { border:none; padding:6px 12px; border-radius:8px; cursor:pointer; }
    .btn-primary { background:#ffb800; color:#000; }
  </style>
</head>
<body>
  <h2 style="text-align:center;">Editar cita</h2>

  <form method="post" action="CitaServlet">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${cita.id}">

    <label>Cliente</label>
    <select name="idCliente" required>
      <c:forEach var="cli" items="${clientes}">
        <option value="${cli.dni}" ${cli.dni==cita.idCliente?'selected':''}>
          ${cli.nombre} ${cli.apellido}
        </option>
      </c:forEach>
    </select>

    <label>Fecha</label>
    <!-- LocalDate.toString() = yyyy-MM-dd (válido para <input type="date">) -->
    <input type="date" name="fecha" value="${cita.fecha}" required>

    <label>Hora</label>
    <!-- LocalTime.toString() = HH:mm:ss; si prefieres HH:mm puedes formatearlo en el servlet -->
    <input type="time" name="hora" value="${cita.hora}" required>

    <label>Tipo</label>
    <select name="tipo" required>
      <option ${cita.tipo=='Mantenimiento'?'selected':''}>Mantenimiento</option>
      <option ${cita.tipo=='Diagnóstico'?'selected':''}>Diagnóstico</option>
      <option ${cita.tipo=='Correctivo'?'selected':''}>Correctivo</option>
      <option ${cita.tipo=='Preventivo'?'selected':''}>Preventivo</option>
    </select>

    <label>Empleado</label>
    <select name="idEmpleado">
      <option value="">Sin asignar</option>
      <c:forEach var="emp" items="${empleados}">
        <option value="${emp.id}" ${emp.id==cita.idEmpleado?'selected':''}>${emp.nombres}</option>
      </c:forEach>
    </select>

    <label>Notas</label>
    <textarea name="notas" rows="3">${cita.notas}</textarea>

    <div style="display:flex; justify-content:space-between;">
      <a href="CitaServlet?anio=${cita.fecha.year}&mes=${cita.fecha.monthValue}" class="btn">Cancelar</a>
      <button class="btn btn-primary">Guardar cambios</button>
    </div>
  </form>
</body>
</html>
