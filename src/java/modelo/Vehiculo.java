package modelo;

public class Vehiculo {

    private String placa;
    private String marca;
    private String tipo;
    private String modelo;
    private Integer anio;
    private String color;
    private String combustible;
    private String nummotor;
    private Integer kilometraje;
    private String soat;
    private String tarjetaPropietario;
    private String dniCliente;
    private String vin;
    private String transmision;   

    // Campo extra para mostrar el nombre del cliente en el JSP (obtenido con JOIN)
    private String nombreCliente;

    // Constructor vacío
    public Vehiculo() {
    }

    // Constructor con campos principales
    public Vehiculo(String placa, String marca, String modelo, String dniCliente, String vin, String transmision) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.dniCliente = dniCliente;
    }

    // --- Getters y Setters ---
    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getCombustible() {
        return combustible;
    }

    public void setCombustible(String combustible) {
        this.combustible = combustible;
    }

    public String getNummotor() {
        return nummotor;
    }

    public void setNummotor(String numMotor) {
        this.nummotor = numMotor;
    }

    public Integer getKilometraje() {
        return kilometraje;
    }

    public void setKilometraje(Integer kilometraje) {
        this.kilometraje = kilometraje;
    }

    public String getSoat() {
        return soat;
    }

    public void setSoat(String soat) {
        this.soat = soat;
    }

    public String getTarjetaPropietario() {
        return tarjetaPropietario;
    }

    public void setTarjetaPropietario(String tarjetaPropietario) {
        this.tarjetaPropietario = tarjetaPropietario;
    }

    public String getDniCliente() {
        return dniCliente;
    }

    public void setDniCliente(String dniCliente) {
        this.dniCliente = dniCliente;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }
    
    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }
    
    public String getTransmision() {
        return transmision;
    }

    public void setTransmision(String transmision) {
        this.transmision = transmision;
    }
}
