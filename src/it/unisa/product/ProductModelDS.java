package it.unisa.product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import it.unisa.order.ItemOrder;

import java.sql.Statement;

public class ProductModelDS implements ProductModel {
	private static DataSource ds;
	
	static {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			
			ds = (DataSource) envCtx.lookup("jdbc/progettoTSW");

		} catch (NamingException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}

	private static final String TABLE_NAME = "Prodotto";
	
	public synchronized void doSave(ProductBean product) throws SQLException {

		Connection connection = null;
		PreparedStatement preparedStatement = null;

		String insertSQL = "INSERT INTO " + ProductModelDS.TABLE_NAME
				+ " (nome, categoria, descrizione, stato, lingua, iva, prezzo, stock, linkAccesso, linkImg) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL);
			preparedStatement.setString(1, product.getNome());
			preparedStatement.setString(2, product.getCategoria());
			preparedStatement.setString(3, product.getDescrizione());
			preparedStatement.setBoolean(4, product.getStato());
			preparedStatement.setString(5, product.getLingua());
			preparedStatement.setInt(6, product.getIva());
			preparedStatement.setFloat(7, product.getPrezzo());
			preparedStatement.setInt(8, product.getStock());
			preparedStatement.setString(9, product.getLinkAccesso());
			preparedStatement.setString(10, product.getLinkImg());
			
			preparedStatement.executeUpdate();
		} finally {
			try {
				if(preparedStatement != null)
					preparedStatement.close();
			} finally {
				if(connection != null)
					connection.close();
			}
		}
		}

	public synchronized boolean doDelete(int code) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		
		int result = 0;
		
		String deleteSql = "DELETE FROM "  + ProductModelDS.TABLE_NAME + " WHERE idProdotto = ?";
		
		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(deleteSql);
			preparedStatement.setInt(1, code);
			
			result = preparedStatement.executeUpdate();
			
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				if (connection != null)
					connection.close();
			}
		}
		
		return (result != 0);
	}
	
	public synchronized ProductBean doRetrieveByKey(int code) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		
		ProductBean bean = new ProductBean();
		
		String selectSQL = "SELECT * FROM " + ProductModelDS.TABLE_NAME + " WHERE idProdotto = ?";
		
		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(selectSQL);
			preparedStatement.setInt(1, code);
			
			ResultSet rs = preparedStatement.executeQuery();
			
			while(rs.next()) {				
				bean.setIdProdotto(rs.getInt("idProdotto"));
				bean.setNome(rs.getString("nome"));
				bean.setCategoria(rs.getString("categoria"));
				bean.setDescrizione(rs.getString("descrizione"));
				bean.setStato(rs.getBoolean("stato"));
				bean.setLingua(rs.getString("lingua"));
				bean.setIva(rs.getInt("iva"));
				bean.setPrezzo(rs.getFloat("prezzo"));
				bean.setStock(rs.getInt("stock"));
				bean.setLinkAccesso(rs.getString("linkAccesso"));
				bean.setlinkImg(rs.getString("linkImg"));
			}
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				if (connection != null)
					connection.close();
			}
		}
		return bean;
	}
	
	
	public synchronized Collection<ProductBean> doRetrieveAll(String order) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		
		Collection<ProductBean> products = new LinkedList<ProductBean>();
		
		String selectSql = "SELECT * FROM " + ProductModelDS.TABLE_NAME;
		
		if (order != null && !order.equals("")) {
			selectSql += " ORDER BY " + order;
		}
		
		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(selectSql);

			ResultSet rs = preparedStatement.executeQuery();
			
			while(rs.next()) {
				ProductBean bean = new ProductBean();
				
				bean.setIdProdotto(rs.getInt("idProdotto"));
				bean.setNome(rs.getString("nome"));
				bean.setCategoria(rs.getString("categoria"));
				bean.setDescrizione(rs.getString("descrizione"));
				bean.setStato(rs.getBoolean("stato"));
				bean.setLingua(rs.getString("lingua"));
				bean.setIva(rs.getInt("iva"));
				bean.setPrezzo(rs.getFloat("prezzo"));
				bean.setStock(rs.getInt("stock"));
				bean.setLinkAccesso(rs.getString("linkAccesso"));
				bean.setlinkImg(rs.getString("linkImg"));
				
				products.add(bean);
			}
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				if (connection != null)
					connection.close();
			}
		}
		return products;
	}
	
	public synchronized String doRetrieveByName(String name) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		
		String selectSql = "SELECT * FROM " + ProductModelDS.TABLE_NAME+ " WHERE nome LIKE ? ";
		
		StringBuilder json = new StringBuilder();
		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(selectSql);
			preparedStatement.setString(1, "%"+name+"%");
			
			ResultSet rs = preparedStatement.executeQuery();
				
			json.append("[");

			boolean first = true;
			while(rs.next()) {
			    if (!first) {
			        json.append(",");
			    } else {
			        first = false;
			    }
			    json.append("{"
			        + "\"idProdotto\":" + rs.getInt("idProdotto") + ","
			        + "\"nome\":\"" + escapeJson(rs.getString("nome")) + "\","
			        + "\"categoria\":\"" + escapeJson(rs.getString("categoria")) + "\","
			        + "\"descrizione\":\"" + escapeJson(rs.getString("descrizione")) + "\","
			        + "\"stato\":" + rs.getBoolean("stato") + ","
			        + "\"lingua\":\"" + escapeJson(rs.getString("lingua")) + "\","
			        + "\"iva\":" + rs.getInt("iva") + ","
			        + "\"prezzo\":" + rs.getFloat("prezzo") + ","
			        + "\"stock\":" + rs.getInt("stock") + ","
			        + "\"linkAccesso\":\"" + escapeJson(rs.getString("linkAccesso")) + "\","
			        + "\"linkImg\":\"" + escapeJson(rs.getString("linkImg")) + "\""
			        + "}");
			}
			json.append("]");
			
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
			} finally {
				if (connection != null)
					connection.close();
			}
		}System.out.println("doRetrieveByName result: " + json.toString());
	    return json.toString();
	}
	
	public String escapeJson(String s) {
    if (s == null) return "";
    return s.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
}
	
}
