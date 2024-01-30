package sklep.basket;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sklep.db.DBConnection;
import sklep.db.ProductDAO;
import sklep.model.Product;

@WebServlet("/add_to_basket")
public class AddToBasket extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            try(DBConnection db = DBConnection.open()) {
                ProductDAO productDAO = db.productDAO();
                Product product = productDAO.findById(productId);

                HttpSession sesja = request.getSession();
                Basket basket = (Basket)sesja.getAttribute("basket");
                if(basket == null) {
                    basket = new Basket();
                    sesja.setAttribute("basket", basket);
                }
                basket.addProduct(product);
            }
        } catch(Exception e) {
            // ignorujemy błędy
        }
        // Przekierowanie - każemy przeglądarce wejść pod ten adres.
        response.sendRedirect("products8.jsp");
    }

}


