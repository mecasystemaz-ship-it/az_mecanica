// Archivo: src/main/java/util/SemanaCalendario.java
package util;

import java.util.List;

public class SemanaCalendario {
    private List<DiaCalendario> dias;

    public SemanaCalendario(List<DiaCalendario> dias) {
        this.dias = dias;
    }

    public List<DiaCalendario> getDias() { return dias; }
}