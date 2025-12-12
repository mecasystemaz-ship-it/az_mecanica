/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;

public class UsuarioDAO {

    // --- CONFIGURACIÓN DE LA CONEXIÓN (¡AJUSTA ESTO!) ---
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver"; // Driver para MySQL 8+
    private static final String DB_URL = "jdbc:mysql://localhost:3306/az_mecanica";
    private static final String USER = "root";
    private static final String PASS = "";
    // ---------------------------------------------------

    // Método privado para obtener la conexión
    private Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver JDBC.");
            throw new SQLException("Driver JDBC no encontrado", e);
        }
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }

    /**
     * Verifica las credenciales de inicio de sesión.
     * Asume que el usuario ingresa su EMAIL y que la contraseña está en SHA256.
     * @param email El email proporcionado por el usuario (usado como nombre de usuario).
     * @param contrasena La contraseña en texto plano.
     * @return Objeto Usuario si las credenciales son válidas, o null si fallan.
     */
    public Usuario login(String email, String contrasena) {
        // Usamos SHA2(?, 256) en la consulta para comparar el hash de la contraseña ingresada
        String sql = "SELECT dni, nombre, rol FROM Usuario WHERE email = ? AND contraseña = SHA2(?, 256)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, contrasena);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Credenciales válidas: crea el objeto Usuario
                    String dni = rs.getString("dni");
                    String nombre = rs.getString("nombre");
                    String rol = rs.getString("rol");
                    
                    // Nota: el campo 'usuario' del modelo se mapea aquí al 'email' para mantener la consistencia
                    return new Usuario(dni, email, nombre, rol);
                }
            }
        } catch (SQLException e) {
            // Imprime el error de conexión o consulta
            e.printStackTrace(); 
        }
        return null; // Credenciales inválidas o error de DB
    }
}