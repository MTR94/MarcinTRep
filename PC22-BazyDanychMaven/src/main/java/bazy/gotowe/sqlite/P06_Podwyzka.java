package bazy.gotowe.sqlite;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class P06_Podwyzka {

	public static void main(String[] args) {
		String job = "IT_PROG";
		int zmiana = 250;
		
		final String sql = "UPDATE employees SET salary = salary + ? WHERE job_id = ?";
		
		try(Connection c = DriverManager.getConnection("jdbc:sqlite:hr.db");
			PreparedStatement stmt = c.prepareStatement(sql)) {
			
			stmt.setInt(1, zmiana);
			stmt.setString(2, job);
			
			// Także dla poleceń jak INSERT, DELETE czy ALTER TABLE użylibyśmy executeUpdate
			int ile = stmt.executeUpdate();
			System.out.println("Zmodyfikowano " + ile + " rekordów.");
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
