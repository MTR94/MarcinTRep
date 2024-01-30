package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class P03_Odczyt_PreparedStatement {

	public static void main(String[] args) {
		// W tej wersji zamykniem połączenia i innych zasobów zajmuje się try-with-resources
		try (Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			// Dzięki rozdzielenieu do osobnych try mogę pomiędzy nimi wpisywać inne instrukcje
			System.out.println("Otwarto połączenie " + c);
			c.setAutoCommit(false);
			c.setReadOnly(true);

			final String sql = "SELECT * FROM employees ORDER BY employee_id";

			try (PreparedStatement stmt = c.prepareStatement(sql)) {
				try (ResultSet rs = stmt.executeQuery()) {
					while (rs.next()) {
						int id = rs.getInt(1);
						String firstName = rs.getString(2);
						String lastName = rs.getString(3);

						String jobId = rs.getString("job_id");
						BigDecimal salary = rs.getBigDecimal("salary");
						Date date = rs.getDate("hire_date");
						LocalDate localDate = date.toLocalDate();

						System.out.printf("%d %s %s %s %s %s%n", id, firstName, lastName, jobId, salary, date);
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
