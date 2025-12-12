// Archivo: src/main/java/util/DiaCalendario.java
package util;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Cita;

public class DiaCalendario {
    private int numero;
    private LocalDate fecha;
    private boolean otroMes;
    private List<Cita> eventos;

    public DiaCalendario(LocalDate fecha) {
        this.fecha = fecha;
        this.numero = fecha.getDayOfMonth();
        this.eventos = new ArrayList<>();
    }

    // Getters y Setters
    public int getNumero() { return numero; }
    public LocalDate getFecha() { return fecha; }
    public String getFechaISO() { return fecha.toString(); }
    public boolean isOtroMes() { return otroMes; }
    public List<Cita> getEventos() { return eventos; }

    public void setOtroMes(boolean otroMes) { this.otroMes = otroMes; }
    public void addEvento(Cita cita) { this.eventos.add(cita); }
    
    // JSP espera getOtroMes()
    public boolean getOtroMes() { return otroMes; }
}