package it.unisa.admin;

import java.sql.*;
import it.unisa.DriverManagerConnectionPool;

public class AdminModel {
		private static final String TABLE_NAME = "amministratore";
		public synchronized void doSave(AdminBean admin) throws SQLException {
			 
			Connection connection = null;
			PreparedStatement preparedStatement = null;
		    ResultSet rs = null;


			String insertSQL = "INSERT INTO " + AdminModel.TABLE_NAME
					+ " (email, nome, cognome, password) VALUES (?, ?, ?, ?)";

			try {
				connection = DriverManagerConnectionPool.getConnection();
				preparedStatement = connection.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);;
				preparedStatement.setString(1, admin.getEmail());
				preparedStatement.setString(2, admin.getNome());
				preparedStatement.setString(3, admin.getCognome());
				preparedStatement.setString(4, admin.getPassword());

				preparedStatement.executeUpdate();
				connection.commit();
				  rs = preparedStatement.getGeneratedKeys();
			        if (rs.next()) {
			            int idGenerato = rs.getInt(1);
			            admin.setId(idGenerato); // IMPORTANTISSIMO
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

		public synchronized AdminBean doRetrieveByKey(String email) throws SQLException {
			Connection connection = null;
			PreparedStatement preparedStatement = null;

			AdminBean bean = null;

			String selectSQL = "SELECT * FROM " + AdminModel.TABLE_NAME + " WHERE email = ?";

			try {
				connection = DriverManagerConnectionPool.getConnection();
				preparedStatement = connection.prepareStatement(selectSQL);
				preparedStatement.setString(1, email);
				
				ResultSet rs = preparedStatement.executeQuery();

				while (rs.next()) {
					bean = new AdminBean();
					bean.setId(rs.getInt(1));
					bean.setEmail(rs.getString(2));
					bean.setNome(rs.getString(3));
					bean.setCognome(rs.getString(4));
					bean.setPassword(rs.getString(5));

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

		public synchronized boolean doDelete(String email) throws SQLException {
			Connection connection = null;
			PreparedStatement preparedStatement = null;

			int result = 0;

			String deleteSQL = "DELETE FROM " + AdminModel.TABLE_NAME + " WHERE email = ?";

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
		
		
	}
