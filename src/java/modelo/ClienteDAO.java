/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public boolean insertar(Cliente c) {
        String sql = "INSERT INTO clientes (dni, nombre, apellido, telefono, email, direccion) VALUES (?,?,?,?,?,?)";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, c.getDni());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getApellido());
            ps.setString(4, c.getTelefono());
            ps.setString(5, c.getEmail());
            ps.setString(6, c.getDireccion());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        }
    }

    public boolean actualizar(Cliente c) {
        String sql = "UPDATE clientes SET nombre=?, apellido=?, telefono=?, email=?, direccion=? WHERE dni=?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getApellido());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getDireccion());
            ps.setString(6, c.getDni());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        }
    }

    public boolean eliminar(String dni) {
        String sql = "DELETE FROM clientes WHERE dni = ?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, dni);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        }
    }

    public Cliente buscarPorDni(String dni) {
        String sql = "SELECT dni, nombre, apellido, telefono, email, direccion FROM clientes WHERE dni = ?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Cliente(
                        rs.getString("dni"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("telefono"),
                        rs.getString("email"),
                        rs.getString("direccion")
                    );
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Cliente> listar(String q) {
        List<Cliente> list = new ArrayList<>();
        // Si hay término de búsqueda, intenta FULLTEXT, si no, lista todo
        String base = "SELECT dni, nombre, apellido, telefono, email, direccion FROM clientes";
        String sql = (q == null || q.isBlank())
                ? base + " ORDER BY apellido, nombre"
                : base + " WHERE MATCH(dni, nombre, apellido, telefono, email, direccion) AGAINST (? IN NATURAL LANGUAGE MODE) "
                  + "OR dni LIKE ? OR nombre LIKE ? OR apellido LIKE ? OR telefono LIKE ? OR email LIKE ? OR direccion LIKE ? "
                  + "ORDER BY apellido, nombre";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            if (q != null && !q.isBlank()) {
                String like = "%" + q + "%";
                ps.setString(1, q);
                ps.setString(2, like);
                ps.setString(3, like);
                ps.setString(4, like);
                ps.setString(5, like);
                ps.setString(6, like);
                ps.setString(7, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Cliente(
                        rs.getString("dni"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("telefono"),
                        rs.getString("email"),
                        rs.getString("direccion")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean existe(String dni) {
        String sql = "SELECT 1 FROM clientes WHERE dni = ?";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    
    public List<HistorialCliente> listarHistorial(String nombre, String origen, String desde, String hasta) {
    List<HistorialCliente> out = new ArrayList<>();

    // Como tu BD solo tiene 'clientes' y 'vehiculos', armamos un "historial"
    // a partir de vehículos por cliente. Campos comerciales (origen/ref/monto/metodo)
    // se colocan como placeholders personalizables.
    // Si luego agregas tablas de pagos/ordenes, aquí haces el JOIN real.

    String sql = "SELECT c.dni, c.nombre, c.apellido, v.placa, "
               + "DATE_FORMAT(CURDATE(), '%Y-%m-%d') AS fecha_hoy "
               + "FROM clientes c "
               + "LEFT JOIN vehiculos v ON v.dni_cliente = c.dni ";

    // filtro por 'nombre'
    List<String> conds = new ArrayList<>();
    if (nombre != null && !nombre.isBlank()) {
        conds.add("(c.nombre LIKE ? OR c.apellido LIKE ?)");
    }
    // (Por ahora 'origen', 'desde', 'hasta' no aplican a tablas reales; se pueden
    // usar cuando tengas las columnas/tabla correspondiente.)
    if (!conds.isEmpty()) {
        sql += " WHERE " + String.join(" AND ", conds);
    }
    sql += " ORDER BY c.apellido, c.nombre, v.placa";

    try (Connection cn = Conexion.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        int i = 1;
        if (nombre != null && !nombre.isBlank()) {
            String like = "%" + nombre + "%";
            ps.setString(i++, like);
            ps.setString(i++, like);
        }
        try (ResultSet rs = ps.executeQuery()) {
            int idx = 1;
            while (rs.next()) {
                String nom = rs.getString("nombre") + " " + rs.getString("apellido");
                String placa = rs.getString("placa");
                // Placeholders "bonitos" para que tu UI luzca bien
                String _origen = (placa == null ? "Web" : "Orden");
                String _ref    = (placa == null ? "WB-" : "OR-") + String.format("%04d", idx + 200);
                String _fecha  = rs.getString("fecha_hoy");
                double _monto  = (placa == null ? 0 : 150 + (idx % 5) * 25); // deco
                String _metodo = (idx % 3 == 0 ? "Tarjeta" : (idx % 2 == 0 ? "Yape" : "Efectivo"));

                out.add(new HistorialCliente(
                    idx, nom, _origen, _ref, (placa == null ? "—" : placa), _fecha, _monto, _metodo
                ));
                idx++;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return out;
}

}
