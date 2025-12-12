package modelo.DAO;

import modelo.Vehiculo;
import java.sql.*;
import java.util.*;
import util.ConexionDB;

public class VehiculoDAO {

    private Connection getConnection() throws SQLException {
        return ConexionDB.getInstancia().getConnection();
    }

    // Orden correcto de columnas
    private static final String COLUMNAS_VEHICULO =
            "placa, marca, tipo, modelo, anio, color, combustible, transmision, num_motor, vin, kilometraje, soat, tarjeta_propietario, dni_cliente";

    private static final String SQL_LISTAR =
            "SELECT v.*, CONCAT(c.nombres,' ',c.apellidos) AS nombre_cliente_join " +
            "FROM vehiculo v LEFT JOIN clientes c ON v.dni_cliente = c.dni ORDER BY v.placa";

    private static final String SQL_INSERTAR =
            "INSERT INTO vehiculo (" + COLUMNAS_VEHICULO + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    private static final String SQL_ACTUALIZAR =
            "UPDATE vehiculo SET placa=?, marca=?, tipo=?, modelo=?, anio=?, color=?, combustible=?, transmision=?, num_motor=?, vin=?, kilometraje=?, soat=?, tarjeta_propietario=?, dni_cliente=? WHERE placa=?";

    private static final String SQL_ELIMINAR =
            "DELETE FROM vehiculo WHERE placa=?";

    private static final String SQL_OBTENER_POR_PLACA =
            "SELECT v.*, CONCAT(c.nombres,' ',c.apellidos) AS nombre_cliente_join " +
            "FROM vehiculo v LEFT JOIN clientes c ON v.dni_cliente = c.dni WHERE v.placa=?";

    private Vehiculo mapearVehiculo(ResultSet rs) throws SQLException {
        Vehiculo v = new Vehiculo();

        v.setPlaca(rs.getString("placa"));
        v.setMarca(rs.getString("marca"));
        v.setTipo(rs.getString("tipo"));
        v.setModelo(rs.getString("modelo"));

        v.setAnio(rs.getInt("anio"));
        if (rs.wasNull()) v.setAnio(null);

        v.setColor(rs.getString("color"));
        v.setCombustible(rs.getString("combustible"));
        v.setTransmision(rs.getString("transmision"));
        v.setNummotor(rs.getString("num_motor"));
        v.setVin(rs.getString("vin"));

        v.setKilometraje(rs.getInt("kilometraje"));
        if (rs.wasNull()) v.setKilometraje(null);

        v.setSoat(rs.getString("soat"));
        v.setTarjetaPropietario(rs.getString("tarjeta_propietario"));
        v.setDniCliente(rs.getString("dni_cliente"));

        v.setNombreCliente(rs.getString("nombre_cliente_join"));

        return v;
    }

    public List<Vehiculo> listarVehiculos() {
        List<Vehiculo> lista = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_LISTAR);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapearVehiculo(rs));

        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Vehiculo obtenerVehiculoPorPlaca(String placa) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_OBTENER_POR_PLACA)) {

            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapearVehiculo(rs);

        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean agregarVehiculo(Vehiculo v) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getTipo());
            ps.setString(4, v.getModelo());
            ps.setObject(5, v.getAnio(), Types.INTEGER);
            ps.setString(6, v.getColor());
            ps.setString(7, v.getCombustible());
            ps.setString(8, v.getTransmision());
            ps.setString(9, v.getNummotor());
            ps.setString(10, v.getVin());
            ps.setObject(11, v.getKilometraje(), Types.INTEGER);
            ps.setString(12, v.getSoat());
            ps.setString(13, v.getTarjetaPropietario());
            ps.setString(14, v.getDniCliente());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean actualizarVehiculo(Vehiculo v, String placaOriginal) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getTipo());
            ps.setString(4, v.getModelo());
            ps.setObject(5, v.getAnio(), Types.INTEGER);
            ps.setString(6, v.getColor());
            ps.setString(7, v.getCombustible());
            ps.setString(8, v.getTransmision());
            ps.setString(9, v.getNummotor());
            ps.setString(10, v.getVin());
            ps.setObject(11, v.getKilometraje(), Types.INTEGER);
            ps.setString(12, v.getSoat());
            ps.setString(13, v.getTarjetaPropietario());
            ps.setString(14, v.getDniCliente());
            ps.setString(15, placaOriginal);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean eliminarVehiculo(String placa) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_ELIMINAR)) {

            ps.setString(1, placa);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
