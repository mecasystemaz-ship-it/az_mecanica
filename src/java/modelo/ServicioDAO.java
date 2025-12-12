/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ServicioDAO {

    public List<Servicio> listar(String q) {
        List<Servicio> lista = new ArrayList<>();
        String sql = """
            SELECT id, titulo, tipo, dni_cliente, placa_vehiculo, origen, numero_ref, fecha, 
                   monto_total, metodo_pago, estado, observaciones
            FROM servicios
            %s
            ORDER BY fecha DESC, id DESC
        """.formatted((q != null && !q.isBlank())
                ? "WHERE titulo LIKE ? OR dni_cliente LIKE ? OR placa_vehiculo LIKE ? OR origen LIKE ? OR numero_ref LIKE ?"
                : "");

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            if (q != null && !q.isBlank()) {
                String like = "%" + q.trim() + "%";
                ps.setString(1, like); // titulo
                ps.setString(2, like); // dni_cliente
                ps.setString(3, like); // placa_vehiculo
                ps.setString(4, like); // origen
                ps.setString(5, like); // numero_ref
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(fromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Servicio buscarPorId(int id) {
        String sql = """
            SELECT id, titulo, tipo, dni_cliente, placa_vehiculo, origen, numero_ref, fecha, 
                   monto_total, metodo_pago, estado, observaciones
            FROM servicios WHERE id = ?
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return fromRS(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Servicio s) {
        String sql = """
            INSERT INTO servicios
            (titulo, tipo, dni_cliente, placa_vehiculo, origen, numero_ref, fecha, monto_total, 
             metodo_pago, estado, observaciones)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            bindForInsert(ps, s);
            int rows = ps.executeUpdate();
            if (rows == 1) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) s.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            // ojo con UNIQUE numero_ref
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Servicio s) {
        String sql = """
            UPDATE servicios SET
              titulo=?, tipo=?, dni_cliente=?, placa_vehiculo=?, origen=?, numero_ref=?, fecha=?, 
              monto_total=?, metodo_pago=?, estado=?, observaciones=?
            WHERE id=?
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            bindForUpdate(ps, s);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM servicios WHERE id = ?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            // Si existen servicio_items con FK y ON DELETE CASCADE en tabla -> se borran solos
            e.printStackTrace();
            return false;
        }
    }

    /* ==== helpers ==== */

    private Servicio fromRS(ResultSet rs) throws SQLException {
        return new Servicio(
            rs.getInt("id"),
            rs.getString("titulo"),
            rs.getString("tipo"),
            rs.getString("dni_cliente"),
            rs.getString("placa_vehiculo"),
            rs.getString("origen"),
            rs.getString("numero_ref"),
            rs.getDate("fecha"), // java.sql.Date
            rs.getBigDecimal("monto_total"),
            rs.getString("metodo_pago"),
            rs.getString("estado"),
            rs.getString("observaciones")
        );
    }

    private void bindForInsert(PreparedStatement ps, Servicio s) throws SQLException {
        ps.setString(1, s.getTitulo());
        ps.setString(2, s.getTipo());
        ps.setString(3, s.getDniCliente());
        ps.setString(4, s.getPlacaVehiculo());
        ps.setString(5, s.getOrigen());
        ps.setString(6, s.getNumeroRef());
        if (s.getFecha() == null) ps.setNull(7, Types.DATE); else ps.setDate(7, s.getFecha());
        if (s.getMontoTotal() == null) ps.setBigDecimal(8, new BigDecimal("0.00")); else ps.setBigDecimal(8, s.getMontoTotal());
        ps.setString(9, s.getMetodoPago());
        ps.setString(10, s.getEstado());
        ps.setString(11, s.getObservaciones());
    }

    private void bindForUpdate(PreparedStatement ps, Servicio s) throws SQLException {
        ps.setString(1, s.getTitulo());
        ps.setString(2, s.getTipo());
        ps.setString(3, s.getDniCliente());
        ps.setString(4, s.getPlacaVehiculo());
        ps.setString(5, s.getOrigen());
        ps.setString(6, s.getNumeroRef());
        if (s.getFecha() == null) ps.setNull(7, Types.DATE); else ps.setDate(7, s.getFecha());
        if (s.getMontoTotal() == null) ps.setBigDecimal(8, new BigDecimal("0.00")); else ps.setBigDecimal(8, s.getMontoTotal());
        ps.setString(9, s.getMetodoPago());
        ps.setString(10, s.getEstado());
        ps.setString(11, s.getObservaciones());
        ps.setInt(12, s.getId());
    }
}
