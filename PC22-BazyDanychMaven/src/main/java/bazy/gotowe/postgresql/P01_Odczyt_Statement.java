package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class P01_Odczyt_Statement {

	public static void main(String[] args) {
		try {
			// W tej wersji zamykam połączenie za pomocą jawnego close()
			Connection c = DriverManager.getConnection(Ustawienia.URL,Ustawienia.USER,Ustawienia.PASSWD);
			System.out.println("Udało się połączyć: " + c);
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM employees");
			while (rs.next()) {
				// Wartości z kolumn można odczytywać wg numerów (numeracja od 1)
				// Do różnych typów danych mamy odpowiednie metody getXXX()
				int id = rs.getInt(1);
				String firstName = rs.getString(2);
				String lastName = rs.getString(3);

				// Wartości z kolumn można też odczytywać wg nazw (lub aliasów)
				String jobId = rs.getString("job_id");
				BigDecimal salary = rs.getBigDecimal("salary");
				java.sql.Date date = rs.getDate("hire_date");
				LocalDate localDate = date.toLocalDate();

				System.out.printf("%d %s %s %s %s %s%n", id, firstName, lastName, jobId, salary, date);
			}

			// również obiekty Statement oraz ResultSet należy zamykać
			// ponieważ mogą się z nimi wiązać zasoby trzymane po stronie serwera bazy danych
			rs.close();
			System.out.println("\n----------------------\n");
			
			// Ten sam Statement może być użyty do innego zapytania.
			rs = stmt.executeQuery("SELECT city, country_id FROM locations ORDER BY 2, 1");
			while (rs.next()) {
				System.out.printf("%s (%s)%n", rs.getString(1), rs.getString(2));
			}
			rs.close();
			stmt.close();
			c.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
