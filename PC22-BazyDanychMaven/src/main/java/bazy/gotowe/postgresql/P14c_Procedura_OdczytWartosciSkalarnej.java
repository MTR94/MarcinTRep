package bazy.gotowe.postgresql;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

public class P14c_Procedura_OdczytWartosciSkalarnej {
	
	public static void main(String[] args) {
		@SuppressWarnings("resource")
		Scanner sc = new Scanner(System.in);
		System.out.print("Podaj numer pracownika: ");
		int nr = sc.nextInt();
		
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
			CallableStatement stmt = c.prepareCall("{?= call nazwisko_szefa(?)}")) {
			stmt.setInt(2, nr);
			stmt.registerOutParameter(1, Types.VARCHAR);
			System.out.println(stmt);
			stmt.executeUpdate();

			String nazwisko = stmt.getString(1);
			if(nazwisko == null) {
				System.out.println("Nie ma szefa");
			} else {
				System.out.println("Szef ma na nazwisko: " + nazwisko);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
