package it.unisa.favorite;

import java.util.List;
import it.unisa.product.*;

public interface FavoriteModel {
	
    void addFavorite(Favorite favorite) throws Exception;
    
    void removeFavorite(int userId, int productId) throws Exception;
    
    List<ProductBean> getFavoritesByUser(int userId) throws Exception;
}