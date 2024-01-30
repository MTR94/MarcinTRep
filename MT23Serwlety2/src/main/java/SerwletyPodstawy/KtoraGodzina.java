package SerwletyPodstawy;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/godzina")
public class KtoraGodzina extends HelloServlet {
    private boolean LocalDateTime;
    private boolean LocalDate;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");


        PrintWriter out = response.getWriter();
        out.println("Witaj świecie!");
        out.println("Bierzący czas "+ java.time.LocalDateTime.now());
    }
}
