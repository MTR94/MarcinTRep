package sklep.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ZwyklyOdczyt_JDBC {

	public static void main(String[] args) {
		String url = "jdbc:postgresql://localhost:5432/sklep";
		String sql = "SELECT * FROM products";
		try(Connection c = DriverManager.getConnection(url, "kurs", "abc123");
			PreparedStatement stmt= c.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery()) {
			
			while(rs.next()) {
				System.out.printf("%d: %s za cenę %s\n",
						rs.getInt("product_id"), rs.getString("product_name"), rs.getBigDecimal("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
