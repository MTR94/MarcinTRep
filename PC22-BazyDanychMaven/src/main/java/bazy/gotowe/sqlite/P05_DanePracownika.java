package bazy.gotowe.sqlite;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JOptionPane;

public class P05_DanePracownika {

	public static void main(String[] args) {
		String s = JOptionPane.showInputDialog("Podaj id pracownika");
		int id = Integer.parseInt(s);
		
		// program ma:
		// połączyć się z bazą,
		// zadać zapytanie (z JOIN i WHERE)
		// i wypisać dane tego pracownika:
		// first_name, last_name, department_name, street_address, city
		// (z tabel employees, departments, locations)
		
		final String sql = "SELECT first_name, last_name, department_name, street_address, city " + 
				"FROM employees" +
				" LEFT JOIN departments USING(department_id)" + 
				" LEFT JOIN locations USING(location_id)" + 
				"WHERE employee_id = ?"; 
		
		try(Connection c = DriverManager.getConnection("jdbc:sqlite:hr.db");
			PreparedStatement stmt = c.prepareStatement(sql)) {
			
			stmt.setInt(1, id);
			
			try(ResultSet rs = stmt.executeQuery()) {
				if(rs.next()) {
					System.out.printf("%s %s %s %s %s\n",
						rs.getString(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getString(5));
				} else {
					System.out.println("Nie znaleziono takiego pracownika");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
