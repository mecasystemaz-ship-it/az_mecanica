<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.ServicioDAO"%>
<%@page import="modelo.ServicioDAO.CatalogoServicio"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Añadir Nuevo Servicio</title>
    <style>
        /* Paleta de Colores y Estilo */
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f4f4f4; 
            padding: 20px; 
            margin: 0;
            color: #333;
        }
        .container { 
            max-width: 500px; 
            margin: auto; 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); 
        }
        h1 { 
            text-align: center; 
            color: #2c3e50; 
            margin-bottom: 25px; 
            border-bottom: 2px solid #3498db; 
            padding-bottom: 10px;
        }
        label { 
            display: block; 
            margin-top: 15px; 
            font-weight: 600;
            color: #34495e;
        }
        input[type="text"], select { 
            width: 100%; 
            padding: 10px; 
            margin-top: 5px; 
            border: 1px solid #ccc; 
            border-radius: 4px; 
            box-sizing: border-box; 
            font-size: 1em;
        }
        
        /* Botones */
        .button-group {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        input[type="submit"] { 
            background-color: #2ecc71; /* Verde para guardar */
            color: white; 
            padding: 12px 20px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-weight: bold;
            width: 48%; /* Ocupa casi la mitad */
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover { 
            background-color: #27ad60; 
        }
        .btn-cancelar {
            display: inline-block;
            text-align: center;
            line-height: 44px; /* Alinear verticalmente con el botón */
            background-color: #e74c3c; /* Rojo para cancelar */
            color: white; 
            padding: 0 20px; 
            border-radius: 4px; 
            text-decoration: none; 
            font-weight: bold;
            width: 48%;
            height: 44px;
            transition: background-color 0.3s;
        }
        .btn-cancelar:hover { 
            background-color: #c0392b; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛠️ Registrar Nuevo Servicio</h1>
        
        <form action="ServicioController" method="POST">
            
            <label for="marca">Marca del Vehículo</label>
            <input type="text" id="marca" name="marca" required placeholder="Ej. Chevrolet">
            
            <label for="modelo">Modelo del Vehículo</label>
            <input type="text" id="modelo" name="modelo" required placeholder="Ej. Spark GT">
            
            <label for="placa">Número de Placa</label>
            <input type="text" id="placa" name="placa" required placeholder="Ej. XYZ-123">

            <label for="usuario_cliente">Usuario del Cliente (Debe existir)</label>
            <input type="text" id="usuario_cliente" name="usuario_cliente" required placeholder="Ej. juanperez">
            
            <label for="servicio">Servicio a Realizar</label>
            <select id="servicio" name="servicio" required>
                <option value="">-- Seleccione un Servicio --</option>
                <%
                    // Lógica para poblar el dropdown de servicios
                    List<CatalogoServicio> catalogo = ServicioDAO.obtenerCatalogoServicios();
                    for (CatalogoServicio item : catalogo) {
                %>
                        <option value="<%= item.id %>"><%= item.nombre %></option>
                <%
                    }
                %>
            </select>
            
            <div class="button-group">
                <input type="submit" value="Guardar Servicio">
                
                <a href="admin_servicios.jsp" class="btn-cancelar">Cancelar</a>
            </div>
        </form>
    </div>
</body>
</html>