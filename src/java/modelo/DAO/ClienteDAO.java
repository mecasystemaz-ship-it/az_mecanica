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

    /**
     * Obtiene una conexión a la base de datos. Asume que
     * ConexionDB.getInstancia().getConnection() está correctamente
     * implementado.
     *
     * @return Una instancia de Connection.
     * @throws SQLException Si la conexión falla.
     */
    private Connection getConnection() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    /**
     * Mapea un ResultSet a un objeto Cliente (10 campos).
     */
    private Cliente mapResultSetToCliente(ResultSet rs) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setDni(rs.getString("dni"));
        cliente.setNombres(rs.getString("nombres"));
        cliente.setApellidos(rs.getString("apellidos"));
        cliente.setTelefono(rs.getString("telefono"));
        cliente.setCorreo(rs.getString("correo"));
        cliente.setDireccion(rs.getString("direccion"));
        return cliente;
    }

    // C: CREATE (Agregar un nuevo cliente)
    public boolean agregarCliente(Cliente cliente) {
        String SQL = "INSERT INTO clientes (dni, nombres, apellidos, telefono, correo, direccion) VALUES (?, ?, ?, ?, ?, ?)";

        // Uso de try-with-resources para asegurar que los recursos se cierren automáticamente
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, cliente.getDni());
            ps.setString(2, getSafeString(cliente.getNombres()));
            ps.setString(3, getSafeString(cliente.getApellidos()));
            ps.setString(4, getSafeString(cliente.getTelefono()));
            ps.setString(5, getSafeString(cliente.getCorreo()));
            ps.setString(6, getSafeString(cliente.getDireccion()));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // Imprimir el error SQL real es VITAL para el diagnóstico
            System.err.println("Error SQL al intentar agregar cliente. Causa: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // R: READ (Obtener todos los clientes)
    public List<Cliente> listarClientes() {
        List<Cliente> clientes = new ArrayList<>();
        String SQL = "SELECT dni, nombres, apellidos, telefono, correo, direccion FROM clientes ORDER BY nombres, apellidos ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                clientes.add(mapResultSetToCliente(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
            e.printStackTrace();
        }
        return clientes;
    }

    // R: READ (Obtener un cliente por DNI)
    public Cliente obtenerClientePorDni(String dni) {
        String SQL = "SELECT dni, nombres, apellidos, telefono, correo, direccion FROM clientes WHERE dni = ?";
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
            e.printStackTrace();
        }
        return cliente;
    }

    // U: UPDATE (Actualizar un cliente por DNI)
    public boolean actualizarCliente(Cliente cliente) {
        // Se actualizan 9 campos, y el DNI se usa para la condición WHERE
        String SQL = "UPDATE clientes SET nombres=?, apellidos=?, telefono=?, correo=?, direccion=? WHERE dni=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            // 💡 CRÍTICO: Usar getSafeString
            ps.setString(1, getSafeString(cliente.getNombres()));
            ps.setString(2, getSafeString(cliente.getApellidos()));
            ps.setString(3, getSafeString(cliente.getTelefono()));
            ps.setString(4, getSafeString(cliente.getCorreo()));
            ps.setString(5, getSafeString(cliente.getDireccion()));

            

            // Condición WHERE (DNI, es el décimo parámetro)
            ps.setString(6, cliente.getDni());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error SQL al intentar actualizar cliente. Causa: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // D: DELETE (Eliminar un cliente por DNI)
    public boolean eliminarCliente(String dni) {
        String SQL = "DELETE FROM clientes WHERE dni = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, dni);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean existeClientePorDni(String dni) {
        String SQL = "SELECT 1 FROM clientes WHERE dni = ?";
        boolean existe = false;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, dni);

            try (ResultSet rs = ps.executeQuery()) {
                // Si el ResultSet tiene al menos una fila, el cliente existe
                existe = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar existencia del cliente por DNI: " + e.getMessage());
            e.printStackTrace();
        }
        return existe;
    }

    /**
     * Método auxiliar para asegurar que un String nulo se convierta a String
     * vacío ("") Esto evita errores de integridad de datos si la columna en la
     * BD es NOT NULL.
     */
    private String getSafeString(String input) {
        return input != null ? input : "";
    }
}
