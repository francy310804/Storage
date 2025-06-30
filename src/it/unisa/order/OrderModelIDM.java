package it.unisa.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import it.unisa.product.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class OrderModelIDM implements OrderModel {
	
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

	
	public synchronized void doSaveOrder(int id, List<ItemOrder> l, double totale) throws SQLException {
	    Connection connection = null;
	    PreparedStatement psOrdine = null;
	    ResultSet rs = null;
	    PreparedStatement psDettagli = null;

	    try {
	        connection = ds.getConnection();
	        connection.setAutoCommit(false); // disabilita autocommit

	        String sqlOrdine = "INSERT INTO Orders (utente, order_date, total_price) VALUES (?, NOW(), ?)";
	        psOrdine = connection.prepareStatement(sqlOrdine, Statement.RETURN_GENERATED_KEYS);
	        psOrdine.setInt(1, id);
	        psOrdine.setDouble(2, totale);
	        psOrdine.executeUpdate();

	        rs = psOrdine.getGeneratedKeys();
	        int idOrdine;
	        if (rs.next()) {
	            idOrdine = rs.getInt(1);
	        } else {
	            throw new SQLException("Errore nella generazione dell'ID ordine.");
	        }

	        String sqlDettagli = "INSERT INTO Order_Details (order_id, product_id, image_url, quantity, price) VALUES (?, ?, ?, ?, ?)";
	        psDettagli = connection.prepareStatement(sqlDettagli);		//ci sta anche l'iva come campo, tolto momentaneamente, mi serve l'sql

	        for (ItemOrder item : l) {
	            psDettagli.setInt(1, idOrdine);
	            psDettagli.setInt(2, item.getItemID());
	            psDettagli.setString(3, item.getLinkImg());
	            psDettagli.setInt(4, item.getNumItems());
	            psDettagli.setDouble(5, item.getUnitCost());
	          //  psDettagli.setDouble(6, item.getIva());
	            psDettagli.executeUpdate();
	        }

	        connection.commit();

	    } catch (SQLException e) {
	        if (connection != null) connection.rollback();
	        throw e;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (psDettagli != null) psDettagli.close();
	            if (psOrdine != null) psOrdine.close();
	            if (connection != null) connection.close();
	        } catch (SQLException ex) {
	            ex.printStackTrace();
	        }
	    }
	}
		
	
	public synchronized List<FatturaBean> RetrieveFattura(int id) {
	    Connection connection = null;
	    PreparedStatement preparedStatement = null;
	    List<FatturaBean> fatture = new ArrayList<>();

	    String selectSQL = "SELECT * FROM orders WHERE utente = ?";

	    try {
	        connection = ds.getConnection();
	        preparedStatement = connection.prepareStatement(selectSQL);
	        preparedStatement.setInt(1, id);

	        ResultSet rs = preparedStatement.executeQuery();

	        while (rs.next()) {
	            FatturaBean bean = new FatturaBean();
	            bean.setIdFattura(rs.getInt("id"));
	            bean.setIdUtente(rs.getInt("utente"));
	            bean.setDataOrdine(rs.getTimestamp("order_date")); // usa getDate se hai solo la data
	            bean.setPrezzoTotale(rs.getFloat("total_price"));
	            fatture.add(bean);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (preparedStatement != null)
	                preparedStatement.close();
		        if (connection != null) 
		            connection.close();

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return fatture;
	}
	
	public synchronized List<ItemOrder> RetrieveByFattura(int id) {
		
		 Connection con = null;
		    PreparedStatement ps = null;
		    ResultSet rs = null;

		    List<ItemOrder> items = new ArrayList<>();

		    String sql = "SELECT product_id, image_url, quantity, price, iva FROM order_details WHERE order_id = ?";

		    try {
		        con = ds.getConnection(); // Assumendo che tu abbia un DataSource `ds`
		        ps = con.prepareStatement(sql);
		        ps.setInt(1, id);

		        rs = ps.executeQuery();

		        while (rs.next()) {
		        	// per prendere delle informazioni mancanti del prodotto (il nome)
		        	ResultSet rp = null;
		        	sql = "SELECT nome FROM prodotto WHERE idProdotto = ?";
		        	ps = con.prepareStatement(sql);
		        	ps.setInt(1, rs.getInt("product_id"));
		        	rp = ps.executeQuery();
		        	while (rp.next()) {
		        		ProductBean p = new ProductBean();
		            	ItemOrder item = new ItemOrder();
		            	p.setIdProdotto(rs.getInt("product_id"));
		            	p.setNome(rp.getString("nome"));
		            	p.setlinkImg(rs.getString("image_url"));
		            	item.setNumItems(rs.getInt("quantity"));
		            	float prezzo = (float)rs.getDouble("price");
		            	p.setPrezzo(prezzo);
		            	p.setIva(rs.getInt("iva"));
		            	item.setItem(p);
		            
		            	items.add(item);
		        	}
		        }

		    } catch (SQLException e) {
		        e.printStackTrace(); // Puoi gestirla meglio con un logger
		    } finally {
		        try {
		            if (rs != null) rs.close();
		            if (ps != null) ps.close();
		            if (con != null) con.close();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }

		    return items;
		
	}
	
	public synchronized void doSaveReview(Review r) {
	    Connection con = null;
	    PreparedStatement ps = null;

	    String sql = "INSERT INTO reviews (product_id, user_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)";

	    try {
	        con = ds.getConnection(); // Assumendo che tu abbia un DataSource `ds`
	        ps = con.prepareStatement(sql);

	        ps.setInt(1, r.getProductId());
	        ps.setInt(2, r.getUserId());
	        ps.setInt(3, r.getRating());
	        ps.setString(4, r.getComment());
	        ps.setTimestamp(5, r.getReviewDate());

	        ps.executeUpdate();

	    } catch (SQLException e) {
	        e.printStackTrace(); // Puoi sostituirlo con un logger se vuoi
	    } finally {
	        try {
	            if (ps != null) ps.close();
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	
	public List<Review> getReviewsByProductId(int productId) throws SQLException {
	    Connection connection = null;
	    PreparedStatement preparedStatement = null;
	    ResultSet rs = null;
	    List<Review> reviews = new ArrayList<>();

	    String sql = "SELECT rating, comment FROM reviews WHERE product_id = ?";

	    try {
	        connection = ds.getConnection();
	        preparedStatement = connection.prepareStatement(sql);
	        preparedStatement.setInt(1, productId);

	        rs = preparedStatement.executeQuery();

	        while (rs.next()) {
	            Review review = new Review();
	            review.setRating(rs.getInt("rating"));
	            review.setComment(rs.getString("comment"));
	            reviews.add(review);
	        }

	    } finally {
	        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
	        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
	        connection.close();
	    }

	    return reviews;
	}
}
