package modelo;


import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Métodos de registro/guardado relacionados a usuarios (puedes expandir a clientes, etc.)
 */
public class Guardar {

    /**
     * Registra un nuevo usuario en la BD.
     * @param usuario
     * @param contrasena
     * @param nombre
     * @param apellido
     * @param correo
     * @param rol
     * @param celular
     * @param direccion
     * @return true si se insertó 1 fila; false en caso contrario
     *
     * Ajusta la tabla/columnas a tu esquema real.
     */
    public boolean registrarUsuario(
            String usuario,
            String contrasena,
            String nombre,
            String apellido,
            String correo,
            String celular,
            String direccion,
            String rol
    ) {
        String sql = "INSERT INTO usuarios (usuario, contrasena, nombre, apellido, correo, celular, direccion, rol, estado) "
                   + "VALUES (?,?,?,?,?,?,?,?,1)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, usuario);
            pstmt.setString(2, contrasena);
            pstmt.setString(3, nombre);
            pstmt.setString(4, apellido);
            pstmt.setString(5, correo);
            pstmt.setString(6, celular);
            pstmt.setString(7, direccion);
            pstmt.setString(8, rol);

            int filas = pstmt.executeUpdate();
            return filas == 1;

        } catch (SQLException e) { // opcional: logger y manejo de mensajes
            // opcional: logger y manejo de mensajes
            return false;
        }
    }
}
