package it.unisa.favorite;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import it.unisa.user.UserBean;

/**
 * Servlet implementation class FavoriteController
 */
@WebServlet("/FavoriteController")
public class FavoriteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private FavoriteModel favoriteModel = new FavoriteModelIDM();

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FavoriteController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	String action = request.getParameter("action"); //vede che tipo di azione deve essere eseguita
	
	if(action != null) {
		
	
	if(action.equalsIgnoreCase("add")) {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    
    UserBean bean = (UserBean) session.getAttribute("user");
    

    int userId = bean.getId();
    int productId = Integer.parseInt(request.getParameter("productId"));


    try {
       favoriteModel.addFavorite(new Favorite(userId, productId));

    } catch (Exception e) {
        e.printStackTrace();
    } 
    
    response.sendRedirect(request.getContextPath() + "/ProductView.jsp");
    
	} else if("remove".equalsIgnoreCase(action)) {
		
		  HttpSession session = request.getSession(false);
		    if (session == null || session.getAttribute("user") == null) {
		        response.sendRedirect(request.getContextPath() + "/Login.jsp");
		        return;
		    }
		    
		    int idProduct = Integer.parseInt(request.getParameter("id"));
		    
		    UserBean bean = (UserBean) session.getAttribute("user");
		    int userId = bean.getId();
		    
		    try {
		    	favoriteModel.removeFavorite(userId, idProduct);
		    } catch(Exception e) {
		    	e.printStackTrace();
		    }
		    
		    RequestDispatcher dispatcher = request.getRequestDispatcher("/Favorite.jsp");
		    dispatcher.forward(request, response);
		    return;
	}
	
	}
	
	
	try {
	    HttpSession session = request.getSession(false); 
	    if (session == null) {
	        // sessione non esiste, gestisci il caso (es. redirect al login)
	        response.sendRedirect("Login.jsp");
	        return;
	    }
	    
	    UserBean bean = (UserBean) session.getAttribute("user");
	    int userId = bean.getId();
	    
	    request.setAttribute("favoriteProductIds", favoriteModel.getFavoritesByUser(userId));
	    
	    request.getRequestDispatcher("/Favorite.jsp").forward(request, response);
	} catch(Exception e) {
	    System.out.println(e.getMessage());
	}
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
