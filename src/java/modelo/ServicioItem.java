/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.math.BigDecimal;

public class ServicioItem {
    private Integer id;
    private Integer servicioId;
    private Integer catalogoServicioId; // opcional (puede ser null)
    private String nombreServicio;
    private String descripcion;
    private BigDecimal precio;
    private Integer cantidad;
    private boolean custom;

    public ServicioItem() {}

    // Getters/Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getServicioId() { return servicioId; }
    public void setServicioId(Integer servicioId) { this.servicioId = servicioId; }

    public Integer getCatalogoServicioId() { return catalogoServicioId; }
    public void setCatalogoServicioId(Integer catalogoServicioId) { this.catalogoServicioId = catalogoServicioId; }

    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }

    public boolean isCustom() { return custom; }
    public void setCustom(boolean custom) { this.custom = custom; }
}
