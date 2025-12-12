package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.DAO.VehiculoDAO;
import modelo.Vehiculo;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/VehiculoAjax")
public class VehiculoAjaxServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehiculoDAO = new VehiculoDAO();
    }

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String dniCliente = request.getParameter("dni");

    if (dniCliente == null || dniCliente.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("[]");
        return;
    }

    List<Vehiculo> vehiculos = vehiculoDAO.listarVehiculosPorCliente(dniCliente);
    
    // Serialización simple a Map (esto ya lo tienes)
    List<Map<String, String>> vehiculosSimples = vehiculos.stream()
        .map(v -> Map.of("placa", v.getPlaca(), "marca", v.getMarca()))
        .collect(Collectors.toList());

    Gson gson = new Gson();
    String json = gson.toJson(vehiculosSimples);

    // 💡 CAMBIO CLAVE: Enviamos la respuesta usando OutputStream binario para evitar la corrupción del Writer
    
    // 1. Configurar la respuesta
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // 2. Convertir el JSON a bytes usando UTF-8 (esto elimina cualquier BOM en el String)
    byte[] jsonBytes = json.getBytes("UTF-8");
    
    // 3. Establecer la longitud del contenido
    response.setContentLength(jsonBytes.length);
    
    // 4. Escribir los bytes directamente en el flujo de salida
    response.getOutputStream().write(jsonBytes);
    response.getOutputStream().flush();
}
}
