package it.unisa.favorite;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import it.unisa.product.ProductBean;
import it.unisa.user.UserBean;

public class FavoriteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private FavoriteModelIDM favoriteModel = new FavoriteModelIDM();
    
    public FavoriteController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("user");
        
        // Verifica se l'utente è loggato
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        try {
            // Recupera i prodotti preferiti dell'utente (inclusi quelli eliminati)
            List<ProductBean> favoriteProducts = favoriteModel.getFavoritesByUser(user.getId());
            
            // Conta i prodotti eliminati
            int deletedCount = 0;
            for (ProductBean product : favoriteProducts) {
                if (product.isEliminato()) {
                    deletedCount++;
                }
            }
            
            // Imposta gli attributi per la JSP
            request.setAttribute("favoriteProducts", favoriteProducts);
            request.setAttribute("deletedCount", deletedCount);
            
            // Forward alla JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Favorite.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore nel recupero dei prodotti preferiti");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ErrorPage.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("user");
        
        // Verifica se l'utente è loggato
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if(action != null) {
        
        try {
            if ("add".equalsIgnoreCase(action)) {
                // Aggiungi prodotto ai preferiti
                String productIdStr = request.getParameter("productId");
                if (productIdStr != null && !productIdStr.isEmpty()) {
                    int productId = Integer.parseInt(productIdStr);
                    
                    Favorite favorite = new Favorite();
                    favorite.setUserId(user.getId());
                    favorite.setProductId(productId);
                    
                    favoriteModel.addFavorite(favorite);
                    
              //   request.setAttribute("message", "Prodotto aggiunto ai preferiti!");
                }
                
            } else if ("remove".equalsIgnoreCase(action)) {
                // Rimuovi prodotto dai preferiti
                String productIdStr = request.getParameter("productId");
                if (productIdStr != null && !productIdStr.isEmpty()) {
                    int productId = Integer.parseInt(productIdStr);
                    
                    favoriteModel.removeFavorite(user.getId(), productId);
                    
                //    request.setAttribute("message", "Prodotto rimosso dai preferiti!");
                }
                
            } else if ("cleanup".equalsIgnoreCase(action)) {
                // NUOVA FUNZIONALITÀ: Rimuovi tutti i prodotti eliminati dai preferiti
                int removedCount = favoriteModel.removeDeletedProductsFromFavorites(user.getId());
                
                if (removedCount > 0) {
                    request.setAttribute("message", 
                        "Rimossi " + removedCount + " prodotto" + 
                        (removedCount > 1 ? "i" : "") + " non disponibile" + 
                        (removedCount > 1 ? "i" : "") + " dai preferiti!");
                } else {
                //    request.setAttribute("message", "Nessun prodotto non disponibile da rimuovere.");
                }
            }
            
            // Dopo qualsiasi azione, reindirizza alla pagina dei preferiti
            response.sendRedirect(request.getContextPath() + "/favorites");
            
        } catch (SQLException e) {
            e.printStackTrace();
        //    request.setAttribute("error", "Errore nell'operazione sui preferiti: " + e.getMessage());
         //   RequestDispatcher dispatcher = request.getRequestDispatcher("/ErrorPage.jsp");
         //   dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
         //   request.setAttribute("error", "ID prodotto non valido");
         //   RequestDispatcher dispatcher = request.getRequestDispatcher("/ErrorPage.jsp");
         //   dispatcher.forward(request, response);
        }
        
    }
    }
}
