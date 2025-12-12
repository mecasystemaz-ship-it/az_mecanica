/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {
    public List<Empleado> listarCombo() {
        List<Empleado> out = new ArrayList<>();
        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement("SELECT id, nombres FROM empleados ORDER BY nombres");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(new Empleado(rs.getInt("id"), rs.getString("nombres")));
        } catch (SQLException e) {
            // Si no existe la tabla, no lanzamos excepción para no romper la vista.
        }
        return out;
    }
}
