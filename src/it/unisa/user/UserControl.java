package it.unisa.user;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;


/**
 * Servlet implementation class UserControl
 */
@WebServlet("/UserControl")
public class UserControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static UserModel model = new UserModelDM();

    public UserControl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action"); //vede che tio di azione deve essere eseguita
		
		try {
			if(action != null) {
				// in caso di login
				if(action.equalsIgnoreCase("login")) {
				
					String email = request.getParameter("email");	//preleva l'email dalla richiesta
					String pwd = request.getParameter("password");	//preleva la password dalla richiesta
					
					
					UserBean u = model.doRetrieveByKey(email);		//restituisce un user se esiste con quella email
					//solo se l'user esiste e la pass
					if(u != null && u.getEmail() != null && BCrypt.checkpw(pwd, u.getPassword())){
						
						request.getSession().setAttribute("admin", false);
			        	request.getSession().setAttribute("email", u.getEmail());
			        	request.getSession().setAttribute("nome", u.getNome());
			        	request.getSession().setAttribute("cognome", u.getCognome());
			        	request.getSession().setAttribute("indirizzo", u.getIndirizzo());
			        	request.getSession().setAttribute("città", u.getCitta());
			        	request.getSession().setAttribute("provincia", u.getProvincia());
			        	request.getSession().setAttribute("Cap", u.getCap());
						
			        	HttpSession session = request.getSession();
			        	session.setAttribute("user", u);
			        	
			        	//se è admin lo riporta alla sua pagina
						if(u.getRuolo().equals("admin")) {
							request.getSession().setAttribute("admin", true);
							//response.sendRedirect("protectedUser/Administrator.jsp");	
						    response.sendRedirect(request.getContextPath() + "/ProductView.jsp");	
						    

						} else {
							//se non è admin va alla pag. utente
							//response.sendRedirect("protectedUser/PageUtente.jsp");
						    response.sendRedirect(request.getContextPath() + "/ProductView.jsp");			
						}
					}
					else 
						response.sendRedirect("FailLogin.jsp");
				}
				else if(action.equalsIgnoreCase("registration")) {
					String email = request.getParameter("email");
					UserBean tmp = model.doRetrieveByKey(email);

					if(tmp!= null && tmp.getEmail().equals(email)) { //se l'email già c'è l'utente viene mandato al Login
						response.sendRedirect("ErrorPage.jsp");
					} else {	
					//settiamo l'utente da salvare...		
					UserBean user = new UserBean();
					user.setCap(Integer.parseInt(request.getParameter("cap")));
					user.setCitta(request.getParameter("citta"));
					user.setCognome(request.getParameter("cognome"));
					user.setEmail(email);
					user.setIndirizzo(request.getParameter("indirizzo"));
					user.setNome(request.getParameter("nome"));
					String password = request.getParameter("password");
					String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
					user.setPassword(hashedPassword);
					user.setProvincia(request.getParameter("provincia"));
					model.doSave(user);
					response.sendRedirect("SuccRegistration.jsp");
				}
			} else if(action.equalsIgnoreCase("logout")) {
			    HttpSession session = request.getSession(false); 
			    if (session != null) {
			        session.invalidate(); // distrugge la sessione
			    }
			    response.sendRedirect(request.getContextPath() + "/ProductView.jsp");			}
				
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}
	}
