package bazy.gotowe.inne_bazy;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


/* Łączenie z bazą Oracle wymaga:
 * - sterownika Oracle JDBC (OJDBC)
 * - wpisania odpowiedniego URL-a, poniżej przykład, który zadziałał dla Oracle 11 eXpress Edition
 */
public class Oracle {

	public static void main(String[] args) {
		final String url = "jdbc:oracle:thin:@//10.0.15.13:1521/xe";
		try(Connection con = DriverManager.getConnection(url, "HR", "abc123")) {
			try(Statement st = con.createStatement()) {
				final String sql = "SELECT * FROM countries";
				try(ResultSet rs = st.executeQuery(sql)) {
					while(rs.next()) {
						System.out.print(rs.getString(1));
						System.out.print("  ");
						System.out.println(rs.getString("country_name"));
					}
				}
			}			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
