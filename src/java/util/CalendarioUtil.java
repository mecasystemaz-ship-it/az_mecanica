// Archivo: src/main/java/util/CalendarioUtil.java
package util;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import modelo.Cita;

public class CalendarioUtil {

    private static final Locale LOCALE_ES = new Locale("es", "ES");

    public static List<SemanaCalendario> generarVistaMensual(int anio, int mes, List<Cita> citas) {
        List<SemanaCalendario> semanas = new ArrayList<>();
        YearMonth mesActual = YearMonth.of(anio, mes);
        LocalDate primerDiaDelMes = mesActual.atDay(1);
        
        // Determinar el inicio del calendario: Lunes de la semana del primer día
        int diaDeLaSemana = primerDiaDelMes.getDayOfWeek().getValue(); // 1=Lunes, 7=Domingo
        
        // Ajuste para que empiece en Lunes (si DayOfWeek.MONDAY es 1, DayOfWeek.SUNDAY es 7)
        // Si el día es Lunes (1), retrocedemos 0 días. Si es Domingo (7), retrocedemos 6 días.
        int diasParaRetroceder = (diaDeLaSemana == 7) ? 6 : diaDeLaSemana - 1; 
        
        LocalDate inicioCalendario = primerDiaDelMes.minusDays(diasParaRetroceder);
        
        LocalDate diaActual = inicioCalendario;
        int maxSemanas = 6; // Para asegurar que todo el mes se vea
        
        for (int i = 0; i < maxSemanas; i++) {
            List<DiaCalendario> diasSemana = new ArrayList<>();
            for (int j = 0; j < 7; j++) {
                DiaCalendario diaCal = new DiaCalendario(diaActual);
                
                // Marcar si el día no pertenece al mes actual
                if (diaActual.getMonthValue() != mes) {
                    diaCal.setOtroMes(true);
                }
                
                // Asignar eventos del día
                LocalDate finalDia = diaActual;
                citas.stream()
                     .filter(c -> c.getFecha().isEqual(finalDia))
                     .forEach(diaCal::addEvento);
                
                diasSemana.add(diaCal);
                diaActual = diaActual.plusDays(1);
            }
            semanas.add(new SemanaCalendario(diasSemana));
            
            // Si el día actual ya está en el siguiente mes y es Lunes, paramos
            if (diaActual.getMonthValue() != mes && diaActual.getDayOfWeek().getValue() == 1) {
                break;
            }
        }
        
        return semanas;
    }

    public static String getNombreMes(int mes) {
        return YearMonth.of(LocalDate.now().getYear(), mes)
                        .getMonth()
                        .getDisplayName(TextStyle.FULL, LOCALE_ES);
    }
}
