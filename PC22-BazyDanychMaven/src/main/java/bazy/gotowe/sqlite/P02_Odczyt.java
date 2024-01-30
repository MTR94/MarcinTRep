package bazy.gotowe.sqlite;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P02_Odczyt {

	public static void main(String[] args) {
		try {
			Connection c = DriverManager.getConnection("jdbc:sqlite:hr.db");
			
			PreparedStatement stmt = c.prepareStatement("SELECT * FROM employees");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				// można odczytać kolumny wg numeru - numeracja od 1
				String imie = rs.getString(2);

				// można też używać nazwy kolumny
				String nazwisko = rs.getString("last_name");
				BigDecimal pensja = rs.getBigDecimal("salary");
				
				System.out.println(imie + " " + nazwisko + " zarabia " + pensja);
			}
			rs.close();
			stmt.close();
			c.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
