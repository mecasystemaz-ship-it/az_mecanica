package modelo.DAO;

import modelo.Producto;
import util.ConexionDB;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class ProductoDAO {

    private Connection getConnection() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    private Producto mapResultSetToProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setCodProducto(rs.getInt("cod_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setCategoria(rs.getString("categoria"));
        p.setCantInicial(rs.getInt("cant_inicial"));
        p.setCosto(rs.getBigDecimal("costo"));
        p.setIdProveedor(rs.getString("id_proveedor"));
        return p;
    }

    // CREATE
    public boolean agregarProducto(Producto p) {
        String SQL = "INSERT INTO Producto (nombre, categoria, cant_inicial, costo, id_proveedor) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getCategoria());
            ps.setInt(3, p.getCantInicial());
            ps.setBigDecimal(4, p.getCosto());
            ps.setString(5, p.getIdProveedor());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ (todos)
    public List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();
        String SQL = "SELECT * FROM Producto ORDER BY nombre ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapResultSetToProducto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // READ (por ID)
    public Producto obtenerProductoPorId(int id) {
        Producto p = null;
        String SQL = "SELECT * FROM Producto WHERE cod_producto=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = mapResultSetToProducto(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // UPDATE
    public boolean actualizarProducto(Producto p) {
        String SQL = "UPDATE Producto SET nombre=?, categoria=?, cant_inicial=?, costo=?, id_proveedor=? WHERE cod_producto=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getCategoria());
            ps.setInt(3, p.getCantInicial());
            ps.setBigDecimal(4, p.getCosto());
            ps.setString(5, p.getIdProveedor());
            ps.setInt(6, p.getCodProducto());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    public boolean eliminarProducto(int id) {
        String SQL = "DELETE FROM Producto WHERE cod_producto=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
