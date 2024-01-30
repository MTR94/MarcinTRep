package serwlety.beans;

import java.time.LocalDate;
import java.time.Period;

public class Osoba {
    private String imie, nazwisko;
    private LocalDate dataUrodzenia;


    public String getImie() {
        return imie;
    }

    public void setImie(String imie) {
        this.imie = imie;
    }

    public String getNazwisko() {
        return nazwisko;
    }

    public void setNazwisko(String nazwisko) {
        this.nazwisko = nazwisko;
    }

    public LocalDate getDataUrodzenia() {
        return dataUrodzenia;
    }

    // Aby w JSP zadziałało setProperty, parametrem gettera jest String
    public void setDataUrodzeniaTxt(String dataUrodzenia) {
        this.dataUrodzenia = LocalDate.parse(dataUrodzenia);
    }

    // Jeśli obiekt posiada metodę, która wygląda jak getter,
    // to z punktu widzenia standardu "Java Beans" jest to "readonly property",
    // a w skryptach JSP będzie można pisać ${osoba.wiek} , co spowoduje wywołanie tego gettera.
    public int getWiek() {
        Period czasZycia = Period.between(dataUrodzenia, LocalDate.now());
        return czasZycia.getYears();
    }

    @Override
    public String toString() {
        return "Osoba{" +
                "imie='" + imie + '\'' +
                ", nazwisko='" + nazwisko + '\'' +
                ", dataUrodzenia=" + dataUrodzenia +
                '}';
    }
}



