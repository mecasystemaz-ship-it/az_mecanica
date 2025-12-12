// Archivo: src/main/java/modelo/Servicio.java
package modelo;

import java.math.BigDecimal; // Importamos para manejar el precio con precisión

public class Servicio {

    private int idServicio;
    private String nombre;
    private String categoria;
    private String descripcion;
    private BigDecimal precio; // Usamos BigDecimal para DECIMAL(10,2)
    private String tiempoEstimado;

    // Constructor vacío (necesario para Java Beans/Frameworks)
    public Servicio() {
    }

    // --- Getters y Setters ---
    public int getIdServicio() {
        return idServicio;
    }

    public void setIdServicio(int idServicio) {
        this.idServicio = idServicio;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getTiempoEstimado() {
        return tiempoEstimado;
    }

    public void setTiempoEstimado(String tiempoEstimado) {
        this.tiempoEstimado = tiempoEstimado;
    }

    // Opcional: toString para debugging
    @Override
    public String toString() {
        return "Servicio{"
                + "idServicio=" + idServicio
                + ", nombre='" + nombre + '\''
                + ", precio=" + precio
                + '}';
    }
}
