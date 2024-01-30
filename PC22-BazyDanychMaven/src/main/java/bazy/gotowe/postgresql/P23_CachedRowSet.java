package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

import javax.sql.RowSet;
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.FilteredRowSet;
import javax.sql.rowset.Predicate;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;

/* CachedRowSet i jego specjalizacje są disconnected.
 * To może zmniejszyć wydajność, ale pozwala kopiować dane i pracować z nimi w oderwaniu od bazy.
 * 
 * FilteredRowSet pozwala nakładać filtry na odczytywane dane.
 */

public class P23_CachedRowSet {
	private Connection c;
	private RowSetFactory rsf;
	
	P23_CachedRowSet() throws SQLException {
		rsf = RowSetProvider.newFactory();
		c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD);
	}

	private void populujWynikiZapytania(String tabela, CachedRowSet cachedRowSet) throws SQLException {
		final String sql = "SELECT * FROM " + tabela;
		try(PreparedStatement stmt = c.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery()) {
			cachedRowSet.populate(rs);
			// rs można zamknąć
		}
	}
	
	private void run() throws SQLException {
		FilteredRowSet employees = rsf.createFilteredRowSet();
		populujWynikiZapytania("employees", employees);
		CachedRowSet jobs = rsf.createCachedRowSet();
		populujWynikiZapytania("jobs", jobs);
		
		while(jobs.next()) {
			String jobId = jobs.getString("job_id");
			String jobTitle = jobs.getString("job_title");
			System.out.printf("\nPracownicy ze stanowiska %s (%s):\n", jobTitle, jobId);
			employees.setFilter(new PredykatJobowy(jobId));
			employees.beforeFirst();
			while(employees.next()) {
				String firstName = employees.getString("first_name");
				String lastName = employees.getString("last_name");
				System.out.printf(" * %s %s\n", firstName, lastName);
			}
		}
	}
	
	
	public static void main(String[] args) {
		try {
			P23_CachedRowSet p13 = new P23_CachedRowSet();
			p13.run();
			System.out.println("Koniec");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static class PredykatJobowy implements Predicate {
		private String jobId;

		public PredykatJobowy(String jobId) {
			this.jobId = jobId;
		}

		public boolean evaluate(RowSet rs) {
			try {
				String actualJobId = rs.getString("job_id");
				return Objects.equals(jobId, actualJobId);
			} catch (SQLException e) {
				return false;
			}
		}

		public boolean evaluate(Object value, int column) throws SQLException {
			return true;
		}

		public boolean evaluate(Object value, String columnName) throws SQLException {
			return true;
		}
	}
}
