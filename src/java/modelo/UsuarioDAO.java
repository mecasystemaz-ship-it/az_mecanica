/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package modelo;

import java.sql.*;

public class UsuarioDAO {

    // Método para la verificación de credenciales
    public static String verificarCredenciales(String usuario, String contrasena) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String nombreCompleto = null;

        try {
            // Cargar Driver y Conexión (Asegúrate de que 'az_mecanica' sea correcto)
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/az_mecanica";
            String user = "root";
            String password = "";

            conn = DriverManager.getConnection(url, user, password);

            // 1. Consulta SQL para buscar usuario y contraseña
            // NOTA DE SEGURIDAD: En un proyecto real, se compara el HASH de la contraseña, no el texto plano.
            String sql = "SELECT nombre, apellido FROM usuarios WHERE usuario = ? AND contrasena = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usuario);
            pstmt.setString(2, contrasena); // ¡Aquí se debería comparar el HASH!

            rs = pstmt.executeQuery();

            // 2. Si se encuentra un resultado, las credenciales son correctas
            if (rs.next()) {
                String nombre = rs.getString("nombre");
                String apellido = rs.getString("apellido");
                // Concatenamos el nombre completo para la sesión
                nombreCompleto = nombre + " " + (apellido != null ? apellido : "");
            }

            return nombreCompleto; // Retorna el nombre si es exitoso, o null si falla

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            // Cerrar recursos
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}