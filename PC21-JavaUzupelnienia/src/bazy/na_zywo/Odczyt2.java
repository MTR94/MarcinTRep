package bazy.na_zywo;

import java.sql.*;

public class Odczyt2 {
   public static void main(String[] args) {
       String url = "jdbc:postgresql://localhost:5432/postgres";
       try (Connection c = DriverManager.getConnection(url, "postgres", "abc123");
           PreparedStatement stmt = c.prepareStatement("SELECT * FROM osoby");
           ResultSet rs = stmt.executeQuery()) {
           while (rs.next()) {
               System.out.printf("Osoba nr %d to jest %s %s, ur. %s, zarabia %s%n",
                       rs.getInt("id"),
                       rs.getString("imie"),
                       rs.getString("nazwisko"),
                       rs.getString("data_urodzenia"),
                       rs.getBigDecimal("pensja"));
           }
       } catch (SQLException e) {
           throw new RuntimeException(e);
       }
   }
}

