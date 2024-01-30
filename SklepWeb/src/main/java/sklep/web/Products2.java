package sklep.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sklep.db.DBConnection;
import sklep.db.DBException;
import sklep.db.ProductDAO;
import sklep.model.Product;

@WebServlet("/products2")
public class Products2 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest requets, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Lista produktów</title>");
        out.println("<link rel='stylesheet' type='text/css' href='styl.css'>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Produkty</h1>");
        try(DBConnection db = DBConnection.open()) {
            ProductDAO productDAO = db.productDAO();
            List<Product> products = productDAO.readAll();
            for(Product product : products) {
                out.println(product.toHtml());
            }
            out.println("</body>");
            out.println("</html>");
        } catch(DBException e) {
            e.printStackTrace();
        }
    }

}




