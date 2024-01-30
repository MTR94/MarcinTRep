package sklep.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection implements AutoCloseable {
	private Connection sqlConnection;

	private DBConnection(Connection sqlConnection) {
		this.sqlConnection = sqlConnection;
	}

	public static DBConnection open() throws DBException {
		return open(false);
	}
	
	public static DBConnection open(boolean autoCommit) throws DBException {
		try {
			Properties props = DBSettings.load();
			if(props.containsKey("driver_class")) {
				Class.forName(props.getProperty("driver_class"));
			}
			Connection c = DriverManager.getConnection(props.getProperty("url") , props);
			c.setAutoCommit(autoCommit);
			return new DBConnection(c);
		} catch (ClassNotFoundException | SQLException e) {
			throw new DBException("Cannot connect to postgresql: " + e, e);
		}
	}

	public static DBConnection openLocalhost() throws DBException {
		try {
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost/sklep", "kurs", "abc123");
			c.setAutoCommit(false);
			return new DBConnection(c);
		} catch (SQLException e) {
			throw new DBException("Cannot connect to postgresql: " + e, e);
		}
	}

	@Override
	public void close() {
		try {
			if (sqlConnection != null) {
				sqlConnection.close();
				sqlConnection = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public Connection getSqlConnection() {
		return sqlConnection;
	}
	
	public void commit() throws DBException {
		try {
			sqlConnection.commit();
		} catch (SQLException e) {
			throw new DBException("Error during commit: " + e.getMessage(), e);
		}
	}

	public void rollback() throws DBException {
		try {
			sqlConnection.rollback();
		} catch (SQLException e) {
			throw new DBException("Error during rollback: " + e.getMessage(), e);
		}
	}

	public ProductDAO productDAO() {
		return new ProductDAO(this);
	}

	public CustomerDAO customerDAO() {
		return new CustomerDAO(this);
	}

	public OrderDAO orderDAO() {
		return new OrderDAO(this);
	}
}
