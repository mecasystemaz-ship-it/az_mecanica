/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

public class Vehiculo {
    private String placa;
    private String marca;
    private String tipo;
    private String modelo;
    private Integer anio;
    private String color;
    private String combustible;
    private String numMotor;
    private Integer kilometraje;
    private String soat;
    private String tarjetaPropietario;
    private String dniCliente;

    public Vehiculo() {}

    public Vehiculo(String placa, String marca, String tipo, String modelo, Integer anio,
                    String color, String combustible, String numMotor, Integer kilometraje,
                    String soat, String tarjetaPropietario, String dniCliente) {
        this.placa = placa;
        this.marca = marca;
        this.tipo = tipo;
        this.modelo = modelo;
        this.anio = anio;
        this.color = color;
        this.combustible = combustible;
        this.numMotor = numMotor;
        this.kilometraje = kilometraje;
        this.soat = soat;
        this.tarjetaPropietario = tarjetaPropietario;
        this.dniCliente = dniCliente;
    }

    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }
    public Integer getAnio() { return anio; }
    public void setAnio(Integer anio) { this.anio = anio; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public String getCombustible() { return combustible; }
    public void setCombustible(String combustible) { this.combustible = combustible; }
    public String getNumMotor() { return numMotor; }
    public void setNumMotor(String numMotor) { this.numMotor = numMotor; }
    public Integer getKilometraje() { return kilometraje; }
    public void setKilometraje(Integer kilometraje) { this.kilometraje = kilometraje; }
    public String getSoat() { return soat; }
    public void setSoat(String soat) { this.soat = soat; }
    public String getTarjetaPropietario() { return tarjetaPropietario; }
    public void setTarjetaPropietario(String tarjetaPropietario) { this.tarjetaPropietario = tarjetaPropietario; }
    public String getDniCliente() { return dniCliente; }
    public void setDniCliente(String dniCliente) { this.dniCliente = dniCliente; }
}
