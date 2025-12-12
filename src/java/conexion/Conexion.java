/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package conexion;
// conexion/Conexion.java


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Conexion {

    // 👉 Ajusta estos valores a tu entorno
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306";
    private static final String DB_NAME = "az_mecanica";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    // URL con parámetros recomendados para MySQL 8+
    private static final String URL = String.format(
        "jdbc:mysql://%s:%s/%s?useSSL=false&useUnicode=true&characterEncoding=UTF-8"
        + "&serverTimezone=America/Lima&allowPublicKeyRetrieval=true",
        DB_HOST, DB_PORT, DB_NAME
    );

    static {
        try {
            // Driver moderno de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Si llegas aquí, falta el conector en tu proyecto
            throw new RuntimeException("No se encontró el driver de MySQL (mysql-connector-j).", e);
        }
    }

    private Conexion() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, DB_USER, DB_PASS);
    }
}
