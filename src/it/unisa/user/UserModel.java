package it.unisa.user;

import java.sql.SQLException;
import java.util.Collection;


public interface UserModel {
	
	public void doSave(UserBean user) throws SQLException;

	public boolean doDelete(String email) throws SQLException;

	public UserBean doRetrieveByKey(String email) throws SQLException;
	
	public void doUpdate(String email, UserBean user) throws SQLException;
		
	//public Collection<UserBean> doRetrieveAll() throws SQLException;
}
