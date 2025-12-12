// modelo/Usuario.java
package modelo;

public class Usuario {
    private final int id;
    private String usuario;
    private String nombre;
    private String rol;

    public Usuario(int id, String usuario, String nombre, String rol) {
        this.id = id;
        this.usuario = usuario;
        this.nombre = nombre;
        this.rol = rol;
    }
    public int getId() { return id; }
    public String getUsuario() { return usuario; }
    public String getNombre() { return nombre; }
    public String getRol() { return rol; }
}