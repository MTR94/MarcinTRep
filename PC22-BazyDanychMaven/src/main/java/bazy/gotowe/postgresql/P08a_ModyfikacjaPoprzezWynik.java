package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P08a_ModyfikacjaPoprzezWynik {
	
	public static void main(String[] args) {
		int limit = 100;

		final String sql = "SELECT * FROM departments WHERE department_id < ? ORDER BY department_id";
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			
			try(PreparedStatement stmt = c.prepareStatement(sql,
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE)) {

				stmt.setInt(1, limit);
				try(ResultSet rs = stmt.executeQuery()) {
					while(rs.next()) {
						try {
							Thread.sleep(2000);
						} catch (InterruptedException e) { }

						int id = rs.getInt(1);
						String staraNazwa = rs.getString(2);
						String nowaNazwa = staraNazwa + " *";
						
						System.out.printf("%3d %s → %s\n", id, staraNazwa, nowaNazwa);
						
						rs.updateString(2, nowaNazwa);
						//rs.updateString("department_name", nowaNazwa);
						rs.updateRow();
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
