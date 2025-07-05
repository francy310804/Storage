package it.unisa.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import it.unisa.admin.AdminBean;


/**
 * Servlet implementation class AdminControl
 */
@WebServlet("/AdminControl")
public class AdminControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static AdminModel model = new AdminModel();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminControl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
String action = request.getParameter("action"); //vede che tio di azione deve essere eseguita
		
		try {
			if(action != null) {
				// in caso di login
				if(action.equalsIgnoreCase("registration")) {
					String email = request.getParameter("email");
					AdminBean tmp = model.doRetrieveByKey(email);

					if(tmp!= null && tmp.getEmail().equals(email)) { //se l'email già c'è l'utente viene mandato al Login
						request.getSession().setAttribute("failRegistration", true);
						response.sendRedirect("Registration.jsp");
					} else {	
					//settiamo l'utente da salvare...		
					AdminBean admin = new AdminBean();
					admin.setCognome(request.getParameter("cognome"));
					admin.setEmail(email);
					admin.setNome(request.getParameter("nome"));
					String password = request.getParameter("password");
					String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
					admin.setPassword(hashedPassword);
					model.doSave(admin);
					request.getSession().removeAttribute("failRegistration");
					response.sendRedirect("Login.jsp");
					}
				}
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}
}
