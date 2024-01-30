package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.Scanner;

public class P14d_Procedura_OdczytTabeli {
	
	public static void main(String[] args) {
		@SuppressWarnings("resource")
		Scanner sc = new Scanner(System.in);
		System.out.print("Podaj numer pracownika: ");
		int nr = sc.nextInt();
		
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
			CallableStatement stmt = c.prepareCall("{call zarabiajacy_wiecej_niz(?)}")) {
			stmt.setInt(1, nr);
			System.out.println(stmt);
			try (ResultSet rs = stmt.executeQuery()) {
				System.out.println("Pracownicy zarabiający więcej:");
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
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
