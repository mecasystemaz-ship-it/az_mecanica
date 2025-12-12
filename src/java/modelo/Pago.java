package modelo;

import java.sql.Date;
import java.sql.Time;

public class Pago {

    // ==========================================
    // 1. CAMPOS DE LA BASE DE DATOS (Tabla 'pagos')
    // ==========================================
    private int idPago;
    private String origen;        // "CITA" o "PROFORMA"
    private String idReferencia;  // ID de la Cita o ID de la Proforma
    private double monto;         // Dinero real pagado
    private String metodoPago;    // Yape, Efectivo, Tarjeta...
    private Date fecha;           // Fecha del pago
    private String notas;

    // ==========================================
    // 2. CAMPOS AUXILIARES (Para mostrar en el JSP)
    // ==========================================
    // Estos NO se guardan en la tabla 'pagos', se llenan con JOINs en el DAO
    
    // Comunes
    private String nombreCliente;

    // Específicos de Citas
    private String placaVehiculo;
    private String nombreServicio;
    private Time horaCita;

    // Específicos de Proformas
    private double montoEstimado; // Para comparar cuánto debía vs cuánto pagó
    private String estadoProforma;

    // ==========================================
    // CONSTRUCTOR VACÍO
    // ==========================================
    public Pago() {
    }

    // ==========================================
    // GETTERS Y SETTERS
    // ==========================================

    // --- Campos Principales ---
    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getIdReferencia() {
        return idReferencia;
    }

    public void setIdReferencia(String idReferencia) {
        this.idReferencia = idReferencia;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    // --- Campos Auxiliares ---

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getPlacaVehiculo() {
        return placaVehiculo;
    }

    public void setPlacaVehiculo(String placaVehiculo) {
        this.placaVehiculo = placaVehiculo;
    }

    public String getNombreServicio() {
        return nombreServicio;
    }

    public void setNombreServicio(String nombreServicio) {
        this.nombreServicio = nombreServicio;
    }

    public Time getHoraCita() {
        return horaCita;
    }

    public void setHoraCita(Time horaCita) {
        this.horaCita = horaCita;
    }

    public double getMontoEstimado() {
        return montoEstimado;
    }

    public void setMontoEstimado(double montoEstimado) {
        this.montoEstimado = montoEstimado;
    }

    public String getEstadoProforma() {
        return estadoProforma;
    }

    public void setEstadoProforma(String estadoProforma) {
        this.estadoProforma = estadoProforma;
    }
}