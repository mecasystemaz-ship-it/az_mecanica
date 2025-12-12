// Archivo: src/main/java/modelo/Empleado.java
package modelo;

import java.sql.Date; // Usaremos java.sql.Date si viene de la DB

public class Empleado {

    private String dni;
    private String nombres;
    private String apellidos;
    private String telefono;
    private String email;
    private Date fechaContratacion; // Usamos Date para la fecha
    private String cargo;
    private double salario;
    private boolean estado; // true: Activo, false: Inactivo

    // Constructor vacío
    public Empleado() {
    }

    // Constructor completo
    public Empleado(String dni, String nombres, String apellidos, String telefono, String email,
            Date fechaContratacion, String cargo, double salario, boolean estado) {
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.telefono = telefono;
        this.email = email;
        this.fechaContratacion = fechaContratacion;
        this.cargo = cargo;
        this.salario = salario;
        this.estado = estado;
    }

    // --- Getters y Setters ---
    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getFechaContratacion() {
        return fechaContratacion;
    }

    public void setFechaContratacion(Date fechaContratacion) {
        this.fechaContratacion = fechaContratacion;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public double getSalario() {
        return salario;
    }

    public void setSalario(double salario) {
        this.salario = salario;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
}
