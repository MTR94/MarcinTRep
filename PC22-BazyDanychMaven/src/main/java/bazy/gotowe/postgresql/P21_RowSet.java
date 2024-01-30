package bazy.gotowe.postgresql;

import javax.sql.RowSet;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;

public class P21_RowSet {

	public static void main(String[] args) {
		try {
			//Class.forName("org.postgresql.Driver");

			RowSetFactory rsf = RowSetProvider.newFactory();
			RowSet rowSet = rsf.createJdbcRowSet();
			//RowSet rowSet = rsf.createCachedRowSet(); // też działa
			rowSet.setUrl(Ustawienia.URL);
			rowSet.setUsername(Ustawienia.USER);
			rowSet.setPassword(Ustawienia.PASSWD);

			// Moim skromnym zdaniem to przykład złej praktyki "low cohesion" - namieszane za dużo rzeczy w jednej klasie...
			
			String sql = "SELECT first_name, last_name, salary "
					+ "FROM employees WHERE salary BETWEEN ? AND ?";

			rowSet.setCommand(sql);
			rowSet.setInt(1, 8000);
			rowSet.setInt(2, 10000);

			rowSet.execute();
			
			while (rowSet.next()) {
				System.out.printf("%s %s zarabia %s%n", rowSet.getString(1), rowSet.getString(2),
						rowSet.getBigDecimal(3));
			}
			System.out.println();
			
			rowSet.setCommand("SELECT * FROM countries");
			rowSet.execute();
			
			while (rowSet.next()) {
				System.out.println(rowSet.getString(2));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
