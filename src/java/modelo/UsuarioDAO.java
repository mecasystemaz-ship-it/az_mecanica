/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */package modelo;

import java.sql.*;

public class UsuarioDAO {

    // ---- Config de conexión (usa tus valores)
    private static final String URL  = "jdbc:mysql://localhost:3306/az_mecanica?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } 
        catch (ClassNotFoundException e) { throw new RuntimeException(e); }
    }

    /**
     * Login que retorna el Usuario (id, usuario, nombre completo y rol).
     * Devuelve null si usuario/contraseña no coinciden o está inactivo.
     */
    public static Usuario login(String usuario, String contrasena) {
        String sql = "SELECT id, usuario, nombre, apellido, rol " +
                     "FROM usuarios " +
                     "WHERE usuario = ? AND contrasena = ? AND estado = 1 " +
                     "LIMIT 1";
        try (Connection cn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, contrasena); // TODO: luego usa hash (BCrypt/SHA-256)
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String user = rs.getString("usuario");
                    String nombre = rs.getString("nombre");
                    String apellido = rs.getString("apellido");
                    String rol = rs.getString("rol");

                    String nombreCompleto = (nombre == null ? "" : nombre.trim()) +
                                            " " +
                                            (apellido == null ? "" : apellido.trim());

                    return new Usuario(id, user, nombreCompleto.trim(),
                                       (rol == null ? "" : rol.trim()));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ---- Tu método anterior sigue funcionando, pero ya no lo uses: */
    public static String verificarCredenciales(String usuario, String contrasena) {
        String nombreCompleto = null;
        String sql = "SELECT nombre, apellido FROM usuarios WHERE usuario = ? AND contrasena = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, usuario);
            pstmt.setString(2, contrasena);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String nombre = rs.getString("nombre");
                    String apellido = rs.getString("apellido");
                    nombreCompleto = (nombre == null ? "" : nombre) + " " + (apellido == null ? "" : apellido);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return (nombreCompleto == null ? null : nombreCompleto.trim());
    }

    /** Utilidad opcional si alguna vez quieres leer solo el rol */
    public static String obtenerRol(String usuario) {
        String sql = "SELECT rol FROM usuarios WHERE usuario = ? AND estado = 1";
        try (Connection cn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("rol");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
