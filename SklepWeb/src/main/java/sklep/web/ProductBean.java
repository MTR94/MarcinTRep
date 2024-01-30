package sklep.web;

import java.math.BigDecimal;
import java.util.List;

import sklep.db.DBConnection;
import sklep.db.DBException;
import sklep.db.ProductDAO;
import sklep.model.Product;

/* Ta klasa jest po to, aby w skrypcie JSP w wygodny sposób odczytać sobie listę produktów z bazy danych. */
public class ProductBean {
    private BigDecimal minPrice, maxPrice;

    // Chociaż wewnętrznie zmienna jest typu BigDecimal, to gettery i settery napiszemy tak, jakby to były Stringi.
    // Robimy to po to, aby w JSP zadziałało setProperty.
    public String getMinPrice() {
        return minPrice == null ? null : minPrice.toString();
    }

    public void setMinPrice(String minPrice) {
        if(minPrice == null || minPrice.isEmpty()) {
            this.minPrice = null;
        } else {
            this.minPrice = new BigDecimal(minPrice);
        }
    }

    public String getMaxPrice() {
        return maxPrice == null ? null : maxPrice.toString();
    }

    public void setMaxPrice(String maxPrice) {
        if(maxPrice == null || maxPrice.isEmpty()) {
            this.maxPrice = null;
        } else {
            this.maxPrice = new BigDecimal(maxPrice);
        }
    }

    // Metoda wygląda jak getter, ale wewnętrznie czyta dane z bazy, a nie z własnej zmiennej.
    public List<Product> getAllProducts() throws DBException {
        try(DBConnection db = DBConnection.open()) {
            ProductDAO productDAO = db.productDAO();
            return productDAO.readAll();
        }
    }

    // Metoda odczytuje produkty zgodnie z ustawionymi wcześniej kryteriami (w tym przykładzie są to ceny, ale może być więcej filtrów).
    public List<Product> getFilteredProducts() throws DBException {
        try(DBConnection db = DBConnection.open()) {
            return db.productDAO().findByPrice(minPrice, maxPrice);
        }
    }

}





