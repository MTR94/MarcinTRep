package bazy.gotowe.postgresql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class P09_DowolnaKolejnoscResultSet {
	
	public static void main(String[] args) {
		final String sql = "SELECT employee_id, first_name, last_name FROM employees ORDER BY employee_id";
		int[] pozycje = {1, 100, 3, 5, 500, 30, 1, 3};
		
		try(Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
			// Aby przewijanie wyników (takie operacje jak absolute() czy previous()) było możliwe,
			// należy utworzyć zapytanie typu
			// TYPE_SCROLL_INSENSITIVE - wyniki nie są już aktualizowane w trakcie przeglądania; dwa razy odwiedzając ten sam rekord zobaczymy te same dane
			// TYPE_SCROLL_SENSITIVE - wyniki są wrażliwe na zmiany robione na tabelach, dane mogą zmienić się w trakcie
			// TYPE_FORWARD_ONLY - domyślny, w ogóle nie umożliwia przewijania, tylko rs.next()
			try(PreparedStatement stmt = c.prepareStatement(sql,
					ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {

				// możemy sterować ilością rekordów pobieranych jednorazowo przez sieć
				// stmt.setFetchSize(20);
				
				try(ResultSet rs = stmt.executeQuery()) {
					// Metody z "is" w nazwie tylko sprawdzają położenie, ale go nie zmieniają.
					if(rs.isBeforeFirst()) {
						System.out.println("before first");
					}
					if(rs.isFirst()) {
						System.out.println("first");
					}
					if(rs.isAfterLast()) {
						System.out.println("after last");
					}
					if(rs.isLast()) {
						System.out.println("first");
					}
					
//					rs.beforeFirst(); // ustawia pozycję na taką, to jest domyślne ustawienie na samym początku, przed while(rs.next())
//					rs.afterLast(); // ustawia pozycję na taką
//					rs.first(); // ustawia na pierwszy rekord (zwraca false jeśli takiego nie ma)
//					rs.last(); // ustawia na ostatni rekord (zwraca false jeśli takiego nie ma)
//					rs.absolute(nr); // przechodzi do konkretnego numeru wiersza
//					rs.relative(offset); // przesuwa się o tyle wględem pozycji bieżącej
//					rs.next(); // przesuwa do następnego (jak relative(1))
//					rs.previous(); // przesuwa do poprzedniego (jak relative(-1))
										
					for(int poz : pozycje) {
						if(rs.absolute(poz)) {
							int id = rs.getInt(1);
							String imie = rs.getString(2);
							String nazwisko = rs.getString(3);
							
							System.out.printf("\npoz %3d: %d %s %s\n", poz, id, imie, nazwisko);
							if(rs.previous()) {
								nazwisko = rs.getString(3);
								System.out.printf("         ... a poprzedni ma na nazwisko %s\n", nazwisko);
							}
							if(rs.relative(2)) {
								nazwisko = rs.getString(3);
								System.out.printf("         ... a następny ma na nazwisko %s\n", nazwisko);
							}
							
						} else {
							System.out.printf("\npoz %3d - nie ma takiej pozycji\n", poz);
						}
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
