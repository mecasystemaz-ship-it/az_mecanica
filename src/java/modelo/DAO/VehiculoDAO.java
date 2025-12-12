package modelo.DAO;

import modelo.Vehiculo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.ConexionDB; // Asegúrate de que esta ruta sea correcta

public class VehiculoDAO {

    // --- Configuración de Conexión ---
    private Connection getConnection() throws SQLException {
        // Asumiendo que ConexionDB.getInstancia() y .getConnection() son correctos
        return ConexionDB.getInstancia().getConnection();
    }

    // Campos: placa, marca, tipo, modelo, anio, color, combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_cliente
    private static final String COLUMNAS_VEHICULO = "placa, marca, tipo, modelo, anio, color, combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_cliente";

    // --- Sentencias SQL ---
    private static final String SQL_LISTAR
            = "SELECT v.*, CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente_join FROM vehiculo v LEFT JOIN clientes c ON v.dni_cliente = c.dni ORDER BY v.placa";

    private static final String SQL_ELIMINAR = "DELETE FROM vehiculo WHERE placa = ?";

    // 12 parámetros: Placa + 11 campos restantes
    private static final String SQL_INSERTAR
            = "INSERT INTO vehiculo (" + COLUMNAS_VEHICULO + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // 11 Campos SET + Placa + Placa Original (WHERE) = 13 parámetros totales en el PreparedStatement
    private static final String SQL_ACTUALIZAR_BASE
            = "UPDATE vehiculo SET placa=?, marca=?, tipo=?, modelo=?, anio=?, color=?, combustible=?, num_motor=?, kilometraje=?, soat=?, tarjeta_propietario=?, dni_cliente=? WHERE placa=?";

    private static final String SQL_OBTENER_POR_PLACA
            = "SELECT v.*, CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente_join FROM vehiculo v LEFT JOIN clientes c ON v.dni_cliente = c.dni WHERE v.placa = ?";

    // --- Métodos de Mapeo y CRUD ---
    private Vehiculo mapearVehiculo(ResultSet rs) throws SQLException {
        Vehiculo v = new Vehiculo();
        v.setPlaca(rs.getString("placa"));
        v.setMarca(rs.getString("marca"));
        v.setTipo(rs.getString("tipo"));
        v.setModelo(rs.getString("modelo"));

        // Manejo seguro de Integer
        v.setAnio(rs.getInt("anio"));
        if (rs.wasNull()) {
            v.setAnio(null);
        }

        v.setColor(rs.getString("color"));
        v.setCombustible(rs.getString("combustible"));
        v.setNumMotor(rs.getString("num_motor"));

        // Manejo seguro de Integer
        v.setKilometraje(rs.getInt("kilometraje"));
        if (rs.wasNull()) {
            v.setKilometraje(null);
        }

        v.setSoat(rs.getString("soat"));
        v.setTarjetaPropietario(rs.getString("tarjeta_propietario"));
        v.setDniCliente(rs.getString("dni_cliente"));

        // Campo extra
        v.setNombreCliente(rs.getString("nombre_cliente_join"));
        return v;
    }

    public List<Vehiculo> listarVehiculos() {
        List<Vehiculo> lista = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_LISTAR); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearVehiculo(rs));
            }
        } catch (SQLException e) {
            System.err.println("FATAL: Error al listar vehículos. Causa: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Vehiculo obtenerVehiculoPorPlaca(String placa) {
        Vehiculo vehiculo = null;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_OBTENER_POR_PLACA)) {

            ps.setString(1, placa);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    vehiculo = mapearVehiculo(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener vehículo por placa. Causa: " + e.getMessage());
            e.printStackTrace();
        }
        return vehiculo;
    }

    public boolean agregarVehiculo(Vehiculo v) {
        boolean exito = false;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_INSERTAR)) {

            // Mapeo de parámetros para INSERT (12 parámetros)
            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getTipo());
            ps.setString(4, v.getModelo());
            ps.setObject(5, v.getAnio(), java.sql.Types.INTEGER);
            ps.setString(6, v.getColor());
            ps.setString(7, v.getCombustible());
            ps.setString(8, v.getNumMotor());
            ps.setObject(9, v.getKilometraje(), java.sql.Types.INTEGER);
            ps.setString(10, v.getSoat());
            ps.setString(11, v.getTarjetaPropietario());
            ps.setString(12, v.getDniCliente());

            exito = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al agregar vehículo. Causa: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    /**
     * Actualiza un vehículo. Usa la placaOriginal para la condición WHERE, lo
     * que permite cambiar la PLACA misma.
     *
     * @param v El objeto Vehiculo con los nuevos datos.
     * @param placaOriginal La placa que tiene actualmente en la base de datos
     * (para la condición WHERE).
     * @return true si la actualización fue exitosa.
     */
    public boolean actualizarVehiculo(Vehiculo v, String placaOriginal) {
        boolean exito = false;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_ACTUALIZAR_BASE)) {

            // Mapeo de parámetros para UPDATE (12 campos SET)
            ps.setString(1, v.getPlaca()); // 1: Nueva Placa
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getTipo());
            ps.setString(4, v.getModelo());
            ps.setObject(5, v.getAnio(), java.sql.Types.INTEGER);
            ps.setString(6, v.getColor());
            ps.setString(7, v.getCombustible());
            ps.setString(8, v.getNumMotor());
            ps.setObject(9, v.getKilometraje(), java.sql.Types.INTEGER);
            ps.setString(10, v.getSoat());
            ps.setString(11, v.getTarjetaPropietario());
            ps.setString(12, v.getDniCliente());

            // Parámetro 13: Condición WHERE (Placa Original)
            ps.setString(13, placaOriginal);

            exito = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar vehículo. Causa: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    public boolean eliminarVehiculo(String placa) {
        boolean filaEliminada = false;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_ELIMINAR)) {

            ps.setString(1, placa);
            filaEliminada = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar vehículo. Causa: " + e.getMessage());
            e.printStackTrace();
        }
        return filaEliminada;
    }
}
