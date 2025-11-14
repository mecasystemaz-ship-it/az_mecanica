/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServicioDAO {
    // Constantes de la BD (ajustar si es necesario)
    private static final String URL = "jdbc:mysql://localhost:3306/az_mecanica";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    // Clase interna simple para el catálogo
    public static class CatalogoServicio {
        public int id;
        public String nombre;
        public CatalogoServicio(int id, String nombre) {
            this.id = id;
            this.nombre = nombre;
        }
    }
    
    // Clase interna simple para el listado de servicios solicitados
    public static class ServicioSolicitado {
        public int id;
        public String clienteNombre;
        public String vehiculoModelo; // Marca y Modelo
        public String placa;
        public String servicioNombre;
        public String estado;
    }

    // =========================================================================
    // 1. Obtiene el catálogo de servicios
    // =========================================================================
    public static List<CatalogoServicio> obtenerCatalogoServicios() {
        List<CatalogoServicio> catalogo = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            // Usamos los campos correctos: id_servicio, nombre_servicio
            String sql = "SELECT id_servicio, nombre_servicio FROM servicios_catalogo ORDER BY nombre_servicio";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                catalogo.add(new CatalogoServicio(rs.getInt("id_servicio"), rs.getString("nombre_servicio")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Lógica de cierre de recursos...
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return catalogo;
    }
    
    // =========================================================================
    // 2. Obtiene el ID del cliente por su nombre de USUARIO
    // =========================================================================
    public static int obtenerClienteIdPorUsuario(String usuario) {
        // (Mismo método que antes: obtener el ID del cliente)
        // ... (código omitido por ser el mismo de la respuesta anterior)
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int clienteId = -1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            String sql = "SELECT id FROM usuarios WHERE usuario = ?"; 
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usuario);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                clienteId = rs.getInt("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return clienteId;
    }
    
    // =========================================================================
    // 3. (NUEVO) Guarda el vehículo y retorna su ID
    // =========================================================================
    public static int guardarVehiculoYObtenerId(int clienteId, String marca, String modelo, String placa) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int vehiculoId = -1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Intentar buscar vehículo existente por placa
            String sqlSelect = "SELECT id_vehiculo FROM vehiculos WHERE placa = ?";
            pstmt = conn.prepareStatement(sqlSelect);
            pstmt.setString(1, placa);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                vehiculoId = rs.getInt("id_vehiculo");
                return vehiculoId;
            }
            
            // Si no existe, insertarlo
            String sqlInsert = "INSERT INTO vehiculos (cliente_id, placa, marca, modelo) VALUES (?, ?, ?, ?)";
            // Statement.RETURN_GENERATED_KEYS es necesario para obtener el ID generado
            pstmt = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, clienteId);
            pstmt.setString(2, placa);
            pstmt.setString(3, marca);
            pstmt.setString(4, modelo);
            
            if (pstmt.executeUpdate() > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    vehiculoId = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return vehiculoId;
    }

    // =========================================================================
    // 4. Guarda el nuevo servicio solicitado
    // =========================================================================
    public static boolean guardarServicioSolicitado(int vehiculoId, int servicioId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Inserta en servicios_solicitados
            String sql = "INSERT INTO servicios_solicitados (vehiculo_id, servicio_id) VALUES (?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, vehiculoId);
            pstmt.setInt(2, servicioId); // ID del servicio

            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0; 

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            // Lógica de cierre de recursos...
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    // =========================================================================
    // 5. Lista todos los servicios solicitados (para la tabla del administrador)
    // =========================================================================
    public static List<ServicioSolicitado> listarServicios() {
        List<ServicioSolicitado> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            // Consulta que une usuarios -> vehiculos -> servicios_solicitados -> servicios_catalogo
            String sql = "SELECT ss.id, u.nombre, u.apellido, v.marca, v.modelo, v.placa, cs.nombre_servicio, ss.estado " +
                         "FROM servicios_solicitados ss " +
                         "JOIN vehiculos v ON ss.vehiculo_id = v.id_vehiculo " +
                         "JOIN usuarios u ON v.cliente_id = u.id " +
                         "JOIN servicios_catalogo cs ON ss.servicio_id = cs.id_servicio " +
                         "ORDER BY ss.fecha_solicitud DESC";
                         
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ServicioSolicitado s = new ServicioSolicitado();
                s.id = rs.getInt("id");
                s.clienteNombre = rs.getString("nombre") + " " + (rs.getString("apellido") != null ? rs.getString("apellido") : "");
                s.vehiculoModelo = rs.getString("marca") + " " + rs.getString("modelo"); // Marca y Modelo
                s.placa = rs.getString("placa");
                s.servicioNombre = rs.getString("nombre_servicio");
                s.estado = rs.getString("estado");
                lista.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
             try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return lista;
    }
    
    // =========================================================================
    // 6. Método para actualizar el estado del servicio
    // =========================================================================
    public static boolean actualizarEstadoServicio(int servicioId, String nuevoEstado) {
        // (Mismo método que antes)
        // ... (código omitido)
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            String sql = "UPDATE servicios_solicitados SET estado = ? WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, servicioId);

            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0; 

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
             try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
