package it.unisa.product;

import java.sql.SQLException;
import java.util.Collection;
import java.util.List;

import it.unisa.order.ItemOrder;

public interface ProductModel {
	
	public void doSave(ProductBean product) throws SQLException;
	
	public boolean doDelete(int code) throws SQLException;

	public ProductBean doRetrieveByKey(int code) throws SQLException;
	
	public Collection<ProductBean> doRetrieveAll(String order) throws SQLException;
	
	public String doRetrieveByName(String name) throws SQLException;
	
	public void doUpdate(ProductBean product) throws SQLException;
	
	public Collection<ProductBean> doRetrieveAllForAdmin(String order) throws SQLException;
	   
	}
