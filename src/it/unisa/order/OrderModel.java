package it.unisa.order;

import java.sql.SQLException;
import java.util.List;

public interface OrderModel {
	
	public void doSaveOrder(int id, List<ItemOrder> l, double totale) throws SQLException;
	
	public List<FatturaBean> RetrieveFattura(int id) throws SQLException; //tramite id utente
	
	public List<ItemOrder> RetrieveByFattura(int id) throws SQLException;
	
	public void doSaveReview(Review r) throws SQLException;
	
	public List<Review> getReviewsByProductId(int productId) throws SQLException;

}
