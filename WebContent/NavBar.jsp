<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>SpeakUp</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">
</head>
<body>

<nav>
  <h2>SpeakUp!</h2>
  <a href="<%= request.getContextPath() %>/ProductView.jsp">Home</a>

  <% 
    if (session.getAttribute("user") != null) { 
      Boolean isAdmin = (Boolean) session.getAttribute("admin");
      if (isAdmin != null && isAdmin) { 
  %>
        <a href="<%= request.getContextPath() %>/protectedUser/Administrator.jsp">Area Utente</a>
  <% 
      } else { 
  %>
        <a href="<%= request.getContextPath() %>/protectedUser/PageUtente.jsp">Area Utente</a>
  <% 
      } 
  %>
      <a href="<%= request.getContextPath() %>/UserControl?action=logout">Logout</a>
  <% 
    } else { 
  %>
      <a href="<%= request.getContextPath() %>/Login.jsp">Login</a>
      <a href="<%= request.getContextPath() %>/Registration.jsp">Registrati</a>
  <% 
    } 
  %>

  <a href="Carrello.jsp">Carrello</a>
  <a href="Contatti.jsp">Contatti</a>
</nav>

</body>
</html>