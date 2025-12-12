// Archivo: src/main/java/dao/CitaDAO.java
package modelo.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import modelo.*;
import util.ConexionDB;

public class CitaDAO {

    // --- Métodos de Listado para Selects del Modal ---
    public List<Cliente> listarClientes() {
        List<Cliente> lista = new ArrayList<>();
        // Asumiendo tabla 'clientes' y estado 1
        String sql = "SELECT dni, nombres FROM clientes ORDER BY nombres";
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente cli = new Cliente();
                cli.setDni(rs.getString("dni"));
                cli.setNombres(rs.getString("nombres"));
                lista.add(cli);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return lista;
    }

    public List<Vehiculo> listarVehiculos() {
        List<Vehiculo> lista = new ArrayList<>();
        // Asumiendo tabla 'Vehiculo' y estado 1 (Nota: Podrías querer filtrar por cliente logueado o seleccionado)
        String sql = "SELECT placa, marca FROM vehiculo ORDER BY placa";
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehiculo vehi = new Vehiculo();
                vehi.setPlaca(rs.getString("placa"));
                vehi.setMarca(rs.getString("marca"));
                lista.add(vehi);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar vehículos: " + e.getMessage());
        }
        return lista;
    }

    public List<Servicio> listarServicios() {
        List<Servicio> lista = new ArrayList<>();
        // Asumiendo tabla 'Servicio' y estado 1
        String sql = "SELECT id_servicio, nombre FROM servicio ORDER BY nombre";
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Servicio servi = new Servicio();
                servi.setIdServicio(rs.getInt("id_servicio"));
                servi.setNombre(rs.getString("nombre"));
                lista.add(servi);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar servicios: " + e.getMessage());
        }
        return lista;
    }

    public List<Empleado> listarEmpleados() {
        List<Empleado> lista = new ArrayList<>();
        // Asumiendo tabla 'empleados' y estado 1 (o un filtro por rol 'MECANICO'/'EMPLEADO')
        String sql = "SELECT dni, nombres FROM empleados WHERE estado = 1 ORDER BY nombres";
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Empleado emp = new Empleado();
                emp.setDni(rs.getString("dni"));
                emp.setNombres(rs.getString("nombres"));
                lista.add(emp);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar empleados: " + e.getMessage());
        }
        return lista;
    }

    // --- Métodos CRUD de Citas ---
    // El estado de la Cita será un campo implícito que tú debes manejar (ej: PENDIENTE, CONFIRMADA, CANCELADA)
    private static final String INSERT_CITA_SQL
            = "INSERT INTO Cita (fecha, hora, dni_cliente, placa_vehiculo, id_servicio, dni_empleado, notas, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    public boolean crearCita(Cita cita) {
        boolean rowInserted = false;
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_CITA_SQL)) {

            ps.setDate(1, java.sql.Date.valueOf(cita.getFecha()));
            ps.setTime(2, java.sql.Time.valueOf(cita.getHora()));
            ps.setString(3, cita.getDniCliente());
            ps.setString(4, cita.getPlacaVehiculo());
            ps.setInt(5, cita.getIdServicio());
            ps.setString(6, cita.getDniEmpleado());
            ps.setString(7, cita.getNotas());
            ps.setString(8, cita.getEstado()); // Usamos el estado por defecto o el que se defina

            rowInserted = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al crear cita: " + e.getMessage());
            e.printStackTrace();
        }
        return rowInserted;
    }

    private static final String CANCEL_CITA_SQL = "UPDATE Cita SET estado = 'CANCELADA' WHERE id_cita = ?";

    public boolean cancelarCita(int idCita) {
        boolean rowUpdated = false;
        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(CANCEL_CITA_SQL)) {

            ps.setInt(1, idCita);
            rowUpdated = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al cancelar cita: " + e.getMessage());
        }
        return rowUpdated;
    }

    public boolean actualizarEstadoCita(int idCita, String nuevoEstado) {
        String sql = "UPDATE Cita SET estado = ? WHERE id_cita = ?";

        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idCita);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar la cita " + idCita + " a estado " + nuevoEstado + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- Métodos para el Calendario ---
    /**
     * Obtiene las citas para un mes y año específicos. La consulta trae el
     * nombre del cliente y el nombre del servicio para mostrarlo en el
     * calendario.
     */
    public List<Cita> listarCitasPorMes(int anio, int mes) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.id_cita, c.fecha, c.hora, c.estado, c.notas, cl.nombres AS nombre_cliente, s.nombre AS nombre_servicio "
                + "FROM Cita c "
                + "JOIN clientes cl ON c.dni_cliente = cl.dni "
                + "JOIN Servicio s ON c.id_servicio = s.id_servicio "
                + "WHERE YEAR(c.fecha) = ? AND MONTH(c.fecha) = ? "
                + "ORDER BY c.fecha, c.hora";

        try (Connection conn = ConexionDB.getInstancia().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, anio);
            ps.setInt(2, mes);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = new Cita();
                    c.setId(rs.getInt("id_cita"));
                    c.setFecha(rs.getDate("fecha").toLocalDate());
                    c.setHora(rs.getTime("hora").toLocalTime());
                    c.setEstado(rs.getString("estado"));
                    c.setNotas(rs.getString("notas"));
                    c.setNombreCliente(rs.getString("nombre_cliente"));
                    c.setNombreServicio(rs.getString("nombre_servicio"));
                    // Se asume que en el JSP, 'ev.cliente' es el nombre, y 'ev.servicio' es el nombre
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar citas: " + e.getMessage());
        }
        return lista;
    }
}
