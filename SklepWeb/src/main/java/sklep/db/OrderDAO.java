package sklep.db;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sklep.model.Order;
import sklep.model.OrderProduct;

public class OrderDAO {
	private static final String[] ID_COLUMNS = {"order_id", "order_date"};
	private final DBConnection db;

	OrderDAO(DBConnection db) {
		this.db = db;
	}

	public Order findById(int orderId) throws DBException, RecordNotFound {
		final String sql = "SELECT * FROM orders WHERE order_id = ?";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setInt(1, orderId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return orderFromRS(rs);
				} else {
					throw new RecordNotFound("Cannot find order with id " + orderId);
				}
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in OrderDAO.findById: " + e.getMessage(), e);
		}
	}

	public List<Order> readAll() throws DBException {
		final String sql = "SELECT * FROM orders ORDER BY order_id";
		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			try (ResultSet rs = stmt.executeQuery()) {
				return orderListFromRS(rs);
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in OrderDAO.readAll: " + e.getMessage(), e);
		}
	}

	public List<Order> customerOrders(String email) throws DBException {
		final String sql = "SELECT * FROM orders WHERE customer_email = ? ORDER BY order_id";

		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setString(1, email);
			try (ResultSet rs = stmt.executeQuery()) {
				return orderListFromRS(rs);
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in OrderDAO.customerOrders: " + e.getMessage(), e);
		}
	}

	private List<Order> orderListFromRS(ResultSet rs) throws SQLException, DBException {
		List<Order> orders = new ArrayList<>();
		while (rs.next()) {
			Order order = orderFromRS(rs);
			orders.add(order);
		}
		return orders;
	}

	private Order orderFromRS(ResultSet rs) throws SQLException, DBException {
		Order order = Order.ofDbFields(
				rs.getInt("order_id"),
				rs.getString("customer_email"),
				rs.getTimestamp("order_date"),
				rs.getString("status"));
		order.addProducts(orderProductsForOrder(order.getOrderId()));
		return order;
	}
	
	List<OrderProduct> orderProductsForOrder(int orderId) throws DBException {
		final String sql = "SELECT * FROM order_products WHERE order_id = ? ORDER BY product_id";

		try (PreparedStatement stmt = db.getSqlConnection().prepareStatement(sql)) {
			stmt.setInt(1, orderId);
			try (ResultSet rs = stmt.executeQuery()) {
				List<OrderProduct> ops = new ArrayList<>();
				while(rs.next()) {
					ops.add(orderProductFromRS(rs));
				}
				return ops;
			}
		} catch (SQLException e) {
			throw new DBException("SQL error in OrderDAO.customerOrders: " + e.getMessage(), e);
		}
	}

	private OrderProduct orderProductFromRS(ResultSet rs) throws SQLException {
		return new OrderProduct(rs.getInt("order_id"), rs.getInt("product_id"), rs.getInt("quantity"), rs.getBigDecimal("actual_price"));
	}
	
}
