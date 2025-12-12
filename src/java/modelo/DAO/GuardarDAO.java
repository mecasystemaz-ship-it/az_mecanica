/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class GuardarDAO {
    
    // --- CONFIGURACIÓN DE LA CONEXIÓN (¡DEBE SER LA MISMA!) ---
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/az_mecanica";
    private static final String USER = "root";
    private static final String PASS = "";
    // ---------------------------------------------------

    private Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC no encontrado", e);
        }
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }
    
    /**
     * Guarda un nuevo usuario en la base de datos con rol 'USER' por defecto.
     * @return true si el registro fue exitoso, false si falló (ej. DNI o Email duplicado).
     */
    public boolean guardarUsuario(String dni, String contrasena, String nombre, String apellido, 
                                  String email, String telefono, String direccion) {
        
        // El rol por defecto para los registros de cliente es 'USER'
        String ROL_DEFECTO = "USER";
        
        // La consulta SQL debe insertar todos los campos de tu tabla 'Usuario'
        String sql = "INSERT INTO Usuario (dni, contraseña, nombre, apellido, email, telefono, direccion, rol) "
                   + "VALUES (?, SHA2(?, 256), ?, ?, ?, ?, ?, ?)"; 
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Mapeo de parámetros
            stmt.setString(1, dni); 
            stmt.setString(2, contrasena); // Se hashea en la DB con SHA256
            stmt.setString(3, nombre);
            stmt.setString(4, apellido);
            stmt.setString(5, email);
            stmt.setString(6, telefono);
            stmt.setString(7, direccion);
            stmt.setString(8, ROL_DEFECTO);

            // Ejecuta la inserción. executeUpdate retorna el número de filas afectadas.
            int filasAfectadas = stmt.executeUpdate();
            
            return filasAfectadas > 0;

        } catch (SQLException e) {
            // Un error de SQL puede indicar DNI o Email duplicado (por las restricciones UNIQUE/PRIMARY KEY)
            e.printStackTrace();
            return false;
        }
    }
}