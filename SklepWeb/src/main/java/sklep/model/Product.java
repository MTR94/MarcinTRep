package sklep.model;

import java.math.BigDecimal;
import java.util.Objects;

public class Product {
	private Integer productId;
	private String productName;
	private BigDecimal price;
	private BigDecimal vat;
	private String description;
	
	public Product() {
	}
	
	public Product(Integer productId, String productName, BigDecimal price, BigDecimal vat, String description) {
		this.productId = productId;
		this.productName = productName;
		this.price = price;
		this.vat = vat;
		this.description = description;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	
	public BigDecimal getVat() {
		return vat;
	}
	
	public void setVat(BigDecimal vat) {
		this.vat = vat;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public int hashCode() {
		return Objects.hash(description, price, vat, productId, productName);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Product other = (Product) obj;
		return Objects.equals(productId, other.productId) && Objects.equals(productName, other.productName)
				&& Objects.equals(price, other.price)
				&& Objects.equals(vat, other.vat)
				&& Objects.equals(description, other.description);
	}

	@Override
	public String toString() {
		return "Product [productId=" + productId + ", productName=" + productName + ", price=" + price + ", vat=" + vat
				+ ", description=" + description + "]";
	}

	public String toHtml() {
        return String.format("<div class='product'>"
                + "<h2>%s</h2>"
                + "<p>(nr %d)</p>"
                + "<p>Cena: <strong>%,.2f PLN</strong></p>"
                + "<p>%s</p>"
                + "</div>",
                getProductName(),
                getProductId(),
                getPrice(),
                getDescription());
	}

}
