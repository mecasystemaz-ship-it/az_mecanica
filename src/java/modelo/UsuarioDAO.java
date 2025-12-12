/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;


import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    /**
     * Autentica usuario y devuelve el objeto Usuario (id, usuario, nombre, rol)
     * Retorna null si no encuentra coincidencia.
     */
    public Usuario login(String usuario, String contrasena) {
        String sql = "SELECT id, usuario, nombre, rol "
                   + "FROM usuarios "
                   + "WHERE usuario = ? AND contrasena = ? AND estado = 1";

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String u = rs.getString("usuario");
                    String nombre = rs.getString("nombre");
                    String rol = rs.getString("rol");
                    return new Usuario(id, u, nombre, rol);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // opcional: cambia por tu logger
        }
        return null;
    }

    /** Ejemplo opcional: obtener rol por usuario. */
    public String obtenerRol(String usuario) {
        String sql = "SELECT rol FROM usuarios WHERE usuario = ? AND estado = 1";
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("rol");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
