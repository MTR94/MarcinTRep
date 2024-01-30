package sklep.db;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sklep.model.Product;

/* DAO - Data Access Object(s) 

Dostęp do baz danych oparty o takie zasady:
tabelom bazodanowym odpowiadają klasy w naszej aplikacji
np. dla tabeli products mamy klasę Product  (w pakiecie model)
dla takie pary tabela products + klasa Product tworzymy klasę narzędziową ProductDAO , której zadaniem jest obsługa tej tabeli: odczyt, zapis, wyszukiwanie, i inne operacje jeśli są potrzebne.
*/

public class ProductDAO {
	private static final BigDecimal MAX_PRICE = new BigDecimal(1_000_000_000);
	private static final String[] ID_COLUMNS = {"product_id"};
	
	private final DBConnection db;

	ProductDAO(DBConnection db) {
		this.db = db;
	}

	public Product findById(int productId) throws DBException, RecordNotFound {
		final String sql = "SELECT * FROM products WHERE product_id = ?";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setInt(1, productId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return productFromRS(rs);
				} else {
					throw new RecordNotFound("Cannot find product with id " + productId);
				}
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in ProductDAO.findById: " + e.getMessage(), e);
		}
	}

	public List<Product> readAll() throws DBException {
		final String sql = "SELECT * FROM products ORDER BY product_id";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			try (ResultSet rs = stmt.executeQuery()) {
				return productListFromRS(rs);
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in ProductDAO.readAll: " + e.getMessage(), e);
		}
	}

	public List<Product> findByPrice(BigDecimal minPrice, BigDecimal maxPrice) throws DBException {
		final String sql = "SELECT * FROM products WHERE price BETWEEN ? AND ? ORDER BY product_id";
		if(minPrice == null)
			minPrice = BigDecimal.ZERO;
		
		if(maxPrice == null)
			maxPrice = MAX_PRICE;

		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setBigDecimal(1, minPrice);
			stmt.setBigDecimal(2, maxPrice);
			try (ResultSet rs = stmt.executeQuery()) {
				return productListFromRS(rs);
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in ProductDAO.findByPrice: " + e.getMessage(), e);
		}
	}

	private List<Product> productListFromRS(ResultSet rs) throws SQLException {
		List<Product> products = new ArrayList<>();
		while (rs.next()) {
			Product product = productFromRS(rs);
			products.add(product);
		}
		return products;
	}

	private Product productFromRS(ResultSet rs) throws SQLException {
		return new Product(
				rs.getInt("product_id"),
				rs.getString("product_name"),
				rs.getBigDecimal("price"),
				rs.getBigDecimal("vat"),
				rs.getString("description"));
	}
	
    public void insert(Product product) throws DBException {
    	// używać gdy obiekt ma wpisane ID
        final String sql = "INSERT INTO products("
                + " product_id, product_name, price, vat, description)"
                + " VALUES (?, ?, ?, ?, ?)";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setInt(1, product.getProductId());
            stmt.setString(2, product.getProductName());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setBigDecimal(4, product.getVat());
            stmt.setString(5, product.getDescription());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DBException("Error during INSERT PRODUCT", e);
        }
    }

    public void insertNew(Product product) throws DBException {
    	// używać gdy obiekt nie ma wpisanego ID (productID == null)
        final String sql = "INSERT INTO products("
                + " product_name, price, vat, description)"
                + " VALUES (?, ?, ?, ?)";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql, ID_COLUMNS)) {
            stmt.setString(1, product.getProductName());
            stmt.setBigDecimal(2, product.getPrice());
            stmt.setBigDecimal(3, product.getVat());
            stmt.setString(4, product.getDescription());
            stmt.executeUpdate();

    		try (ResultSet rs = stmt.getGeneratedKeys()) {
    			if(rs.next()) {
    				// w obiekcie, który mamy w pamięci, uzupełniamy brakujące ID na podstawie tego, co wygenerowała baza
    				product.setProductId(rs.getInt(1));
    			}
    		};

        } catch (SQLException e) {
            throw new DBException("Error during INSERT PRODUCT", e);
        }
    }

    public boolean update(Product product) throws DBException {
        final String sql = "UPDATE products SET "
                + " product_name = ?, price = ?, vat = ?, description = ?"
                + " WHERE product_id = ?";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setString(1, product.getProductName());
            stmt.setBigDecimal(2, product.getPrice());
            stmt.setBigDecimal(3, product.getVat());
            stmt.setString(4, product.getDescription());
            stmt.setInt(5, product.getProductId());
            int count = stmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            throw new DBException("Error during UPDATE PRODUCT", e);
        } 
    }
    
	public void save(Product product) throws DBException {
		if(product.getProductId() == null) {
			// wstawiamy nowy rekord korzystajac z sekwecji
			insertNew(product);
		} else {
			if(! update(product)) {
				insert(product);
			}
		}
	}
	
	public boolean delete(int productId) throws DBException {
        final String sql = "DELETE FROM products WHERE product_id = ?";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setInt(1, productId);
            int count = stmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            throw new DBException("Error during DELETE PRODUCT", e);
        } 
    }

	public boolean delete(Product product) throws DBException {
		return delete(product.getProductId());
    }
	
}
