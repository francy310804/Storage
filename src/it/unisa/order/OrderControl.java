package it.unisa.order;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.unisa.user.UserBean;


import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

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
				} else if("inviofattura".equals(action)) {
					int idFattura = Integer.parseInt(request.getParameter("idFattura"));
					HttpSession session = request.getSession(false);
					if(session == null || session.getAttribute("user") == null) {
						response.sendRedirect("Login.jsp");
						return;
					}
					UserBean user = (UserBean) session.getAttribute("user");
					List<FatturaBean> fatture = model.RetrieveFattura(user.getId());
			        // Recupera solo la fattura richiesta
			        Optional<FatturaBean> fattura = fatture.stream()
			        		.filter(f -> f.getIdFattura()==idFattura)
			        		.findFirst();
			 
			        if(fattura.isPresent()) {
			       	FatturaBean f = fattura.get();
			        	List<ItemOrder> dettagli = model.RetrieveByFattura(f.getIdFattura());
			        	final String username = "speakupinfo25@gmail.com";
			        	final String pwd = "bblqnyadgadaecsf"; //bblq nyad gada ecsf
			        	
			        	Properties props = new Properties();
			            props.put("mail.smtp.auth", "true");
			            props.put("mail.smtp.starttls.enable", "true");
			            props.put("mail.smtp.host", "smtp.gmail.com");
			            props.put("mail.smtp.port", "587");
			            
			            //per creare la sessione email autenticata, necessaria per inviare l'email
			            Session email = Session.getInstance(props,
			            	    new Authenticator() {
			            	        protected PasswordAuthentication getPasswordAuthentication() {
			            	            return new PasswordAuthentication(username, pwd);
			            	        }});
			            try {
			                Message message = new MimeMessage(email);
			                message.setFrom(new InternetAddress(username));
			                message.setRecipients(Message.RecipientType.TO,
			                        InternetAddress.parse(user.getEmail()));
			                message.setSubject("Fattura SpeakUp");
			                
			                StringBuilder testo = new StringBuilder();
			                testo.append("SpeakUp\n"
			                +"Via Giovanni Paolo II, 132\n"
			                +"84084 Fisciano SA - Italia\n"
			                +"P.IVA: 12345678901\n"
			                +"Tel: +39 02 1234567 - Email: "+  username+"\n\n\n")
			                .append("FATTURA N°"+f.getIdFattura())
			                .append("\nData: "+f.getDataOrdine())
			                .append("\nCliente:")
			                .append("\n"+user.getNome()+" "+user.getCognome())
			                .append("\n"+user.getIndirizzo())
			                .append("\n"+user.getCap()+" "+user.getCitta()+" "+user.getProvincia()).append("\n\n");
			                
			                testo.append(String.format("%-3s %-20s %18s %10s %7s %15s\n",
			                         "#", "Descrizione", "Prezzo Unitario(€)", "Quantità", "IVA %", "Totale(€)"));
			testo.append("--------------------------------------------------------------------------------------------------\n");
			int i = 1;
			double totale = 0;
			for (ItemOrder item : dettagli) {
			    totale += item.getTotalCost();
			    testo.append(String.format("%-3d %-20s %18.2f %10d %7d %15.2f\n",
			                             i++,
			                             item.getNome(),
			                             item.getUnitCost(),
			                             item.getNumItems(),
			                             item.getIva(),
			                             item.getTotalCost()));
			}
			testo.append("\nTotale (iva inclusa): ").append(String.format("%15.2f",totale)).append("€");
			               message.setText(testo.toString());

			                Transport.send(message);
			               

			            } catch (MessagingException e) {
			                e.printStackTrace();
			            }
			        }
			        
			        
			        
			        
			        
			        
			        
			        request.setAttribute("fatture", fatture);
			        RequestDispatcher dispatcher = request.getRequestDispatcher("/Ordini.jsp");
			        dispatcher.forward(request, response);
			        return;
			        
				} else if("review".equals(action)) {
					
					HttpSession session = request.getSession();
					
					Review r = new Review();
					r.setComment(request.getParameter("comment"));
					int pId = Integer.parseInt(request.getParameter("productId"));
					r.setProductId(pId);
					r.setRating(Integer.parseInt(request.getParameter("rating")));
					UserBean usr = (UserBean)session.getAttribute("user");
					r.setUserId(usr.getId());
					r.setReviewDate(new Timestamp(System.currentTimeMillis()));					
					model.doSaveReview(r);
			        response.sendRedirect("ProductView.jsp");
			        return;
				}
			
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		
		
		try {

			int id = Integer.parseInt(request.getParameter("productId"));
			request.setAttribute("reviews", model.getReviewsByProductId(id));
		} catch(Exception e) {
			System.out.println("Error:" + e.getMessage());
		}
		
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/writeReview.jsp");
		dispatcher.forward(request, response); 
		return;
		
		
		
	}

		

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}