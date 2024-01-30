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

@WebServlet("/products1")
public class Products1 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest requets, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println("Zaraz odczytam produkty z bazy za pomocą DAO...");

        try(DBConnection db = DBConnection.open()) {
            ProductDAO productDAO = db.productDAO();
            List<Product> products = productDAO.readAll();
            for(Product product : products) {
                out.println(product);
            }
        } catch(DBException e) {
            e.printStackTrace();
        }
    }

}



