package bazy.gotowe.postgresql;

import java.math.BigDecimal;
import java.sql.Connection;

import javax.sql.rowset.JdbcRowSet;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;
import javax.swing.JOptionPane;

/* JdbcRowSet jest "connected".
 * 1) Zadawanie wielu zapytań w jednej sesji będzie bardziej wydajne przy użyciu JdbcRowSet niż CachedRowSet,
 *    bo Jdbc pozostaje połączony, a Cached musi się łączyć za każdym razem.
 * 2) Posiada metody do zarządzania transakcjami (commit/rollback/savepoint).
 * 3) Umożliwia aktualizację danych poprzez wynik.
*/
public class P22_JdbcRowSet {

	public static void main(String[] args) {
//		final String JOB = "IT_PROG";
//		final BigDecimal ZMIANA = new BigDecimal("1.00");
		final String JOB = JOptionPane.showInputDialog("Komu zmienić? (np. IT_PROG)");
		final BigDecimal ZMIANA = new BigDecimal(JOptionPane.showInputDialog("O ile zmienić?"));
		
		try {
			RowSetFactory rsf = RowSetProvider.newFactory();
			JdbcRowSet rowSet = rsf.createJdbcRowSet();
			rowSet.setUrl(Ustawienia.URL);
			rowSet.setUsername(Ustawienia.USER);
			rowSet.setPassword(Ustawienia.PASSWD);
			rowSet.setAutoCommit(false);
			rowSet.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

			String sql = "SELECT employee_id, first_name, last_name, salary FROM employees WHERE job_id = ?";
			rowSet.setCommand(sql);
			rowSet.setString(1, JOB);
			rowSet.execute();
			
			while (rowSet.next()) {
				BigDecimal pensja = rowSet.getBigDecimal("salary");
				System.out.printf("%s %s zarabia %s%n",
						rowSet.getString("first_name"), rowSet.getString("last_name"), pensja);
				pensja = pensja.add(ZMIANA);
				System.out.println("  ale teraz zmieniam mu pensję na " + pensja);
				
				rowSet.updateBigDecimal("salary", pensja);
				rowSet.updateRow();
				
			}
			System.out.println();
			
			int coRobic = JOptionPane.showConfirmDialog(null, "Czy zakomitować zmiany?");
			switch(coRobic) {
			case JOptionPane.YES_OPTION:
				rowSet.commit();
				break;
			case JOptionPane.NO_OPTION:
				rowSet.rollback();
				break;
			case JOptionPane.CANCEL_OPTION:
			default:
				// do nothing
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
