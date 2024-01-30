package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P08b_ModyfikacjaPoprzezWynik_WTransakcji {

	public static void main(String[] args) {
		final String sql = "SELECT * FROM departments WHERE department_id < ? ORDER BY department_id";
		int limit = 100;
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			c.setAutoCommit(false);  // przejście w tryb transakcji

			try(PreparedStatement stmt = c.prepareStatement(sql,
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE)) {

				stmt.setInt(1, limit);
				try(ResultSet rs = stmt.executeQuery()) {			
					while(rs.next()) {
						try {
							Thread.sleep(500);
						} catch (InterruptedException e) { }

						int id = rs.getInt(1);
						String staraNazwa = rs.getString(2);
						String nowaNazwa = staraNazwa + " #";
						
						System.out.printf("%3d %s → %s\n", id, staraNazwa, nowaNazwa);
						
						rs.updateString(2, nowaNazwa);
						rs.updateRow();
					}
				}
			}
			
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
			}
			
			c.commit();
			System.out.println("COMMIT");

			//c.rollback();
			//System.out.println("ROLLBACK");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
