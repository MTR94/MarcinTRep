package bazy.gotowe.sqlite;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JOptionPane;

public class P04_Parametry {

	public static void main(String[] args) {
		String szukani = JOptionPane.showInputDialog("Podaj kod stanowiska");
		szukani = szukani.toUpperCase();
		
		// Przykład SQL injection, które zadziałałoby w wersji ze sklejaniem stringów:
		// a'; DROP TABLE job_history; SELECT 'ala
		
		// final String sql = "SELECT * FROM employees WHERE job_id = '" + szukani +  "'"; 

		// Właściwe podejście: użyć znaków zapytania i metod PreparedStatement.setXXX aby ustawić wartość parametru.
		final String sql = "SELECT * FROM employees WHERE job_id = ?"; 
		
		try(Connection c = DriverManager.getConnection("jdbc:sqlite:hr.db");
			PreparedStatement stmt = c.prepareStatement(sql)) {
			
			stmt.setString(1, szukani);
			
			try(ResultSet rs = stmt.executeQuery()) {
				while(rs.next()) {
					// można odczytać kolumny wg numeru - numeracja od 1
					String imie = rs.getString(2);
	
					// można też używać nazwy kolumny
					String nazwisko = rs.getString("last_name");
					BigDecimal pensja = rs.getBigDecimal("salary");
					String data = rs.getString("hire_date");
					int id = rs.getInt("employee_id");
					String job = rs.getString("job_id");
					
					System.out.printf("%-15s %-15s (%3d) - zatr. %s, pensja %8s, %s\n",
							imie, nazwisko, id, data, pensja, job);
				}
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
