// Archivo: src/main/java/model/Cita.java
package modelo;

import java.time.LocalDate;
import java.time.LocalTime;

public class Cita {

    private int id;
    private String dniCliente;
    private String placaVehiculo;
    private int idServicio;
    private String dniEmpleado;
    private LocalDate fecha;
    private LocalTime hora;
    private String notas;
    private String estado; // Campo no incluido en tu CREATE TABLE, pero necesario para el calendario (PENDIENTE, CONFIRMADA, CANCELADA).

    // Atributos para la vista (información de las claves foráneas)
    private String nombreCliente;
    private String nombreServicio;
    private String horaTxt; // Para formato HH:MM en la vista

    // Constructores, Getters y Setters
    public Cita() {
        this.estado = "PENDIENTE"; // Valor por defecto
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getDniCliente() {
        return dniCliente;
    }

    public String getPlacaVehiculo() {
        return placaVehiculo;
    }

    public int getIdServicio() {
        return idServicio;
    }

    public String getDniEmpleado() {
        return dniEmpleado;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public LocalTime getHora() {
        return hora;
    }

    public String getNotas() {
        return notas;
    }

    public String getEstado() {
        return estado;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public String getNombreServicio() {
        return nombreServicio;
    }

    // Getters para el JSP (usando los nombres de atributos esperados en tu JSP)
    public int getId_cita() {
        return id;
    }

    public String getCliente() {
        return nombreCliente;
    }

    public String getServicio() {
        return nombreServicio;
    }

    public String getHoraTxt() {
        // Formateo simple para HH:MM
        if (hora != null) {
            return hora.toString().substring(0, 5);
        }
        return "";
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setDniCliente(String dniCliente) {
        this.dniCliente = dniCliente;
    }

    public void setPlacaVehiculo(String placaVehiculo) {
        this.placaVehiculo = placaVehiculo;
    }

    public void setIdServicio(int idServicio) {
        this.idServicio = idServicio;
    }

    public void setDniEmpleado(String dniEmpleado) {
        this.dniEmpleado = dniEmpleado;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public void setHora(LocalTime hora) {
        this.hora = hora;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public void setNombreServicio(String nombreServicio) {
        this.nombreServicio = nombreServicio;
    }
    
    // --- NUEVO ATRIBUTO PARA PAGOS ---
    private double precio;
    
    
    // --- NUEVOS MÉTODOS PARA PAGOS ---
    public double getPrecio() { 
        return precio; 
    }

    public void setPrecio(double precio) { 
        this.precio = precio; 
    }
}
