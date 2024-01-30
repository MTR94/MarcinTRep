package bazy.gotowe.inne_bazy;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SQLServer {

	public static void main(String[] args) {
		try (Connection cn = DriverManager.getConnection(
				"jdbc:sqlserver://localhost:1433;database=HR;user=KURS;password=abc123");
				PreparedStatement stmt = cn.prepareStatement("SELECT * FROM employees");
				ResultSet rs = stmt.executeQuery()) {
			while(rs.next()) {
				int a = rs.getInt(1);
				String b = rs.getString(2);
				String c = rs.getString(3);
				System.out.println(a + " " + b + " " + c);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
