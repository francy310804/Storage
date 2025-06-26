package it.unisa.product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.PrintWriter;

import it.unisa.order.Carrello;
import it.unisa.order.ItemOrder;
import it.unisa.user.*;


public class ProductControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static ProductModel model = new ProductModelDS();
	
    public ProductControl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		try {
			if (action != null) {
				
				//implemento JSON
				if (action.equalsIgnoreCase("read")) {
										
					String idParam = request.getParameter("id");
				
					if (idParam == null || idParam.isEmpty()) {
					    // Gestisci il caso in cui manca l'id: es. risposta di errore o redirect
					    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametro id mancante");
					    return;
					}
					

					int id;
					try {
					    id = Integer.parseInt(idParam);
					} catch (NumberFormatException e) {
					    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametro id non valido");
					    return;
					}
					
					ProductBean product = model.doRetrieveByKey(id);
					
					    String requestedWith = request.getHeader("X-Requested-With");
					    

					    if ("XMLHttpRequest".equals(requestedWith)) {
					        response.setContentType("application/json");
					        response.setCharacterEncoding("UTF-8");

					    PrintWriter out = response.getWriter();
					    String json = "{"
					            + "\"nome\":\"" + escapeJson(product.getNome()) + "\","
					            + "\"categoria\":\"" + escapeJson(product.getCategoria()) + "\","
					            + "\"descrizione\":\"" + escapeJson(product.getDescrizione()) + "\","
					            + "\"stato\":" + product.getStato() + ","
					            + "\"stock\":" + product.getStock() + ","
					            + "\"lingua\":\"" + escapeJson(product.getLingua()) + "\","
					            + "\"iva\":" + product.getIva() + ","
					            + "\"prezzo\":" + product.getPrezzo()
					            + "}";
					    	
					        out.print(json);
					        out.flush();
					        out.close();
					        return;
					        
					    }
 	
				 	
				} else if (action.equalsIgnoreCase("delete")) {
					
					int id = Integer.parseInt(request.getParameter("id"));
					model.doDelete(id);
					
				} else if (action.equalsIgnoreCase("insert")) {
					
					String name = request.getParameter("nome");
					String categoria = request.getParameter("categoria");
					String description = request.getParameter("descrizione");
					boolean stato;
					if(request.getParameter("disponibilita").equalsIgnoreCase("false"))
						stato = false;
					else
						stato = true;
					String lingua = request.getParameter("lingua");
					int iva = Integer.parseInt(request.getParameter("IVA"));
					float price = Float.parseFloat(request.getParameter("prezzo"));
					int quantity = Integer.parseInt(request.getParameter("stock"));
					String link = request.getParameter("linkaccesso");
					String linkImg = request.getParameter("linkImg");
					ProductBean bean = new ProductBean();
					bean.setNome(name);
					bean.setCategoria(categoria);
					bean.setDescrizione(description);
					bean.setStato(stato);
					bean.setLingua(lingua);
					bean.setIva(iva);
					bean.setPrezzo(price);
					bean.setStock(quantity);
					bean.setLinkAccesso(link);
					bean.setlinkImg(linkImg);
					model.doSave(bean);
					
				} else if(action.equalsIgnoreCase("add")) {
					int id = Integer.parseInt(request.getParameter("id"));
					HttpSession sessione = request.getSession();
					Carrello carrello = (Carrello) sessione.getAttribute("carrello");
					if(carrello == null)
						carrello = new Carrello();
					//ProductBean prodotto = model.doRetrieveByKey(id);
					carrello.addCarrello(id);
					sessione.setAttribute("carrello", carrello);
					
				} 
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		String sort = request.getParameter("sort");

		try {
			request.removeAttribute("products");
			request.setAttribute("products", model.doRetrieveAll(sort));
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		RequestDispatcher dispatcher;
		Boolean isAdmin = (Boolean) request.getSession().getAttribute("admin");
		
		if(Boolean.TRUE.equals(isAdmin)) {
			dispatcher = getServletContext().getRequestDispatcher("/protectedUser/Administrator.jsp");
			dispatcher.forward(request, response); 
			return;
		}
		
		dispatcher = getServletContext().getRequestDispatcher("/ProductView.jsp");
		dispatcher.forward(request, response); 
		return;
	}
    
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
