package modelo;

import java.sql.Date;

public class Proforma {
    // CAMBIO: idProforma ahora es String
    private String idProforma;
    private Date fecha;
    // CAMBIO: dniUsuario ahora es idCliente
    private String idCliente;
    private double montoEstimado;
    private String estado;
    
    // (Opcional) Para mostrar el nombre del cliente en la vista
    private String nombreCliente; 

    // Constructor vacío
    public Proforma() {
    }

    // Constructor completo (Adaptado)
    public Proforma(String idProforma, Date fecha, String idCliente, double montoEstimado, String estado) {
        this.idProforma = idProforma;
        this.fecha = fecha;
        this.idCliente = idCliente;
        this.montoEstimado = montoEstimado;
        this.estado = estado;
    }

    // --- Getters y Setters (Adaptados) ---

    // CAMBIO: Retorna String
    public String getIdProforma() {
        return idProforma;
    }

    // CAMBIO: Recibe String
    public void setIdProforma(String idProforma) {
        this.idProforma = idProforma;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    // CAMBIO: Referencia al ID del cliente
    public String getIdCliente() {
        return idCliente;
    }

    // CAMBIO: Referencia al ID del cliente
    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public double getMontoEstimado() {
        return montoEstimado;
    }

    public void setMontoEstimado(double montoEstimado) {
        this.montoEstimado = montoEstimado;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    // CAMBIO: Referencia al nombre del Cliente
    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }
}