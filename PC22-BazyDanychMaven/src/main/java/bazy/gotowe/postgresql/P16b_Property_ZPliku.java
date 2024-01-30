package bazy.gotowe.postgresql;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class P16b_Property_ZPliku {
	public static void main(String[] args) {
		try {
			Properties props = new Properties();
			// nazwa pliku jeśli jest w katalogu bieżącym, albo pełna ścieżka do pliku
			props.load(new FileInputStream("postgres.properties"));
			// props.load(new FileInputStream("C:/jakis_katalog/postgres.properties"));

			String url = props.getProperty("url");
			Connection c = DriverManager.getConnection(url, props);
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT avg(salary) FROM employees");
			if (rs.next()) {
				System.out.print("Wynik: ");
				System.out.println(rs.getString(1));
			}
			rs.close();
			stmt.close();
			c.close();
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}
}
