package sklep.db;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sklep.model.Customer;

public class CustomerDAO {
	private final DBConnection db;

	CustomerDAO(DBConnection db) {
		this.db = db;
	}

	public Customer findByEmail(String email) throws DBException, RecordNotFound {
		final String sql = "SELECT * FROM customers WHERE customer_email = ?";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setString(1, email);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return customerFromRS(rs);
				} else {
					throw new RecordNotFound("Cannot find customer with email " + email);
				}
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in CustomerDAO.findById: " + e.getMessage(), e);
		}
	}

	public List<Customer> readAll() throws DBException {
		final String sql = "SELECT * FROM customers";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			try (ResultSet rs = stmt.executeQuery()) {
				return customerListFromRS(rs);
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in CustomerDAO.readAll: " + e.getMessage(), e);
		}
	}

	private List<Customer> customerListFromRS(ResultSet rs) throws SQLException {
		List<Customer> records = new ArrayList<>();
		while (rs.next()) {
			Customer product = customerFromRS(rs);
			records.add(product);
		}
		return records;
	}

	private Customer customerFromRS(ResultSet rs) throws SQLException {
		return new Customer(
				rs.getString("customer_email"),
				rs.getString("customer_name"),
				rs.getString("phone_number"),
				rs.getString("address"),
				rs.getString("postal_code"),
				rs.getString("city"));
	}
	
    public void insert(Customer customer) throws DBException {
    	// używać gdy obiekt ma wpisane ID (tu: email)
        final String sql = "INSERT INTO customers("
                + "customer_email, customer_name, phone_number, address, postal_code, city)"
                + " VALUES (?, ?, ?, ?, ?, ?)";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setString(1, customer.getEmail());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getPhoneNumber());
            stmt.setString(4, customer.getAddress());
            stmt.setString(5, customer.getPostalCode());
            stmt.setString(6, customer.getCity());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DBException("Error during INSERT CUSTOMER", e);
        }
    }

    public boolean update(Customer customer) throws DBException {
        final String sql = "UPDATE customers SET "
                + " customer_name=?, phone_number=?, address=?, postal_code=?, city=?"
                + " WHERE customer_email = ?";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getPhoneNumber());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getPostalCode());
            stmt.setString(5, customer.getCity());
            stmt.setString(6, customer.getEmail());
            int count = stmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            throw new DBException("Error during UPDATE CUSTOMER", e);
        } 
    }
    
	public void save(Customer customer) throws DBException {
		if(customer.getEmail() == null) {
			throw new IllegalArgumentException("Customer email cannot be null");
		} else {
			if(! update(customer)) {
				insert(customer);
			}
		}
	}
	
	public boolean delete(String email) throws DBException {
        final String sql = "DELETE FROM customers WHERE customer_email = ?";
        try(PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
            stmt.setString(1, email);
            int count = stmt.executeUpdate();
            return count > 0;
        } catch (SQLException e) {
            throw new DBException("Error during DELETE CUSTOMER", e);
        } 
    }

	public boolean delete(Customer customer) throws DBException {
		return delete(customer.getEmail());
    }
	
}
