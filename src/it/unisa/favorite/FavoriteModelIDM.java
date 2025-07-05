package it.unisa.favorite;

import java.sql.*;
import it.unisa.product.*;
import java.util.ArrayList;
import java.util.List;
import it.unisa.DriverManagerConnectionPool;

public class FavoriteModelIDM implements FavoriteModel {
	
    private static final String TABLE_NAME = "user_favorites";

    @Override
    public synchronized void addFavorite(Favorite favorite) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO " + FavoriteModelIDM.TABLE_NAME
                + " (user_id, product_id) VALUES (?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL);
            preparedStatement.setInt(1, favorite.getUserId());
            preparedStatement.setInt(2, favorite.getProductId());

            preparedStatement.executeUpdate();
            connection.commit();

        } catch (SQLException e) {
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
                if (connection != null)
                    connection.close();
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
    }

    @Override
    public synchronized void removeFavorite(int userId, int productId) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        int result = 0;

        String deleteSQL = "DELETE FROM " + FavoriteModelIDM.TABLE_NAME + " WHERE user_id = ? AND product_id = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, productId);

            result = preparedStatement.executeUpdate();
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

    public synchronized List<ProductBean> getFavoritesByUser(int userId) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        List<ProductBean> favorites = new ArrayList<>();

        // MODIFICA: Aggiunto p.eliminato nella SELECT per recuperare anche i prodotti eliminati
        String selectSQL =
            "SELECT p.idProdotto, p.nome, p.categoria, p.descrizione, p.stato, p.lingua, " +
            "p.iva, p.prezzo, p.stock, p.linkAccesso, p.linkImg, p.eliminato " +
            "FROM user_favorites uf " +
            "JOIN Prodotto p ON uf.product_id = p.idProdotto " +
            "WHERE uf.user_id = ?";
            // IMPORTANTE: Nessun filtro su p.eliminato, così recupera tutti i prodotti preferiti

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, userId);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                ProductBean product = new ProductBean();

                product.setIdProdotto(rs.getInt("idProdotto"));
                product.setNome(rs.getString("nome"));
                product.setCategoria(rs.getString("categoria"));
                product.setDescrizione(rs.getString("descrizione"));
                product.setStato(rs.getBoolean("stato"));
                product.setLingua(rs.getString("lingua"));
                product.setIva(rs.getInt("iva"));
                product.setPrezzo(rs.getFloat("prezzo"));
                product.setStock(rs.getInt("stock"));
                product.setLinkAccesso(rs.getString("linkAccesso"));
                product.setlinkImg(rs.getString("linkImg"));
                // MODIFICA: Aggiungi il campo eliminato al ProductBean
                product.setEliminato(rs.getBoolean("eliminato"));

                favorites.add(product);
            }

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
        return favorites;
        
    }
    	 //rimuove tutti gli elementi eliminati dalla wishlist
        public synchronized int removeDeletedProductsFromFavorites(int userId) throws SQLException {
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            int deletedCount = 0;

            String deleteSQL = "DELETE FROM " + FavoriteModelIDM.TABLE_NAME + 
                              " WHERE user_id = ? AND product_id IN " +
                              "(SELECT idProdotto FROM Prodotto WHERE eliminato = true)";

            try {
                connection = DriverManagerConnectionPool.getConnection();
                preparedStatement = connection.prepareStatement(deleteSQL);
                preparedStatement.setInt(1, userId);

                deletedCount = preparedStatement.executeUpdate();
                connection.commit();

            } catch (SQLException e) {
                if (connection != null) {
                    connection.rollback();
                }
                throw e;
            } finally {
                try {
                    if (preparedStatement != null)
                        preparedStatement.close();
                } finally {
                    if (connection != null) {
                        DriverManagerConnectionPool.releaseConnection(connection);
                    }
                }
            }
            
            return deletedCount;
        }
    }
    
   
