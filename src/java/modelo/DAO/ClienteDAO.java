// Archivo: src/main/java/modelo/DAO/ClienteDAO.java
package modelo.DAO;

import modelo.Cliente;
import util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    private Connection getConnection() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    /**
     * Mapea un ResultSet a un objeto Cliente básico.
     */
    private Cliente mapResultSetToCliente(ResultSet rs) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setDni(rs.getString("dni"));
        cliente.setNombres(rs.getString("nombres"));
        cliente.setApellidos(rs.getString("apellidos"));
        cliente.setTelefono(rs.getString("telefono"));
        cliente.setCorreo(rs.getString("correo"));
        cliente.setDireccion(rs.getString("direccion"));
        // Nota: Los campos origen, placa, etc., no se llenan aquí porque no vienen de la tabla 'clientes'
        return cliente;
    }

    // C: CREATE (MANTENIDO ORIGINAL)
    public boolean agregarCliente(Cliente cliente) {
        String SQL = "INSERT INTO clientes (dni, nombres, apellidos, telefono, correo, direccion) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, cliente.getDni());
            ps.setString(2, getSafeString(cliente.getNombres()));
            ps.setString(3, getSafeString(cliente.getApellidos()));
            ps.setString(4, getSafeString(cliente.getTelefono()));
            ps.setString(5, getSafeString(cliente.getCorreo()));
            ps.setString(6, getSafeString(cliente.getDireccion()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error SQL al intentar agregar cliente: " + e.getMessage());
            return false;
        }
    }

    // R: READ (MODIFICADO: Ahora trae conteo de autos y citas)
    public List<Cliente> listarClientes() {
        List<Cliente> clientes = new ArrayList<>();
        
        // ⚡ CAMBIO AQUÍ: Agregamos subconsultas para contar vehículos y citas
        String SQL = "SELECT c.*, " +
                     "(SELECT COUNT(*) FROM vehiculo v WHERE v.dni_cliente = c.dni) AS cant_vehiculos, " +
                     "(SELECT COUNT(*) FROM Cita ci WHERE ci.dni_cliente = c.dni) AS cant_citas " +
                     "FROM clientes c " +
                     "ORDER BY c.apellidos, c.nombres ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Usamos el mapeo base
                Cliente c = mapResultSetToCliente(rs);
                
                // Llenamos los datos extra para el dashboard
                c.setTotalVehiculos(rs.getInt("cant_vehiculos"));
                c.setTotalCitas(rs.getInt("cant_citas"));
                
                clientes.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes con estadísticas: " + e.getMessage());
            e.printStackTrace();
        }
        return clientes;
    }

    // R: READ por DNI (MANTENIDO ORIGINAL)
    public Cliente obtenerClientePorDni(String dni) {
        String SQL = "SELECT * FROM clientes WHERE dni = ?";
        Cliente cliente = null;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = mapResultSetToCliente(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente por DNI: " + e.getMessage());
        }
        return cliente;
    }

    // U: UPDATE (MANTENIDO ORIGINAL)
    public boolean actualizarCliente(Cliente cliente) {
        String SQL = "UPDATE clientes SET nombres=?, apellidos=?, telefono=?, correo=?, direccion=? WHERE dni=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, getSafeString(cliente.getNombres()));
            ps.setString(2, getSafeString(cliente.getApellidos()));
            ps.setString(3, getSafeString(cliente.getTelefono()));
            ps.setString(4, getSafeString(cliente.getCorreo()));
            ps.setString(5, getSafeString(cliente.getDireccion()));
            ps.setString(6, cliente.getDni());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizarCliente: " + e.getMessage());
            return false;
        }
    }

    // D: DELETE (MANTENIDO ORIGINAL)
    public boolean eliminarCliente(String dni) {
        String SQL = "DELETE FROM clientes WHERE dni = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, dni);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminarCliente: " + e.getMessage());
            return false;
        }
    }

    public boolean existeClientePorDni(String dni) {
        String SQL = "SELECT 1 FROM clientes WHERE dni = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    private String getSafeString(String input) {
        return input != null ? input : "";
    }
}