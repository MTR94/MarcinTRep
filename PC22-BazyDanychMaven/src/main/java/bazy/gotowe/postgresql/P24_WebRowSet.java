package bazy.gotowe.postgresql;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.Writer;

import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;
import javax.sql.rowset.WebRowSet;

/* WebRowSet pozwala wyeksportować dane do formatu XML
*/
public class P24_WebRowSet {

	public static void main(String[] args) {
		try {
			System.out.println("Start");
			RowSetFactory rsf = RowSetProvider.newFactory();
			WebRowSet rowSet = rsf.createWebRowSet();
			rowSet.setUrl(Ustawienia.URL);
			rowSet.setUsername(Ustawienia.USER);
			rowSet.setPassword(Ustawienia.PASSWD);

			String sql = "SELECT * FROM employees LEFT JOIN jobs USING(job_id) LEFT JOIN departments USING (department_id) LEFT JOIN locations USING (location_id) LEFT JOIN countries USING (country_id) ORDER BY employee_id";
			rowSet.setCommand(sql);

			System.out.println("Zadaję zapytanie");
			rowSet.execute();
			
			System.out.println("Eksportuję XML");
			try(Writer out = new BufferedWriter(new FileWriter("employees.xml"))) {
				rowSet.writeXml(out);
			}
			System.out.println("Gotowe");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
