// Archivo: src/main/java/dao/ProveedorDAO.java
package modelo.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Proveedor;
import util.ConexionDB;

public class ProveedorDAO {

    private Connection conn;

    public ProveedorDAO() {
        try {
            conn = ConexionDB.getInstancia().getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Listar todos los proveedores
    public List<Proveedor> listar() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM Proveedor";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setRuc(rs.getString("ruc"));
                p.setNombre(rs.getString("nombre"));
                p.setTelefono(rs.getString("telefono"));
                p.setEmail(rs.getString("email"));
                p.setDireccion(rs.getString("direccion"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Registrar proveedor
    public boolean registrar(Proveedor p) {
        String sql = "INSERT INTO Proveedor (ruc, nombre, telefono, email, direccion) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getRuc());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getEmail());
            ps.setString(5, p.getDireccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Modificar proveedor
    public boolean modificar(Proveedor p) {
        String sql = "UPDATE Proveedor SET nombre=?, telefono=?, email=?, direccion=? WHERE ruc=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getTelefono());
            ps.setString(3, p.getEmail());
            ps.setString(4, p.getDireccion());
            ps.setString(5, p.getRuc());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Eliminar proveedor
    public boolean eliminar(String ruc) {
        String sql = "DELETE FROM Proveedor WHERE ruc=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ruc);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Obtener proveedor por RUC
    public Proveedor obtenerPorRUC(String ruc) {
        String sql = "SELECT * FROM Proveedor WHERE ruc=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ruc);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Proveedor(
                            rs.getString("ruc"),
                            rs.getString("nombre"),
                            rs.getString("telefono"),
                            rs.getString("email"),
                            rs.getString("direccion")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
