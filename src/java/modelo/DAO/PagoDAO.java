package modelo.DAO;

import modelo.Pago;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {

    // Método auxiliar para obtener conexión
    private Connection obtenerConexion() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    // ========================================================================
    // 1. REGISTRAR UN NUEVO PAGO (INSERT)
    // ========================================================================
    public boolean insertar(Pago p) {
        String sql = "INSERT INTO pagos (origen, id_referencia, monto, metodo_pago, fecha, notas) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = obtenerConexion(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getOrigen());      // "CITA" o "PROFORMA"
            ps.setString(2, p.getIdReferencia());// "104" o "PROF-001"
            ps.setDouble(3, p.getMonto());
            ps.setString(4, p.getMetodoPago());
            ps.setDate(5, p.getFecha());
            ps.setString(6, p.getNotas());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al insertar pago: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ========================================================================
    // 2. LISTAR HISTORIAL DE PAGOS DE CITAS (JOINs complejos)
    // ========================================================================
    public List<Pago> listarPagosCitas() {
        List<Pago> lista = new ArrayList<>();
        
        // Hacemos JOIN con Cita, Clientes y Servicio para mostrar nombres reales en la tabla
        String sql = "SELECT p.*, " +
                     "c.hora, c.placa_vehiculo, " +
                     "cli.nombres, cli.apellidos, " +
                     "s.nombre AS nombre_servicio " +
                     "FROM pagos p " +
                     "JOIN cita c ON p.id_referencia = c.id_cita " + // Relacionamos ID pago con ID cita
                     "JOIN clientes cli ON c.dni_cliente = cli.dni " +
                     "JOIN servicio s ON c.id_servicio = s.id_servicio " +
                     "WHERE p.origen = 'CITA' " +
                     "ORDER BY p.fecha DESC, p.id_pago DESC";

        try (Connection conn = obtenerConexion(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pago p = new Pago();
                // Datos propios del Pago
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdReferencia(rs.getString("id_referencia"));
                p.setMonto(rs.getDouble("monto"));
                p.setMetodoPago(rs.getString("metodo_pago"));
                p.setFecha(rs.getDate("fecha"));
                p.setNotas(rs.getString("notas"));
                
                // Datos Auxiliares (Traídos por los JOINs)
                String nombreCompleto = rs.getString("nombres") + " " + (rs.getString("apellidos") != null ? rs.getString("apellidos") : "");
                p.setNombreCliente(nombreCompleto);
                
                p.setPlacaVehiculo(rs.getString("placa_vehiculo"));
                p.setNombreServicio(rs.getString("nombre_servicio"));
                p.setHoraCita(rs.getTime("hora"));

                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar pagos de citas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // ========================================================================
    // 3. LISTAR HISTORIAL DE PAGOS DE PROFORMAS
    // ========================================================================
    public List<Pago> listarPagosProformas() {
        List<Pago> lista = new ArrayList<>();
        
        // Asumiendo que tienes una tabla 'proforma' y 'clientes'
        String sql = "SELECT p.*, " +
                     "cli.nombres, cli.apellidos, " +
                     "pf.monto_estimado, pf.estado " +
                     "FROM pagos p " +
                     "JOIN proforma pf ON p.id_referencia = pf.id_proforma " +
                     "JOIN clientes cli ON pf.id_cliente = cli.dni " +
                     "WHERE p.origen = 'PROFORMA' " +
                     "ORDER BY p.fecha DESC, p.id_pago DESC";

        try (Connection conn = obtenerConexion(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pago p = new Pago();
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdReferencia(rs.getString("id_referencia"));
                p.setMonto(rs.getDouble("monto"));
                p.setMetodoPago(rs.getString("metodo_pago"));
                p.setFecha(rs.getDate("fecha"));
                
                // Datos Auxiliares
                String nombreCompleto = rs.getString("nombres") + " " + (rs.getString("apellidos") != null ? rs.getString("apellidos") : "");
                p.setNombreCliente(nombreCompleto);
                
                p.setMontoEstimado(rs.getDouble("monto_estimado")); // Para comparar lo pagado vs lo estimado
                p.setEstadoProforma(rs.getString("estado"));

                lista.add(p);
            }
        } catch (SQLException e) {
            // Si no tienes tabla proforma aún, esto fallará silenciosamente o puedes imprimir error
            System.err.println("Error al listar pagos de proformas: " + e.getMessage());
        }
        return lista;
    }
}