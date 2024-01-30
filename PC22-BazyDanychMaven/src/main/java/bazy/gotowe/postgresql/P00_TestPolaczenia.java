package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class P00_TestPolaczenia {

	public static void main(String[] args) {

		try (Connection c = DriverManager.getConnection(
				"jdbc:postgresql://localhost:5432/hr",
				"kurs",
				"abc123")) {
			System.out.println("Udało się połączyć: " + c);
			System.out.println(c.getClientInfo());
			System.out.println(c.getMetaData().getDatabaseProductName());

			try (Statement stmt = c.createStatement()) {
				final String sql = "SELECT * FROM employees";
				try (ResultSet rs = stmt.executeQuery(sql)) {
					while (rs.next()) {
						System.out.print(rs.getString("first_name"));
						System.out.print(" ");
						System.out.println(rs.getString("last_name"));
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
