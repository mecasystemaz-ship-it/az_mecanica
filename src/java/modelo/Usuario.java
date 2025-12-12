// modelo/Usuario.java
package modelo;

public class Usuario {

    // Usamos 'dni' como clave principal, que mapearemos al campo 'usuario' del formulario
    private String dni;
    private String nombre;
    private String apellido;
    private String telefono;
    private String email;
    private String direccion;
    private String rol; // Por defecto será 'USER' al registrar

    // Constructor que usamos para el login (se mantiene)
    public Usuario(String dni, String email, String nombre, String rol) {
        this.dni = dni;
        this.email = email;
        this.nombre = nombre;
        this.rol = rol;
    }

    // Y necesitamos un constructor para el registro (con todos los datos)
    public Usuario(String dni, String contrasena, String nombre, String apellido, String email, String telefono, String direccion, String rol) {
        this.dni = dni;
        // La contraseña no se guarda en el objeto, solo se usa para el DAO
        this.nombre = nombre;
        this.apellido = apellido;
        this.telefono = telefono;
        this.email = email;
        this.direccion = direccion;
        this.rol = rol;
    }

    // Getters y Setters
    public String getDni() {
        return dni;
    }

    public String getEmail() {
        return email;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public String getRol() {
        return rol;
    }
    
}
