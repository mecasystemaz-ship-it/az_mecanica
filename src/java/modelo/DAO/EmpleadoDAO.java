// Archivo: src/main/java/dao/EmpleadoDAO.java
package modelo.DAO;

import modelo.Empleado;
import util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {

    /**
     * Obtiene una lista de todos los empleados activos (o todos si se omite el
     * estado).
     */
    public List<Empleado> listarTodos() {
        List<Empleado> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT dni, nombres, apellidos, telefono, email, fecha_contratacion, cargo, salario, estado "
                + "FROM empleados ORDER BY apellidos, nombres";

        try {
            conn = ConexionDB.getInstancia().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Empleado emp = new Empleado();
                emp.setDni(rs.getString("dni"));
                emp.setNombres(rs.getString("nombres"));
                emp.setApellidos(rs.getString("apellidos"));
                emp.setTelefono(rs.getString("telefono"));
                emp.setEmail(rs.getString("email"));
                emp.setFechaContratacion(rs.getDate("fecha_contratacion"));
                emp.setCargo(rs.getString("cargo"));
                emp.setSalario(rs.getDouble("salario"));
                emp.setEstado(rs.getBoolean("estado"));
                lista.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConexionDB.close(conn); // Asumo que el close solo necesita la conexión
            // En un DAO más robusto, se cierran ResultSet y PreparedStatement también.
        }
        return lista;
    }

    /**
     * Obtiene un empleado por su DNI.
     */
    public Empleado obtenerPorDni(String dni) {
        Empleado emp = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT dni, nombres, apellidos, telefono, email, fecha_contratacion, cargo, salario, estado "
                + "FROM empleados WHERE dni = ?";

        try {
            conn = ConexionDB.getInstancia().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, dni);
            rs = ps.executeQuery();

            if (rs.next()) {
                emp = new Empleado();
                emp.setDni(rs.getString("dni"));
                emp.setNombres(rs.getString("nombres"));
                emp.setApellidos(rs.getString("apellidos"));
                emp.setTelefono(rs.getString("telefono"));
                emp.setEmail(rs.getString("email"));
                emp.setFechaContratacion(rs.getDate("fecha_contratacion"));
                emp.setCargo(rs.getString("cargo"));
                emp.setSalario(rs.getDouble("salario"));
                emp.setEstado(rs.getBoolean("estado"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConexionDB.close(conn);
        }
        return emp;
    }

    /**
     * Inserta un nuevo empleado.
     */
    public boolean insertar(Empleado emp) {
        Connection conn = null;
        PreparedStatement ps = null;

        // Verificar duplicado
        if (obtenerPorDni(emp.getDni()) != null) {
            return false; // <-- retorna false si existe el DNI
        }

        String sql = "INSERT INTO empleados (dni, nombres, apellidos, telefono, email, fecha_contratacion, cargo, salario, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = ConexionDB.getInstancia().getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, emp.getDni());
            ps.setString(2, emp.getNombres());
            ps.setString(3, emp.getApellidos());
            ps.setString(4, emp.getTelefono());
            ps.setString(5, emp.getEmail());
            ps.setDate(6, emp.getFechaContratacion());
            ps.setString(7, emp.getCargo());
            ps.setDouble(8, emp.getSalario());
            ps.setBoolean(9, emp.isEstado());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            ConexionDB.close(conn);
        }
    }

    /**
     * Actualiza un empleado existente.
     */
    public boolean actualizar(Empleado emp) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE empleados SET nombres=?, apellidos=?, telefono=?, email=?, fecha_contratacion=?, cargo=?, salario=?, estado=? "
                + "WHERE dni=?";
        boolean actualizado = false;

        try {
            conn = ConexionDB.getInstancia().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, emp.getNombres());
            ps.setString(2, emp.getApellidos());
            ps.setString(3, emp.getTelefono());
            ps.setString(4, emp.getEmail());
            ps.setDate(5, emp.getFechaContratacion());
            ps.setString(6, emp.getCargo());
            ps.setDouble(7, emp.getSalario());
            ps.setBoolean(8, emp.isEstado());
            ps.setString(9, emp.getDni());

            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar empleado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConexionDB.close(conn);
        }
        return actualizado;
    }

    /**
     * Elimina un empleado por su DNI (o lo desactiva, que es mejor práctica).
     */
    public boolean eliminar(String dni) {
        Connection conn = null;
        PreparedStatement ps = null;
        // Mejor práctica: Cambiar estado a FALSE (desactivar) en lugar de DELETE
        String sql = "UPDATE empleados SET estado = FALSE WHERE dni = ?";
        boolean eliminado = false;

        try {
            conn = ConexionDB.getInstancia().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, dni);

            eliminado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al desactivar empleado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConexionDB.close(conn);
        }
        return eliminado;
    }
}
