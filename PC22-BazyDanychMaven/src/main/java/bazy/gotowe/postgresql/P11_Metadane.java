package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class P11_Metadane {
/* Nawet nie wiedząc jaka jest struktura bazy danych, można te informacje odczytać z połączenia */
	public static void main(String[] args) {
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {

			System.out.println("Otwarto połączenie. c = " + c);
			
			DatabaseMetaData dbMetaData = c.getMetaData();
			
			System.out.println(dbMetaData.getDatabaseProductName());
			System.out.println(dbMetaData.getDatabaseMajorVersion()
					+ "." + dbMetaData.getDatabaseMinorVersion());
			System.out.println();
			
			try(ResultSet tables = dbMetaData.getTables(null, "public", null, null)) {
				wypiszTabele(tables);
			}
			System.out.println("\n\nNormalna tabela:");
			
			try(ResultSet rs = c.createStatement().executeQuery("SELECT * FROM jobs")) {
				wypiszTabele(rs);				
			}
			System.out.println();
			
			try(ResultSet rs = c.createStatement().executeQuery("SELECT * FROM departments JOIN locations USING(location_id)")) {
				wypiszTabele(rs);				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private static void wypiszTabele(ResultSet rs) throws SQLException {
		// Odczytanie "metadanych wyniku"
		ResultSetMetaData rsMetaData = rs.getMetaData();

		final int n = rsMetaData.getColumnCount();
		System.out.println("Wynik ma " + n + " kolumn:");
		for(int i = 1; i <= n; i++) {
			System.out.printf("%-30s", rsMetaData.getColumnName(i));
		}
		System.out.println();
		for(int i = 1; i <= n; i++) {
			System.out.printf("%-30s", rsMetaData.getColumnType(i));
		}
		System.out.println();
		for(int i = 1; i <= n; i++) {
			System.out.printf("%-30s", rsMetaData.getColumnTypeName(i));
		}
		System.out.println();
		
		while(rs.next()) {
			for(int i = 1; i <= n; i++) {
				System.out.printf("%-30s", rs.getString(i));
			}
			System.out.println();
		}
	}
}
