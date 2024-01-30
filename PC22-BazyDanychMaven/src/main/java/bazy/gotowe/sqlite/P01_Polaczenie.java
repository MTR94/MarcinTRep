package bazy.gotowe.sqlite;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class P01_Polaczenie {

	public static void main(String[] args) {
		// JDBC
		
		try {
			Connection connection = DriverManager.getConnection(
					"jdbc:sqlite:hr.db");
			
			System.out.println("Nawiązano połączenie " + connection);
			
			System.out.println("Klasa: " + connection.getClass().getName());
			
			DatabaseMetaData metaData = connection.getMetaData();
			System.out.println(metaData.getDatabaseProductName());
			System.out.println(metaData.getDatabaseMajorVersion() + " " + metaData.getDatabaseMinorVersion());

			// da się też odczytać listę wszystkich tabel, informacje o tabelach...
			
			connection.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
