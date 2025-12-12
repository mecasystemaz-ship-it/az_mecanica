// Archivo: src/main/java/modelo/DAO/ServicioDAO.java
package modelo.DAO;

import modelo.Servicio;
import util.ConexionDB;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServicioDAO {

    /**
     * Obtiene una conexión a la base de datos.
     */
    private Connection getConnection() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    /**
     * Mapea un ResultSet a un objeto Servicio.
     */
    private Servicio mapResultSetToServicio(ResultSet rs) throws SQLException {
        Servicio servicio = new Servicio();
        servicio.setIdServicio(rs.getInt("id_servicio"));
        servicio.setNombre(rs.getString("nombre"));
        servicio.setCategoria(rs.getString("categoria"));
        servicio.setDescripcion(rs.getString("descripcion"));

        // Uso de getBigDecimal para el precio (es más seguro que getDouble)
        servicio.setPrecio(rs.getBigDecimal("precio"));
        servicio.setTiempoEstimado(rs.getString("tiempo_estimado"));
        return servicio;
    }

    // C: CREATE (Agregar un nuevo servicio)
    public boolean agregarServicio(Servicio servicio) {
        String SQL = "INSERT INTO Servicio (nombre, categoria, descripcion, precio, tiempo_estimado) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, servicio.getNombre());
            ps.setString(2, servicio.getCategoria());
            ps.setString(3, servicio.getDescripcion());

            // Usamos setBigDecimal para precisión en el precio
            ps.setBigDecimal(4, servicio.getPrecio());
            ps.setString(5, servicio.getTiempoEstimado());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error SQL al intentar agregar servicio. Causa: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // R: READ (Obtener todos los servicios)
    public List<Servicio> listarServicios() {
        List<Servicio> servicios = new ArrayList<>();
        String SQL = "SELECT id_servicio, nombre, categoria, descripcion, precio, tiempo_estimado FROM Servicio ORDER BY nombre ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                servicios.add(mapResultSetToServicio(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar servicios: " + e.getMessage());
            e.printStackTrace();
        }
        return servicios;
    }

    // R: READ (Obtener un servicio por ID)
    public Servicio obtenerServicioPorId(int id) {
        String SQL = "SELECT id_servicio, nombre, categoria, descripcion, precio, tiempo_estimado FROM Servicio WHERE id_servicio = ?";
        Servicio servicio = null;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    servicio = mapResultSetToServicio(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener servicio por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return servicio;
    }

    // U: UPDATE (Actualizar un servicio)
    public boolean actualizarServicio(Servicio servicio) {
        String SQL = "UPDATE Servicio SET nombre=?, categoria=?, descripcion=?, precio=?, tiempo_estimado=? WHERE id_servicio=?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, servicio.getNombre());
            ps.setString(2, servicio.getCategoria());
            ps.setString(3, servicio.getDescripcion());
            ps.setBigDecimal(4, servicio.getPrecio());
            ps.setString(5, servicio.getTiempoEstimado());
            ps.setInt(6, servicio.getIdServicio()); // El ID va en la condición WHERE

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error SQL al intentar actualizar servicio. Causa: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // D: DELETE (Eliminar un servicio por ID)
    public boolean eliminarServicio(int id) {
        String SQL = "DELETE FROM Servicio WHERE id_servicio = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar servicio: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
