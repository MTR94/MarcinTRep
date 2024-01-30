package bazy.gotowe.postgresql;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class P14a_Procedura_BrakWyniku {
	// Przykład wywołania "procedury składowanej" - takie rzeczy można tworzyć w bazach Oracle (PL/SQL), PostgreSQL (odmiana PL/SQL, ale także C i Python), MS SQL Server (T-SQL)
	// Ta procedura przyjmuje tylko parametry typu IN i nie zwraca wyniku. W kolejnych plikach przykłady innych sytuacji.
	public static void main(String[] args) {
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
			CallableStatement stmt = c.prepareCall("CALL przenies_pracownika(?,?,?)")) {
			stmt.setInt(1, 112);
			stmt.setInt(2, 60);
			stmt.setString(3, "IT_PROG");

			stmt.execute();
			System.out.println("Wykonane");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
