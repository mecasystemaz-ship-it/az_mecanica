// Archivo: src/main/java/modelo/DAO/ProformaDAO.java
package modelo.DAO;

import modelo.Proforma;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import util.ConexionDB;

public class ProformaDAO {

    private Connection obtenerConexion() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    // ----------------------------------------------------
    // --- Consultas SQL CORREGIDAS (Tabla 'clientes') ---
    // ----------------------------------------------------
    private static final String SQL_SELECT_ALL
            = "SELECT p.id_proforma, p.fecha, p.id_cliente, p.monto_estimado, p.estado, c.nombres, c.apellidos "
            // ⭐ AJUSTADO: JOIN a la tabla 'clientes' (en plural)
            + "FROM proforma p JOIN clientes c ON p.id_cliente = c.dni ORDER BY p.fecha DESC";

    private static final String SQL_INSERT
            = "INSERT INTO proforma (id_proforma, id_cliente, monto_estimado, estado) VALUES (?, ?, ?, ?)";

    private static final String SQL_UPDATE
            = "UPDATE proforma SET id_cliente=?, monto_estimado=?, estado=? WHERE id_proforma=?";

    private static final String SQL_DELETE
            = "DELETE FROM proforma WHERE id_proforma=?";

    private static final String SQL_SELECT_BY_ID
            = "SELECT p.id_proforma, p.fecha, p.id_cliente, p.monto_estimado, p.estado, c.nombres, c.apellidos "
            // ⭐ AJUSTADO: JOIN a la tabla 'clientes' (en plural)
            + "FROM proforma p JOIN clientes c ON p.id_cliente = c.dni WHERE p.id_proforma=?";

    // ----------------------------------------------------
    // --- Métodos CRUD ---
    // ----------------------------------------------------
    /**
     * Lista todas las proformas, incluyendo el nombre completo del cliente.
     */
    public List<Proforma> listar() {
        List<Proforma> proformas = new ArrayList<>();
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_SELECT_ALL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Proforma p = new Proforma();
                p.setIdProforma(rs.getString("id_proforma"));
                p.setFecha(rs.getDate("fecha"));
                p.setIdCliente(rs.getString("id_cliente"));
                p.setMontoEstimado(rs.getDouble("monto_estimado"));
                p.setEstado(rs.getString("estado"));

                // Concatenar nombres y apellidos
                String nombres = rs.getString("nombres");
                String apellidos = rs.getString("apellidos");
                p.setNombreCliente(nombres + " " + apellidos);

                proformas.add(p);
            }
        } catch (SQLException e) {
            // Esto imprimirá el error (ej: Table 'clientes' not found) si hubiera otro problema.
            e.printStackTrace(System.out);
        }
        return proformas;
    }

    /**
     * Busca una proforma por su ID (String).
     */
    public Proforma buscarPorId(String id) {
        Proforma p = null;
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_SELECT_BY_ID)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Proforma();
                    p.setIdProforma(rs.getString("id_proforma"));
                    p.setFecha(rs.getDate("fecha"));
                    p.setIdCliente(rs.getString("id_cliente"));
                    p.setMontoEstimado(rs.getDouble("monto_estimado"));
                    p.setEstado(rs.getString("estado"));

                    String nombres = rs.getString("nombres");
                    String apellidos = rs.getString("apellidos");
                    p.setNombreCliente(nombres + " " + apellidos);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        return p;
    }

    // Los métodos insertar, actualizar y eliminar se mantienen igual
    public boolean insertar(Proforma proforma) {
        // ... (código insert)
        int filasAfectadas = 0;
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            ps.setString(1, proforma.getIdProforma());
            ps.setString(2, proforma.getIdCliente());
            ps.setDouble(3, proforma.getMontoEstimado());
            ps.setString(4, proforma.getEstado());
            filasAfectadas = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        return filasAfectadas > 0;
    }

    public boolean actualizar(Proforma proforma) {
        // ... (código update)
        int filasAfectadas = 0;
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, proforma.getIdCliente());
            ps.setDouble(2, proforma.getMontoEstimado());
            ps.setString(3, proforma.getEstado());
            ps.setString(4, proforma.getIdProforma());
            filasAfectadas = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        return filasAfectadas > 0;
    }

    public boolean eliminar(String id) {
        // ... (código delete)
        int filasAfectadas = 0;
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {
            ps.setString(1, id);
            filasAfectadas = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        return filasAfectadas > 0;
    }
    
    // En ProformaDAO.java

private static final String SQL_SELECT_BY_STATE = 
    "SELECT p.id_proforma, p.fecha, p.id_cliente, p.monto_estimado, p.estado, c.nombres, c.apellidos " +
    "FROM proforma p JOIN clientes c ON p.id_cliente = c.dni WHERE p.estado = ?";

public List<Proforma> listarPorEstado(String estado) {
    List<Proforma> lista = new ArrayList<>();
    try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(SQL_SELECT_BY_STATE)) {
        ps.setString(1, estado);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Proforma p = new Proforma();
                p.setIdProforma(rs.getString("id_proforma"));
                p.setFecha(rs.getDate("fecha"));
                p.setIdCliente(rs.getString("id_cliente"));
                p.setMontoEstimado(rs.getDouble("monto_estimado"));
                p.setEstado(rs.getString("estado"));
                p.setNombreCliente(rs.getString("nombres") + " " + rs.getString("apellidos"));
                lista.add(p);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}

// En ProformaDAO.java

// 1. Listar pendientes para el select
public List<Proforma> listarPendientesDePago() {
    List<Proforma> lista = new ArrayList<>();
    String sql = "SELECT p.id_proforma, p.monto_estimado, c.nombres, c.apellidos " +
                 "FROM proforma p " +
                 "JOIN clientes c ON p.id_cliente = c.dni " +
                 "WHERE p.estado = 'PENDIENTE' OR p.estado = 'ACEPTADA'";

    try (Connection conn = ConexionDB.getInstancia().getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Proforma p = new Proforma();
            p.setIdProforma(rs.getString("id_proforma"));
            p.setMontoEstimado(rs.getDouble("monto_estimado"));
            p.setNombreCliente(rs.getString("nombres") + " " + rs.getString("apellidos"));
            lista.add(p);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return lista;
}

// 2. Cambiar estado a PAGADO
public boolean cambiarEstado(String idProforma, String nuevoEstado) {
    String sql = "UPDATE proforma SET estado = ? WHERE id_proforma = ?";
    try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, nuevoEstado);
        ps.setString(2, idProforma);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) { return false; }
}
}
