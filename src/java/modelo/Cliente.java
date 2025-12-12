// Archivo: src/main/java/modelo/Cliente.java
package modelo;

public class Cliente {

    // --- Datos Personales (Originales) ---
    private String dni;
    private String nombres;
    private String apellidos;
    private String telefono;
    private String correo;
    private String direccion;

    // --- Campos de Servicio/Última Visita (SOLICITASTE MANTENERLOS) ---
    private String origen;
    private String nreferencia;
    private String placa;
    private String metodo;

    // --- NUEVOS CAMPOS (Necesarios para el filtro del Dashboard) ---
    private int totalVehiculos; // Cantidad de autos
    private int totalCitas;     // Cantidad de citas

    public Cliente() {
    }

    // --- Getters y Setters Originales ---
    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getOrigen() { return origen; }
    public void setOrigen(String origen) { this.origen = origen; }

    public String getNreferencia() { return nreferencia; }
    public void setNreferencia(String nReferencia) { this.nreferencia = nReferencia; }

    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public String getMetodo() { return metodo; }
    public void setMetodo(String metodo) { this.metodo = metodo; }

    // --- NUEVOS GETTERS Y SETTERS PARA ESTADÍSTICAS ---
    public int getTotalVehiculos() { return totalVehiculos; }
    public void setTotalVehiculos(int totalVehiculos) { this.totalVehiculos = totalVehiculos; }

    public int getTotalCitas() { return totalCitas; }
    public void setTotalCitas(int totalCitas) { this.totalCitas = totalCitas; }
}