package SerwletyPodstawy;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ping")
public class Ping extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Ping() {
        System.out.println("Powstaje obiekt serwletu");
    }

    @Override
    public void init() {
        System.out.println("init");
    }

    @Override
    public void destroy() {
        System.out.println("destroy");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* Gdy uruchamiamy / wgrywamy aplikację, serwer tworzy obiekt tej klasy (serwletu, np. Ping).
         * Gdy przychodzi zapytanie HTTP typu GET skierowane pod adres tego serwletu (np. /Ping),
         * serwer wywołuje metodę doGet i w obiekcie request przekazuje nam informację o zapytaniu (adres, parametry, w przypadku metody POST także treść),
         * natomiast obiekt response dostajemy po to, aby za jego pomocą wygenerować odpowiedź.
         */
        String addr = request.getRemoteAddr();
        int port = request.getRemotePort();
        String userAgent = request.getHeader("User-Agent");
        LocalDateTime dt = LocalDateTime.now();

        System.out.println(dt + ": zapytanie z adresu " + addr + ":" + port + " z przeglądarki\n" + userAgent);
    }
}