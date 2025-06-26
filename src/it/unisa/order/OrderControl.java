package it.unisa.order;

import java.io.IOException;
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
 * Servlet implementation class OrderControl
 */
@WebServlet("/OrderControl")
public class OrderControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static OrderModel model = new OrderModelIDM();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderControl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");

		try {
			if (action != null) {
				
				if(action.equalsIgnoreCase("checkout")) {
					HttpSession session = request.getSession();
					Carrello carrello = (Carrello) session.getAttribute("carrello");
				    List<ItemOrder> prodotti = carrello.getProdotti();

					if (carrello == null || prodotti.isEmpty()) {
					    // carrello vuoto, reindirizza
					    response.sendRedirect("Carrello.jsp");
					    return;
					}

				    UserBean utente = (UserBean) session.getAttribute("user"); // o UserBean o come si chiama nel tuo progetto
				    if (utente == null) {
				        response.sendRedirect("Login.jsp");
				        return;
				    }
				    
				    try {
				    model.doSaveOrder(utente.getId(), prodotti, carrello.getTotale());
				    session.removeAttribute("carrello");
				    
				    List<FatturaBean> fatture = model.RetrieveFattura(utente.getId());
				    request.setAttribute("fatture", fatture);
				    
			        response.sendRedirect("ConfermaOrdine.jsp");
			        return;
				    } catch(Exception e) {
				        e.printStackTrace(); 
					    return;
				    }
				    
				} else if ("viewFatture".equals(action)) {
				    HttpSession session = request.getSession(false);
				    if (session == null || session.getAttribute("user") == null) {
				        response.sendRedirect("Login.jsp");
				        return;
				    }
				    
				    UserBean a = (UserBean)session.getAttribute("user");
				    int userId = a.getId();

				    List<FatturaBean> fatture = model.RetrieveFattura(userId);

				    request.setAttribute("fatture", fatture);
				    RequestDispatcher dispatcher = request.getRequestDispatcher("/Ordini.jsp");
				    dispatcher.forward(request, response);
				    return;
				    
				} else if("viewOrdineCompleto".equals(action)) {
					int idFattura = Integer.parseInt(request.getParameter("idFattura"));

			        // Recupera i dettagli della fattura (item_order)
			        List<ItemOrder> dettagli = model.RetrieveByFattura(idFattura);

			        request.setAttribute("dettagliFattura", dettagli);

			        RequestDispatcher dispatcher = request.getRequestDispatcher("/DettagliFattura.jsp");
			        dispatcher.forward(request, response);
			        return;
				}
			}
		} catch (Exception e) {
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
