package bazy.na_zywo;

import java.sql.*;

public class Odczyt1 {
    // JDBC = Java Database Connectivity

    public static void main(String[] args) {
        try {
            Connection c = DriverManager.getConnection("jdbc:postgresql://localhost/postgres",
                    "postgres", "abc123");
            System.out.println("Mam połączenie: " + c);

            PreparedStatement stmt = c.prepareStatement("SELECT * FROM osoby");
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                System.out.println(rs.getString(2) + " " + rs.getString(3));
            }
            c.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
