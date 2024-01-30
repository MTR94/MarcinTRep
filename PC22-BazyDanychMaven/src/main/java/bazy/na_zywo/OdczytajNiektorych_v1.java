package bazy.na_zywo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JOptionPane;

/* Rozwiązanie 1:
  Z bazy odczytujemy wszystkie rekordy, a po stronie w Javy, za pomocą equals filtrujemy rekordy i wyświeltlamy tylko te, które spełniają warunek.

  Problem: niska wydajność.
  Baza musi odczytać wszystkie rekordy z dysku (nawet, gdyby były zdefinioane indeksy),
  wszystkie dane są transferowane przez sieć,
  wszystkie dane są przeglądane przez Javę, co obciąża aplikację kliencką.
*/
public class OdczytajNiektorych_v1 {

    public static void main(String[] args) {
        String szukanyJob = JOptionPane.showInputDialog("Podaj job_id, np. IT_PROG");
        // Niech program wypisuje dane tylko tych pracowników, którzy mają takie job_id
        
        String url = "jdbc:postgresql://localhost:5432/hr";
        try(Connection c = DriverManager.getConnection(url, "kurs", "abc123")) {
            System.out.println("connection: " + c);
            try(PreparedStatement stmt = c.prepareStatement("SELECT * FROM employees")) {
                System.out.println("stmt: " + stmt);
                System.out.println();
                
                try(ResultSet rs = stmt.executeQuery()) {
                    while(rs.next()) {
                        String job = rs.getString("job_id");
                        if(job.equals(szukanyJob)) {
                            System.out.printf("Pracownik nr %d, %s %s (%s) zarabia %s%n",
                                rs.getInt("employee_id"),
                                rs.getString("first_name"),
                                rs.getString("last_name"),
                                job,
                                rs.getBigDecimal("salary"));
                        }
                    }
                }
            }
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
