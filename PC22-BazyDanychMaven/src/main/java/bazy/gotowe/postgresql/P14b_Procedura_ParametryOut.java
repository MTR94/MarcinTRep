package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.*;
import java.util.Scanner;

public class P14b_Procedura_ParametryOut {
	
	public static void main(String[] args) {
		@SuppressWarnings("resource")
		Scanner sc = new Scanner(System.in);
		System.out.print("Podaj numer departamentu: ");
		int nrDep = sc.nextInt();

		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
			CallableStatement stmt = c.prepareCall("{CALL statystyki_departamentu(?,?,?,?,?)}")) {
			// parametrom IN ustawiamy wartości
			stmt.setInt(1, nrDep);

			// parametry OUT należy zarejestrować przed wykonaniem zapytania
			stmt.registerOutParameter(2, Types.INTEGER);
			stmt.registerOutParameter(3, Types.DECIMAL);
			stmt.registerOutParameter(4, Types.DECIMAL);
			stmt.registerOutParameter(5, Types.DECIMAL);

			stmt.executeUpdate();

			// odebranie wartości wynikowych
			int count = stmt.getInt(2);
			BigDecimal avg = stmt.getBigDecimal(3);
			BigDecimal min = stmt.getBigDecimal(4);
			BigDecimal max = stmt.getBigDecimal(5);
			System.out.printf("Statystyki departamentu %d: cnt = %d, avg = %s, min = %s, max = %s%n",
					nrDep, count, avg, min, max);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
