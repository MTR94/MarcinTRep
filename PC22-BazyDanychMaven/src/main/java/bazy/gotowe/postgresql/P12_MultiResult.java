package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class P12_MultiResult {

	public static void main(String[] args) {
		try (Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			try (Statement stmt = c.createStatement()) {
				// Kilka zapytań w jednym stringu
				String sql = "SELECT * FROM countries;"
						+ " SELECT * FROM jobs;"
						+ " SELECT first_name, last_name FROM employees";

				if(stmt.execute(sql)) // jeśli jest pierwszy ResultSet
				do {
					try (ResultSet rs = stmt.getResultSet()) {
						System.out.println("\n###########################\nKolejne wyniki:");
						while (rs.next()) {
							System.out.print(rs.getString(1));
							System.out.print(" ");
							System.out.println(rs.getString(2));
						}
					}
				// sprawdzam czy jest jeszcze jakiś kolejny ResultSet i jeśli tak, ponawiam wypisywanie
				} while (stmt.getMoreResults());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
