package bazy.gotowe.sqlite;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P03_Odczyt {

	public static void main(String[] args) {
		final String sql = "SELECT * FROM employees ORDER BY employee_id";
		
		try(Connection c = DriverManager.getConnection("jdbc:sqlite:hr.db");
			PreparedStatement stmt = c.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery()) {
				while(rs.next()) {
					// można odczytać kolumny wg numeru - numeracja od 1
					String imie = rs.getString(2);
	
					// można też używać nazwy kolumny
					String nazwisko = rs.getString("last_name");
					BigDecimal pensja = rs.getBigDecimal("salary");
					String data = rs.getString("hire_date");
					int id = rs.getInt("employee_id");
					
					System.out.printf("%-15s %-15s (%3d) - zatr. %s, pensja %8s\n",
							imie, nazwisko, id, data, pensja);
				}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
