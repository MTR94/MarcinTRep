package sklep.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sklep.db.RecordNotFound;

@WebServlet("/photo")
public class Photo extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /* Ten serwlet wczytuje z dysku plik ze zdjęciem o podanym numerze (z parametru productId).
     * Aby odesłać odpowiedź "binarną" (a nie tekstową) używamy getOutputStream() zamiast getWriter().
     * Aby przeglądarka wiedziała, że otrzymuje grafikę, ustawiamy content-type image/jpeg.
     */

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String parametrId = request.getParameter("productId");
        if(parametrId == null) {
            return;
        }

        try {
            int id = Integer.parseInt(parametrId);
            byte[] bytes = PhotoUtil.readBytes(id);
            response.setContentType("image/jpeg");
            ServletOutputStream output = response.getOutputStream();
            output.write(bytes);
            output.close();
        } catch (RecordNotFound e) {
            response.setStatus(404);
            response.setContentType("text/plain");
            response.setCharacterEncoding("utf-8");
            response.getWriter().println("Nie ma zdjęcia dla produktu o nr " + parametrId);
        } catch (Exception e) {
            response.setStatus(500);
            e.printStackTrace();
        }
    }

}



