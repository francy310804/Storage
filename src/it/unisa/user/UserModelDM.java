package it.unisa.user;

import java.sql.*;
import java.util.Collection;
import java.util.LinkedList;

import it.unisa.DriverManagerConnectionPool;
import it.unisa.product.ProductBean;

public class UserModelDM implements UserModel{
	private static final String TABLE_NAME = "Utenti";

	@Override
	public synchronized void doSave(UserBean user) throws SQLException {
		 
		Connection connection = null;
		PreparedStatement preparedStatement = null;
	    ResultSet rs = null;


		String insertSQL = "INSERT INTO " + UserModelDM.TABLE_NAME
				+ " (email, nome, cognome, indirizzo, citta, provincia, cap, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

		try {
			connection = DriverManagerConnectionPool.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);;
			preparedStatement.setString(1, user.getEmail());
			preparedStatement.setString(2, user.getNome());
			preparedStatement.setString(3, user.getCognome());
			preparedStatement.setString(4, user.getIndirizzo());
			preparedStatement.setString(5, user.getCitta());
			preparedStatement.setString(6, user.getProvincia());
			preparedStatement.setInt(7, user.getCap());
			preparedStatement.setString(8, user.getPassword());

			preparedStatement.executeUpdate();
			connection.commit();
			  rs = preparedStatement.getGeneratedKeys();
		        if (rs.next()) {
		            int idGenerato = rs.getInt(1);
		            user.setId(idGenerato); 
		        }
		}catch (SQLException e) {
			if (connection != null) {
				connection.rollback();
			}
			e.printStackTrace();
			throw e;
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				if(connection != null)
					connection.close();
				DriverManagerConnectionPool.releaseConnection(connection);
			}
		}
	}

	@Override
	public synchronized UserBean doRetrieveByKey(String email) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;

		UserBean bean = null;

		String selectSQL = "SELECT * FROM " + UserModelDM.TABLE_NAME + " WHERE email = ?";

		try {
			connection = DriverManagerConnectionPool.getConnection();
			preparedStatement = connection.prepareStatement(selectSQL);
			preparedStatement.setString(1, email);
			
			ResultSet rs = preparedStatement.executeQuery();

			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getInt("id"));
				bean.setCap(rs.getInt("cap"));
				bean.setCitta(rs.getString("citta"));
				bean.setCognome(rs.getString("cognome"));
				bean.setEmail(rs.getString("email"));
				bean.setIndirizzo(rs.getString("indirizzo"));
				bean.setNome(rs.getString("nome"));
				bean.setPassword(rs.getString("password"));
				bean.setProvincia(rs.getString("provincia"));
				bean.setRuolo(rs.getString("ruolo"));

			}

		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				DriverManagerConnectionPool.releaseConnection(connection);
			}
		}
		return bean;
	}

	@Override
	public synchronized boolean doDelete(String email) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;

		int result = 0;

		String deleteSQL = "DELETE FROM " + UserModelDM.TABLE_NAME + " WHERE email = ?";

		try {
			connection = DriverManagerConnectionPool.getConnection();
			preparedStatement = connection.prepareStatement(deleteSQL);
			preparedStatement.setString(1, email);

			result = preparedStatement.executeUpdate();

		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				DriverManagerConnectionPool.releaseConnection(connection);
			}
		}
		return (result != 0);
	}
	
	public void doUpdate(String email, UserBean user) throws SQLException {
	    Connection connection = null;
	    PreparedStatement preparedStatement = null;

	    // Costruzione dinamica della query SQL
	    StringBuilder updateSql = new StringBuilder("UPDATE " + UserModelDM.TABLE_NAME + " SET ");
	    updateSql.append("email = ?, ");
	    updateSql.append("nome = ?, ");
	    updateSql.append("cognome = ?, ");
	    updateSql.append("indirizzo = ?, ");
	    updateSql.append("citta = ?, ");
	    updateSql.append("provincia = ?, ");
	    updateSql.append("cap = ?");

	    // Aggiungi la password solo se non è null
	    if (user.getPassword() != null) {
	        updateSql.append(", password = ?");
	    }

	    updateSql.append(" WHERE email = ?");

	    try {
	        connection = DriverManagerConnectionPool.getConnection();
	        preparedStatement = connection.prepareStatement(updateSql.toString());

	        // Parametri fissi
	        preparedStatement.setString(1, user.getEmail());
	        preparedStatement.setString(2, user.getNome());
	        preparedStatement.setString(3, user.getCognome());
	        preparedStatement.setString(4, user.getIndirizzo());
	        preparedStatement.setString(5, user.getCitta());
	        preparedStatement.setString(6, user.getProvincia());
	        preparedStatement.setInt(7, user.getCap());
	        
	        int paramIndex = 8;
	        
	        // Se la password va aggiornata, la mettiamo qui
	        if (user.getPassword() != null) {
	            preparedStatement.setString(paramIndex, user.getPassword());
	            paramIndex++;
	        }

	        // Ultimo parametro: WHERE email = ?
	        preparedStatement.setString(paramIndex, email);

	        preparedStatement.executeUpdate();
	        connection.commit();
	        
	    } finally {
	        try {
	            if (preparedStatement != null)
	                preparedStatement.close();
	        } finally {
	            DriverManagerConnectionPool.releaseConnection(connection);
	        }
	    }
	}
	
	
	public Collection<UserBean> doRetrieveAll() throws SQLException {
		
	    Connection connection = null;
	    PreparedStatement preparedStatement = null;

	    Collection<UserBean> l = new LinkedList<UserBean>();
	    String Sql = "SELECT * FROM " + UserModelDM.TABLE_NAME;
	    
	    try {
	    	
	        connection = DriverManagerConnectionPool.getConnection();
	        preparedStatement = connection.prepareStatement(Sql);
	        
			ResultSet rs = preparedStatement.executeQuery();
			
			while(rs.next()) {
				
				UserBean a = new UserBean();
				a.setId(rs.getInt("id"));
				a.setCap(rs.getInt("cap"));
				a.setCitta(rs.getString("citta"));
				a.setCognome(rs.getString("cognome"));
				a.setEmail(rs.getString("email"));
				a.setIndirizzo(rs.getString("indirizzo"));
				a.setNome(rs.getString("nome"));
				a.setPassword(rs.getString("password"));
				a.setProvincia(rs.getString("provincia"));
				a.setRuolo(rs.getString("ruolo"));
				
				l.add(a);
			}

	        
	    }  finally {
	        try {
	            if (preparedStatement != null)
	                preparedStatement.close();
	        } finally {
	            DriverManagerConnectionPool.releaseConnection(connection);
	        }
	    };
	    return l;
	}

	
}
	
	
