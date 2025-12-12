/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {
    
    public Cita buscarPorId(long id) {
    String sql = """
        SELECT c.id, c.fecha, c.hora, c.tipo, c.estado, c.notas,
               c.id_cliente, c.id_empleado,
               CONCAT(cl.nombre,' ',cl.apellido) AS cliente_nombre
        FROM citas c
        JOIN clientes cl ON cl.dni = c.id_cliente
        WHERE c.id = ?
    """;
    try (Connection cn = Conexion.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setLong(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Cita c = new Cita();
                c.setId(rs.getLong("id"));
                c.setFecha(rs.getDate("fecha").toLocalDate());  // yyyy-MM-dd
                c.setHora(rs.getTime("hora").toLocalTime());    // HH:mm:ss
                c.setTipo(rs.getString("tipo"));
                c.setEstado(rs.getString("estado"));
                c.setNotas(rs.getString("notas"));
                c.setIdCliente(rs.getString("id_cliente"));
                int emp = rs.getInt("id_empleado");
                c.setIdEmpleado(rs.wasNull() ? null : emp);
                c.setClienteNombre(rs.getString("cliente_nombre"));
                return c;
            }
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

    public List<Cita> listarPorRango(LocalDate ini, LocalDate fin) {
        String sql = """
            SELECT c.id, c.fecha, c.hora, c.tipo, c.estado, c.notas, c.id_cliente, c.id_empleado,
                   CONCAT(cl.nombre,' ',cl.apellido) AS cliente_nombre
            FROM citas c
            JOIN clientes cl ON cl.dni = c.id_cliente
            WHERE c.fecha BETWEEN ? AND ?
            ORDER BY c.fecha, c.hora
        """;
        List<Cita> out = new ArrayList<>();
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(ini));
            ps.setDate(2, Date.valueOf(fin));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = new Cita();
                    c.setId(rs.getLong("id"));
                    c.setFecha(rs.getDate("fecha").toLocalDate());
                    c.setHora(rs.getTime("hora").toLocalTime());
                    c.setTipo(rs.getString("tipo"));
                    c.setEstado(rs.getString("estado"));
                    c.setNotas(rs.getString("notas"));
                    c.setIdCliente(rs.getString("id_cliente"));
                    int emp = rs.getInt("id_empleado");
                    c.setIdEmpleado(rs.wasNull() ? null : emp);
                    c.setClienteNombre(rs.getString("cliente_nombre"));
                    out.add(c);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public boolean crear(Cita c) {
        String sql = "INSERT INTO citas (fecha,hora,tipo,estado,notas,id_cliente,id_empleado) VALUES (?,?,?,?,?,?,?)";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(c.getFecha()));
            ps.setTime(2, Time.valueOf(c.getHora()));
            ps.setString(3, c.getTipo());
            ps.setString(4, c.getEstado() == null ? "PENDIENTE" : c.getEstado());
            ps.setString(5, c.getNotas());
            ps.setString(6, c.getIdCliente());
            if (c.getIdEmpleado() == null) ps.setNull(7, Types.INTEGER); else ps.setInt(7, c.getIdEmpleado());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean cancelar(long id) {
        String sql = "UPDATE citas SET estado='CANCELADA' WHERE id=?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Opcionales (por si luego agregas editar/confirmar):
    public boolean confirmar(long id) {
        String sql = "UPDATE citas SET estado='CONFIRMADA' WHERE id=?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean actualizar(Cita c) {
        String sql = "UPDATE citas SET fecha=?, hora=?, tipo=?, notas=?, id_cliente=?, id_empleado=? WHERE id=?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(c.getFecha()));
            ps.setTime(2, Time.valueOf(c.getHora()));
            ps.setString(3, c.getTipo());
            ps.setString(4, c.getNotas());
            ps.setString(5, c.getIdCliente());
            if (c.getIdEmpleado() == null) ps.setNull(6, Types.INTEGER); else ps.setInt(6, c.getIdEmpleado());
            ps.setLong(7, c.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
