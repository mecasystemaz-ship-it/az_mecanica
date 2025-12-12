/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// src/java/modelo/Servicio.java
package modelo;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Servicio {
    private Integer id;
    private String titulo;
    private String tipo; // 'Mantenimiento','Diagnóstico','Correctivo','Preventivo'
    private String dniCliente;
    private String placaVehiculo;
    private String origen;      // Orden / Proforma / Web / etc.
    private String numeroRef;   // único opcional
    private Date fecha;         // yyyy-MM-dd
    private BigDecimal montoTotal;
    private String metodoPago;  // Efectivo / Yape / Plin / Tarjeta...
    private String estado;      // 'Pendiente','En Proceso','Completado','Cancelado'
    private String observaciones;

    private List<ServicioItem> items = new ArrayList<>();

    public Servicio() {}

    // Getters/Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getDniCliente() { return dniCliente; }
    public void setDniCliente(String dniCliente) { this.dniCliente = dniCliente; }

    public String getPlacaVehiculo() { return placaVehiculo; }
    public void setPlacaVehiculo(String placaVehiculo) { this.placaVehiculo = placaVehiculo; }

    public String getOrigen() { return origen; }
    public void setOrigen(String origen) { this.origen = origen; }

    public String getNumeroRef() { return numeroRef; }
    public void setNumeroRef(String numeroRef) { this.numeroRef = numeroRef; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public BigDecimal getMontoTotal() { return montoTotal; }
    public void setMontoTotal(BigDecimal montoTotal) { this.montoTotal = montoTotal; }

    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public List<ServicioItem> getItems() { return items; }
    public void setItems(List<ServicioItem> items) { this.items = items; }
}
