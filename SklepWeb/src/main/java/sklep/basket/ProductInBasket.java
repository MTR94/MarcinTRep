package sklep.basket;

import java.math.BigDecimal;
import java.util.Objects;

public class ProductInBasket {
    private int productId;
    private String productName;
    private BigDecimal price;
    private int quantity;

    public ProductInBasket(int productId, String productName, BigDecimal price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    @Override
    public String toString() {
        return "ElementKoszyka [productId=" + productId + ", productName=" + productName + ", price=" + price
                + ", quantity=" + quantity + "]";
    }

    @Override
    public int hashCode() {
        return Objects.hash(price, productId, productName, quantity);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProductInBasket other = (ProductInBasket) obj;
        return Objects.equals(price, other.price) && productId == other.productId
                && Objects.equals(productName, other.productName) && quantity == other.quantity;
    }

    public BigDecimal getValue() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    public void increaseQuantity(int change) {
        quantity += change;
    }

}


