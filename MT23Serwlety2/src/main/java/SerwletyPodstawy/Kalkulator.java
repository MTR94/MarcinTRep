package SerwletyPodstawy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/kalkulator")
public class Kalkulator extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		final String poczatek = """
            	<!DOCTYPE html>
            	<html>
            	<head>
            	<title>Kalulator serlwetowy</title>
            	</head>
            	<body>""";
		final String formularz = """
            	<form>
            	<input name="liczba1" type="number">
            	<select name='operacja'>
                	<option value='+'>+</option>
                	<option value='-'>-</option>
                	<option value='*'>*</option>
                	<option value='/'>/</option>
            	</select>
            	<input name="liczba2" type="number">
            	<br/>
            	<button>Oblicz</button>
            	</form>""";


		final String koniec = """
            	</body>
            	</html>""";
		response.setContentType("text/html"); // MIME type / Content-Type
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.println(poczatek);
		out.println(formularz);

		String parametr1 = request.getParameter("liczba1");
		String parametr2 = request.getParameter("liczba2");
		String operacja = request.getParameter("operacja");
		if(parametr1 != null && !parametr1.isBlank()
				&& parametr2 != null && !parametr1.isBlank()
				&& operacja != null && !operacja.isBlank()) {
			try {
				long liczba1 = Long.parseLong(parametr1);
				long liczba2 = Long.parseLong(parametr2);
				long wynik = oblicz(liczba1, liczba2, operacja);
				out.printf("<div>%d %s %d = <strong>%d</strong></div>", liczba1, operacja, liczba2, wynik);
			} catch (NumberFormatException e) {
				out.println("Niepoprawny format liczby");
			}
		}

		out.println(koniec);
	}

	private long oblicz(long liczba1, long liczba2, String operacja) {
		return switch(operacja) {
			case "+" -> liczba1 + liczba2;
			case "-" -> liczba1 - liczba2;
			case "*" -> liczba1 * liczba2;
			case "/" -> liczba1 / liczba2;
			default -> 0;
		};
	}
}



