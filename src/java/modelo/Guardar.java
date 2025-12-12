package modelo;

import java.sql.*;

public class Guardar {

    /**
     * Registra un nuevo usuario en la base de datos 'az_mecanica'.
     *
     * @param usuario El nombre de usuario único.
     * @param contrasena La contraseña del usuario.
     * @param nombre El nombre del usuario.
     * @param apellido El apellido del usuario.
     * @param correo El correo electrónico único.
     * @param celular El número de celular.
     * @param direccion La dirección del usuario.
     * @return true si el registro fue exitoso, false en caso contrario.
     */
    public static boolean guardar(String usuario, String contrasena, String nombre, String apellido, 
                                  String correo, String celular, String direccion) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 1. Cargar el driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Establecer conexión (AJUSTADO: base de datos 'az_mecanica')
            String url = "jdbc:mysql://localhost:3306/az_mecanica"; 
            String user = "root";
            String password = "";

            conn = DriverManager.getConnection(url, user, password);

            // 3. Preparar consulta SQL
            // La BD asignará por defecto 'CLIENTE' al rol y TRUE al estado.
            String sql = "INSERT INTO usuarios (usuario, contrasena, nombre, apellido, correo, celular, direccion) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            
            // Asignación de parámetros (7 campos)
            pstmt.setString(1, usuario);
            // NOTA IMPORTANTE: En un entorno de producción, la contraseña debe ser HASH-eada aquí o en el controlador.
            pstmt.setString(2, contrasena); 
            pstmt.setString(3, nombre);
            pstmt.setString(4, apellido);
            pstmt.setString(5, correo);
            pstmt.setString(6, celular);
            pstmt.setString(7, direccion);

            // 4. Ejecutar
            int filasAfectadas = pstmt.executeUpdate();

            // Retorna true si se insertó al menos una fila
            return filasAfectadas > 0; 

        } catch (SQLException e) {
            // Error de conexión o de restricción de la BD (ej. usuario/correo duplicado)
            System.err.println("Error SQL al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver JDBC.");
            e.printStackTrace();
            return false;
        } finally {
            // Cierre de recursos
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}