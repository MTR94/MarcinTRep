package bazy.gotowe.postgresql;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class P16c_Property_Z_Classpath {
	public static void main(String[] args) {
		try {
			Properties props = new Properties();
			// Tutaj odczytany zostanie plik, który znajduje się (wraz z plikami .class) w katalogach / jar-ach
			// będących częścią classpath.
			// Jeśli podana jest tylko nazwa pliku (albo ścieżka względna), to jako katalog bieżący jest traktowany bieżący pakiet.
			// Można też podać ścieżkę bezwzględną np. /gotowe/postgresql/ustawienia_bazy.properties
			// to wtedy plik byłby szukany w pakiecie ustawienia
			// W projekcie Mavenowym właściwą lokalizacją dla takich plików jest src/main/resources
			props.load(P16c_Property_Z_Classpath.class.getResourceAsStream("ustawienia_bazy.properties"));

			String url = props.getProperty("url");
			Connection c = DriverManager.getConnection(url, props);
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT avg(salary) FROM employees");
			while (rs.next()) {
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
