package bazy.gotowe.postgresql;

import javax.swing.*;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class P04_Odczyt_Sparametryzowany {

	public static void main(String[] args) {

		String kogoSzukac = JOptionPane.showInputDialog("Podaj kod stanowiska, np. IT_PROG");

		try (Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			System.out.println("Otwarto połączenie " + c);
			// również stosowanie traksancji oraz oznaczanie sesji jako readonly jeśli nie planujemy zmian są dodatkowymi zabezpieczeniami przed skutkami SQL injection
			c.setAutoCommit(false);
			c.setReadOnly(true);

			final String sql = "SELECT * FROM employees WHERE job_id = ? ORDER BY employee_id";
			try (PreparedStatement stmt = c.prepareStatement(sql)) {
				stmt.setString(1, kogoSzukac);
				System.out.println("Zapytanie do wykonania: " + stmt);
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
