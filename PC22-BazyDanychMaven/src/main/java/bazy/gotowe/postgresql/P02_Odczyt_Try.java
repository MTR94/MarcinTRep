package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class P02_Odczyt_Try {

	public static void main(String[] args) {
		// W tej wersji zamykaniem połączenia i innych zasobów zajmuje się try-with-resources
		try(Connection c = DriverManager.getConnection(Ustawienia.URL,Ustawienia.USER,Ustawienia.PASSWD);
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM employees")) {

			while (rs.next()) {
				// Wartości z kolumn można odczytywać wg numerów (numeracja od 1)
				// Do różnych typów danych mamy odpowiednie metody getXXX()
				int id = rs.getInt(1);
				String firstName = rs.getString(2);
				String lastName = rs.getString(3);

				// Wartości z kolumn można też odczytywać wg nazw (lub aliasów)
				String jobId = rs.getString("job_id");
				BigDecimal salary = rs.getBigDecimal("salary");
				Date date = rs.getDate("hire_date");
				LocalDate localDate = date.toLocalDate();

				System.out.printf("%d %s %s %s %s %s%n", id, firstName, lastName, jobId, salary, date);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.out.println("Koniec programu");
	}
}
