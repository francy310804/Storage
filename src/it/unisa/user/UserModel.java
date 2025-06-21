package it.unisa.user;

import java.sql.SQLException;

public interface UserModel {
	
	public void doSave(UserBean user) throws SQLException;

	public boolean doDelete(String email) throws SQLException;

	public UserBean doRetrieveByKey(String email) throws SQLException;
		
	//public Collection<ProductBean> doRetrieveAll(String order) throws SQLException;
}
