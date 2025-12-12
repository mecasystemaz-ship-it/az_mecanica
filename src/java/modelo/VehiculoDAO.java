/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehiculoDAO {

    public List<Vehiculo> listar(String q) {
        List<Vehiculo> lista = new ArrayList<>();
        String sql = """
            SELECT placa, marca, tipo, modelo, anio, color, combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_cliente
            FROM vehiculos
            %s
            ORDER BY placa
        """.formatted((q != null && !q.isBlank())
                ? "WHERE placa LIKE ? OR marca LIKE ? OR modelo LIKE ? OR dni_cliente LIKE ?" : "");

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            if (q != null && !q.isBlank()) {
                String like = "%" + q.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
                ps.setString(3, like);
                ps.setString(4, like);
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

    public Vehiculo buscarPorPlaca(String placa) {
        String sql = """
            SELECT placa, marca, tipo, modelo, anio, color, combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_cliente
            FROM vehiculos WHERE placa = ?
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, placa);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return fromRS(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Vehiculo v) {
        String sql = """
            INSERT INTO vehiculos
            (placa, marca, tipo, modelo, anio, color, combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_cliente)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            bind(ps, v);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            // Si ya existe PK -> error 1062 (duplicada)
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Vehiculo v) {
        String sql = """
            UPDATE vehiculos SET
            marca=?, tipo=?, modelo=?, anio=?, color=?, combustible=?, num_motor=?, kilometraje=?, soat=?, tarjeta_propietario=?, dni_cliente=?
            WHERE placa=?
        """;
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, v.getMarca());
            ps.setString(2, v.getTipo());
            ps.setString(3, v.getModelo());
            if (v.getAnio() == null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, v.getAnio());
            ps.setString(5, v.getColor());
            ps.setString(6, v.getCombustible());
            ps.setString(7, v.getNumMotor());
            if (v.getKilometraje() == null) ps.setNull(8, Types.INTEGER); else ps.setInt(8, v.getKilometraje());
            ps.setString(9, v.getSoat());
            ps.setString(10, v.getTarjetaPropietario());
            ps.setString(11, v.getDniCliente());
            ps.setString(12, v.getPlaca());

            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(String placa) {
        String sql = "DELETE FROM vehiculos WHERE placa = ?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, placa);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            // si hay FK inversa (no debería, ya hay ON DELETE CASCADE del cliente hacia vehículo)
            e.printStackTrace();
            return false;
        }
    }

    /* ==== helpers ==== */

    private Vehiculo fromRS(ResultSet rs) throws SQLException {
        return new Vehiculo(
            rs.getString("placa"),
            rs.getString("marca"),
            rs.getString("tipo"),
            rs.getString("modelo"),
            (rs.getObject("anio") == null) ? null : rs.getInt("anio"),
            rs.getString("color"),
            rs.getString("combustible"),
            rs.getString("num_motor"),
            (rs.getObject("kilometraje") == null) ? null : rs.getInt("kilometraje"),
            rs.getString("soat"),
            rs.getString("tarjeta_propietario"),
            rs.getString("dni_cliente")
        );
    }

    private void bind(PreparedStatement ps, Vehiculo v) throws SQLException {
        ps.setString(1, v.getPlaca());
        ps.setString(2, v.getMarca());
        ps.setString(3, v.getTipo());
        ps.setString(4, v.getModelo());
        if (v.getAnio() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, v.getAnio());
        ps.setString(6, v.getColor());
        ps.setString(7, v.getCombustible());
        ps.setString(8, v.getNumMotor());
        if (v.getKilometraje() == null) ps.setNull(9, Types.INTEGER); else ps.setInt(9, v.getKilometraje());
        ps.setString(10, v.getSoat());
        ps.setString(11, v.getTarjetaPropietario());
        ps.setString(12, v.getDniCliente());
    }
}
