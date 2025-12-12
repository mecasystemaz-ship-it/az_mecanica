/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// Archivo: src/main/java/util/ConexionDB.java
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // --- Configuración de la Base de Datos (¡MODIFICAR!) ---
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/az_mecanica"; // Reemplazar 'tu_nombre_db'
    private static final String USER = "root";   // Reemplazar 'tu_usuario'
    private static final String PASS = "";   // Reemplazar 'tu_password'
   
    // --------------------------------------------------------

    private static ConexionDB instancia;

    // Constructor privado para evitar instanciación externa (Singleton)
    public ConexionDB() {
        try {
            // Cargar el driver JDBC
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Error al cargar el driver JDBC: " + DRIVER);
            e.printStackTrace();
        }
    }

    /**
     * Obtiene la única instancia de la clase (Singleton).
     */
    public static ConexionDB getInstancia() {
        if (instancia == null) {
            instancia = new ConexionDB();
        }
        return instancia;
    }

    /**
     * Crea y devuelve una nueva conexión a la base de datos.
     *
     * @return Objeto Connection
     * @throws SQLException
     */
    public Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.err.println("Error al conectar a la base de datos.");
            throw e; // Relanzar la excepción para que el DAO la maneje
        }
    }

    // Método de utilidad para cerrar conexiones
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
