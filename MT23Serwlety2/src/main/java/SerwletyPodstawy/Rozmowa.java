package SerwletyPodstawy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/rozmowa")
public class Rozmowa extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        final String poczatek = """
            	<!DOCTYPE html>
            	<html>
            	<head>
            	<title>Rozmowa serlwetowa</title>
            	</head>
            	<body>""";
        final String formularz = """
            	<form>
            	<input name="imie">
            	<button>Wyślij</button>
            	</form>""";
        final String koniec = """
            	</body>
            	</html>""";
        response.setContentType("text/html"); // MIME type / Content-Type
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println(poczatek);
        out.println(formularz);
        out.println(koniec);
        String imie = request.getParameter("imie");
        if(imie != null && imie.isEmpty()) {
            out.println(("<p> Witaj " + imie + "</p>"));
        }
        out.println(koniec);



    }
}




