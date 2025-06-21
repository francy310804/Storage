package it.unisa;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("email") != null);

        if (loggedIn) {
            chain.doFilter(request, response);  // Continua la richiesta
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/FailLogin.jsp");
        }
    }
}