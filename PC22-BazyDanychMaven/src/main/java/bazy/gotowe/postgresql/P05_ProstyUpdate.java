package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class P05_ProstyUpdate {
	
	public static void main(String[] args) {
		String sql = "UPDATE employees SET salary = salary + ? WHERE job_id = ?" ;
        
        try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
        	PreparedStatement stmt = c.prepareStatement(sql)) {
        	
        	stmt.setInt(1, 333);
        	stmt.setString(2, "IT_PROG");
        	
        	int ile = stmt.executeUpdate(); // uwaga, tego używamy także dla insert czy delete
        	// Dokładnie mówiąc: ilu wierszy dotyczyło zapytanie.
        	// W tym programie nie są używane transakcje (inaczej mówiąc: autoCommit == true)
        	// więc od razu zmiany są zapisywane trwale na serwerze.
        	System.out.println("Zaktualizowano " + ile + " wierszy");
        } catch (SQLException e) {
        	e.printStackTrace();
        }
	}
}
