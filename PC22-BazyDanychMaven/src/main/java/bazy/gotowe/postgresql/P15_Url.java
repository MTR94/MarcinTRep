package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P15_Url {
	public static void main(String[] args) throws SQLException {
		// Parametry zapytania można przekazać też w URL-u.
		// W tym także użytkownika i hasło.
		// Parametr tcpKeepAlive niczemu konkretnemu tu nie służy - jest tylko przykładem,
		// że sterowniki JDBC mogą posiadać dodatkowe parametry niestandardowe.
		// W SQL Server parametry rozdziela się średnikami, np user=ala;password=kot
		String url = "jdbc:postgresql://localhost/hr?user=kurs&password=abc123&tcpKeepAlive=true";
		String name = "Steven";
		String last = "King";
		Connection c = DriverManager.getConnection(url);
		c.setAutoCommit(false);
		PreparedStatement stmt = c.prepareStatement("SELECT first_name,last_name FROM EMPLOYEES "
											+ "WHERE first_name = ?");
		stmt.setString(1, name);
		stmt.setFetchSize(10);
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			System.out.print("Wynik: ");
			System.out.print(rs.getString(1) + " ");
			System.out.println(rs.getString(2));
		}
		stmt.setFetchSize(0);
		rs.close();
		stmt.close();
	}
}
