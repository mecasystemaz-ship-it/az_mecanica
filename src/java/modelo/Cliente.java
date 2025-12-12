// Archivo: src/main/java/modelo/Cliente.java
package modelo;

public class Cliente {

    // DNI es el identificador principal
    private String dni;
    private String nombres;
    private String apellidos;
    private String telefono;
    private String correo; // Correo en la DB
    private String direccion;

    // Campos de Servicio/Última Visita
    private String origen;
    private String nreferencia; // N° Ref.
    private String placa;
    private String metodo;

    public Cliente() {
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

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    // Getters y Setters de Servicio
    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getNreferencia() {
        return nreferencia;
    }

    public void setNreferencia(String nReferencia) {
        this.nreferencia = nReferencia;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMetodo() {
        return metodo;
    }

    public void setMetodo(String metodo) {
        this.metodo = metodo;
    }
}
