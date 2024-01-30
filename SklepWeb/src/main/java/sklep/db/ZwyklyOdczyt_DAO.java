package sklep.db;

import java.util.List;

import sklep.model.Product;

public class ZwyklyOdczyt_DAO {

	public static void main(String[] args) {
		try(DBConnection db = DBConnection.open()) {
			ProductDAO productDAO = db.productDAO();
			List<Product> products = productDAO.readAll();
			for (Product product : products) {
				System.out.println(product);
			}
		} catch (DBException e) {
			e.printStackTrace();
		}
	}

}
