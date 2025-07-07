package it.unisa.product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import it.unisa.order.*;

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
	static OrderModel model2 = new OrderModelIDM();
	
    public ProductControl() {
        super();
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
					
					// NULL CHECK ADDED HERE
					if (product == null) {
					    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Prodotto non trovato");
					    return;
					}
					
					String requestedWith = request.getHeader("X-Requested-With");
					
					if ("XMLHttpRequest".equals(requestedWith)) {
					    response.setContentType("application/json");
					    response.setCharacterEncoding("UTF-8");

					    PrintWriter out = response.getWriter();
					    String json = "{"
					    		+ "\"IdProdotto\":\"" + product.getIdProdotto() + "\","
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
 	
				 	//elimina un prodotto dal db
				} else if (action.equalsIgnoreCase("delete")) {
				    String idParam = request.getParameter("id");
				    if(idParam != null && !idParam.isEmpty()) {
				        try {
				            int id = Integer.parseInt(idParam);
				            ProductBean bean = model.doRetrieveByKey(id);
				            
				            // NULL CHECK ADDED HERE
				            if (bean != null) {
				                bean.setEliminato(true);
				                model.doUpdate(bean);
				            }
				        } catch (NumberFormatException e) {
				            System.err.println("ID prodotto non valido per eliminazione: " + idParam);
				        }
				    }
				    response.sendRedirect(request.getContextPath() + "/product");
				    return;
				
				} else if (action.equalsIgnoreCase("insert")) {
					
					String name = request.getParameter("nome");
					String categoria = request.getParameter("categoria");
					String description = request.getParameter("descrizione");
				    String disponibilita = request.getParameter("disponibilita");
				    boolean stato = disponibilita != null && disponibilita.equalsIgnoreCase("true");

					String lingua = request.getParameter("lingua");
					String ivaParam = request.getParameter("IVA");
					int iva = 0;
					if (ivaParam != null && !ivaParam.isEmpty()) {
					    try {
					        iva = Integer.parseInt(ivaParam);
					    } catch (NumberFormatException e) {
					        iva = 0;
					    }
					}
					
					try {
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
					    response.sendRedirect(request.getContextPath() + "/protectedUser/Administrator.jsp");
					    return;
					} catch (NumberFormatException e) {
					    System.err.println("Errore nel parsing dei parametri numerici: " + e.getMessage());
					    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri numerici non validi");
					    return;
					}
					
				} else if(action.equalsIgnoreCase("add")) {
				    try {
				        int id = Integer.parseInt(request.getParameter("id"));
				        HttpSession sessione = request.getSession();
				        Carrello carrello = (Carrello) sessione.getAttribute("carrello");
				        if(carrello == null)
				            carrello = new Carrello();
				        
				        carrello.addCarrello(id);
				        sessione.setAttribute("carrello", carrello);
				        
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;  
				    } catch (NumberFormatException e) {
				        System.err.println("ID prodotto non valido per aggiunta al carrello: " + request.getParameter("id"));
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				    }
					
				} else if(action.equalsIgnoreCase("remove")) {
				    try {
				        int id = Integer.parseInt(request.getParameter("id"));
				        HttpSession sessione = request.getSession();
				        Carrello carrello = (Carrello) sessione.getAttribute("carrello");
				        
				        if (carrello == null) {
				            carrello = new Carrello();
				            sessione.setAttribute("carrello", carrello);
				        }
				        
				        carrello.deleteCarrello(id);
				        sessione.setAttribute("carrello", carrello);
				        
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				        
				    } catch (NumberFormatException e) {
				        System.err.println("ID prodotto non valido: " + request.getParameter("id"));
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				    } catch (Exception e) {
				        System.err.println("Errore durante la rimozione dal carrello: " + e.getMessage());
				        e.printStackTrace();
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				    }
				
				} else if(action.equalsIgnoreCase("updateQuantity")) {
				    try {
				        int id = Integer.parseInt(request.getParameter("id"));
				        int quantity = Integer.parseInt(request.getParameter("quantity"));
				        HttpSession session = request.getSession();
				        Carrello cart = (Carrello) session.getAttribute("carrello");

				        if (cart != null) {
				            cart.aggiornaQuantita(id, quantity);
				        }

				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				    } catch (NumberFormatException e) {
				        System.err.println("Parametri non validi per aggiornamento quantità: " + e.getMessage());
				        response.sendRedirect(request.getContextPath() + "/Carrello.jsp");
				        return;
				    }
				}
				else if(action.equalsIgnoreCase("cerca")) {
					response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");
				    String cerca = request.getParameter("q");
				    try {
				        String json = model.doRetrieveByName(cerca);
				        PrintWriter out = response.getWriter();
				        out.write(json);
				        out.flush();
				        out.close();
				    } catch (SQLException e) {
				        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				        e.printStackTrace();
				    }
				    return;
				}
				
				else if (action.equalsIgnoreCase("restore")) {
				    try {
				        int id = Integer.parseInt(request.getParameter("id"));
				        model.doRestore(id);
				        response.sendRedirect(request.getContextPath() + "/product");
				        return;
				    } catch (NumberFormatException e) {
				        System.err.println("ID non valido per ripristino: " + request.getParameter("id"));
				        response.sendRedirect(request.getContextPath() + "/product");
				        return;
				    } catch (Exception e) {
				        e.printStackTrace();
				        response.sendRedirect(request.getContextPath() + "/product");
				        return;
				    }
				}
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
			e.printStackTrace();
		}
		
		String sort = request.getParameter("sort");

		try {
		    request.removeAttribute("products");
		    
		    // Controlla se l'utente è admin
		    HttpSession session = request.getSession(false);
		    Boolean isAdmin = null;
		    
		    if (session != null) {
		        isAdmin = (Boolean) session.getAttribute("admin");
		    }
		    
		    List<ProductBean> products = null;
		    if(Boolean.TRUE.equals(isAdmin)) {
		        products = (List<ProductBean>) model.doRetrieveAllForAdmin(sort);
		    } else {
		        products = (List<ProductBean>) model.doRetrieveAll(sort);
		    }
		    
		    if (products != null) {
		        request.setAttribute("products", products);
		    }
		    
		} catch (SQLException e) {
		    System.out.println("Error:" + e.getMessage());
		    e.printStackTrace();
		}

		RequestDispatcher dispatcher;
		HttpSession session = request.getSession(false);
		Boolean isAdmin = null;
		
		if (session != null) {
		    isAdmin = (Boolean) session.getAttribute("admin");
		}

		if(Boolean.TRUE.equals(isAdmin)) {
		    dispatcher = getServletContext().getRequestDispatcher("/user?action=all");
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
		doGet(request, response);
	}
}