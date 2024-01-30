package bazy.na_zywo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OdczytajWszystkich {

    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/hr";
        try(Connection c = DriverManager.getConnection(url, "kurs", "abc123");
            PreparedStatement stmt = c.prepareStatement("SELECT * FROM employees");
            ResultSet rs = stmt.executeQuery()) {
            while(rs.next()) {
                System.out.printf("Pracownik nr %d, %s %s (%s) zarabia %s%n",
                        rs.getInt("employee_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("hire_date"),
                        rs.getBigDecimal("salary"));
            }
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
