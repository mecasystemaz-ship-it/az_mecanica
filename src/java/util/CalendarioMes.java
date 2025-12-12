/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import modelo.Cita;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class CalendarioMes {

    public static class Dia {
        public int numero;
        public boolean otroMes;
        public String fechaISO; // YYYY-MM-DD
        public List<Map<String,String>> eventos = new ArrayList<>();
    }
    public static class Semana { public List<Dia> dias = new ArrayList<>(); }

    private static final String[] MESES_ES = {
        "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
        "Agosto","Setiembre","Octubre","Noviembre","Diciembre"
    };
    public static String nombreMes(int m) { return MESES_ES[Math.max(1,Math.min(12,m))-1]; }

    public static Map<String,Object> armar(int anio, int mes1a12, List<Cita> citas) {
        Map<String,Object> out = new HashMap<>();
        LocalDate first = LocalDate.of(anio, mes1a12, 1);
        LocalDate last  = first.withDayOfMonth(first.lengthOfMonth());

        LocalDate start = first.with(DayOfWeek.MONDAY);
        if (start.isAfter(first)) start = start.minusWeeks(1);
        LocalDate end = last.with(DayOfWeek.SUNDAY);
        if (end.isBefore(last)) end = end.plusWeeks(1);

        Map<LocalDate,List<Cita>> porDia = new HashMap<>();
        for (Cita c : citas) porDia.computeIfAbsent(c.getFecha(), k->new ArrayList<>()).add(c);

        List<Semana> semanas = new ArrayList<>();
        DateTimeFormatter iso = DateTimeFormatter.ISO_LOCAL_DATE;
        LocalDate cur = start;

        while (!cur.isAfter(end)) {
            Semana sem = new Semana();
            for (int i=0;i<7;i++) {
                Dia d = new Dia();
                d.numero = cur.getDayOfMonth();
                d.otroMes = (cur.getMonthValue()!=mes1a12);
                d.fechaISO = cur.format(iso);

                List<Cita> delDia = porDia.getOrDefault(cur, Collections.emptyList());
                delDia.sort(Comparator.comparing(Cita::getHora));

                for (Cita c : delDia) {
                    Map<String,String> ev = new HashMap<>();
                    ev.put("id", String.valueOf(c.getId()));
                    ev.put("cliente", c.getClienteNombre()!=null ? c.getClienteNombre() : c.getIdCliente());
                    ev.put("horaTxt", c.getHora().toString());
                    ev.put("servicio", c.getTipo());
                    ev.put("estado", c.getEstado());
                    d.eventos.add(ev);
                }
                sem.dias.add(d);
                cur = cur.plusDays(1);
            }
            semanas.add(sem);
        }
        out.put("anio", anio);
        out.put("mesNombre", nombreMes(mes1a12));
        out.put("semanas", semanas);
        return out;
    }
}
