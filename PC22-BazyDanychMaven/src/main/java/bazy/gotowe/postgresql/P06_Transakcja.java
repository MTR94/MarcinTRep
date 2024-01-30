package bazy.gotowe.postgresql;

import javax.swing.*;
import java.math.BigDecimal;
import java.sql.*;

public class P06_Transakcja {

    public static void main(String[] args) {
        try (Connection c = DriverManager.getConnection(Ustawienia.URL, Ustawienia.USER, Ustawienia.PASSWD)) {
            c.setAutoCommit(false);
            c.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);     // cudze zmiany widzimy dopiero wtedy, gdy zostaną zakomitowane
            // c.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ); // nie widzimy cudzych zmian w czasie traksakcji, kolejne selecty zwracają te same wartości (o ile sami nie edytujemy)
            // c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);    // nasze zmiany nie zamażą cudzych zmian - ale możemy dostać wyjątek gdy próbujemy zmeiniać rekordy
            // c.setReadOnly(true); // tutaj nie ma sensu, ale może mieć sens:
            JOptionPane.showMessageDialog(null, "Połączyliśmy się i ustawiliśmy transakcję...");

            String kogoSzukac = JOptionPane.showInputDialog("Podaj kod stanowiska:");
            double srednia1 = sredniaPensja(c, kogoSzukac);
            JOptionPane.showMessageDialog(null, "Średnia przed zmianą: " + srednia1);

            BigDecimal podwyzka = new BigDecimal(JOptionPane.showInputDialog("Podaj kwotę podwyżki:"));
            int ile = podwyzka(c, podwyzka, kogoSzukac);
            double srednia2 = sredniaPensja(c, kogoSzukac);
            JOptionPane.showMessageDialog(null, ile + "rekordów zmienionych.\nŚrednia po zmianie: " + srednia2);

            int wybor = JOptionPane.showConfirmDialog(null, "Czy zapisać zmiany?");
            String coSieStalo;
            switch (wybor) {
                case JOptionPane.YES_OPTION:
                    c.commit();
                    coSieStalo = "commit";
                    break;
                case JOptionPane.NO_OPTION:
                    c.rollback();
                    coSieStalo = "rollback";
                    break;
                default:
                    coSieStalo = "cancel";
                    // Cancel - nie robimy nic
            }

            double srednia3 = sredniaPensja(c, kogoSzukac);
            JOptionPane.showMessageDialog(null, "Średnia po " +coSieStalo +": " + srednia3);

            JOptionPane.showMessageDialog(null, "Rozłączamy się...");

        } catch (SQLException e) {
			e.printStackTrace();
		}
    }

    private static double sredniaPensja(Connection c, String jobId) {
        final String sql2 = "SELECT avg(salary) FROM employees WHERE job_id = ?";
        try(PreparedStatement stmt2 = c.prepareStatement(sql2)) {
            stmt2.setString(1, jobId);
            try(ResultSet rs = stmt2.executeQuery()) {
                if(rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    private static int podwyzka(Connection c, BigDecimal zmiana, String jobId) {
        String sql = "UPDATE employees SET salary = salary + ? WHERE job_id = ?";
        try(PreparedStatement stmt = c.prepareStatement(sql)) {
            stmt.setBigDecimal(1, zmiana);
            stmt.setString(2, jobId);
            int ile = stmt.executeUpdate();
            return ile;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
