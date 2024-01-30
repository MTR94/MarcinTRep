package bazy.na_zywo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JOptionPane;

/* Rozwiązanie 3:
 * Za pomocą WHERE filtrujemy rekordy po stronie bazy danych, co poprawia wydajność.
 * Tutaj prawidłowo używamy parametrów JDBC zapisywanych za pomocą ?
 */
public class OdczytajNiektorych_v3 {

    public static void main(String[] args) {
        String szukanyJob = JOptionPane.showInputDialog("Podaj job_id, np. IT_PROG");
        // Niech program wypisuje dane tylko tych pracowników, którzy mają takie job_id
        
        String url = "jdbc:postgresql://localhost:5432/hr";
        try(Connection c = DriverManager.getConnection(url, "kurs", "abc123")) {
            System.out.println("connection: " + c);
            String sql = "SELECT * FROM employees WHERE job_id = ?";
            try(PreparedStatement stmt = c.prepareStatement(sql)) {
                System.out.println("stmt: " + stmt);                
                stmt.setString(1, szukanyJob);
                System.out.println("stmt: " + stmt);
                System.out.println();
                
                try(ResultSet rs = stmt.executeQuery()) {
                    while(rs.next()) {
                        System.out.printf("Pracownik nr %d, %s %s (%s) zarabia %s%n",
                            rs.getInt("employee_id"),
                            rs.getString("first_name"),
                            rs.getString("last_name"),
                            rs.getString("job_id"),
                            rs.getBigDecimal("salary"));
                    }
                }
            }
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
