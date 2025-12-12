/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

public class HistorialCliente {
    private int id;
    private String nombre;
    private String origen;  // Orden/Proforma/Web (placeholder)
    private String ref;     // N° Ref. (placeholder)
    private String placa;
    private String fecha;   // yyyy-MM-dd
    private double monto;   // placeholder
    private String metodo;  // Efectivo/Tarjeta/Yape (placeholder)

    public HistorialCliente(int id, String nombre, String origen, String ref, String placa, String fecha, double monto, String metodo) {
        this.id = id;
        this.nombre = nombre;
        this.origen = origen;
        this.ref = ref;
        this.placa = placa;
        this.fecha = fecha;
        this.monto = monto;
        this.metodo = metodo;
    }
    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public String getOrigen() { return origen; }
    public String getRef() { return ref; }
    public String getPlaca() { return placa; }
    public String getFecha() { return fecha; }
    public double getMonto() { return monto; }
    public String getMetodo() { return metodo; }
}
