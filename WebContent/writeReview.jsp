<%@ page import="java.sql.*" %>
<%
    String productId = request.getParameter("productId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Scrivi Recensione</title>
    <link rel="stylesheet" type="text/css" href="ProductStyle.css">
</head>

<body>
    <jsp:include page="NavBar.jsp" />


<%if(session.getAttribute("user") == null) {%>
<h2>se vuoi scirvere una recensione autenticati prima</h2>
<%} %>

<%if(session.getAttribute("user") != null) {%>
    <h2>Scrivi la tua recensione per il prodotto</h2>

    <form action="OrderControl?action=review" method="post">
        <input type="hidden" name="productId" value="<%= productId %>">

<label>Rating:</label>
<div class="star-rating">
  <input type="radio" id="star5" name="rating" value="5" required />
  <label for="star5" title="5 stelle">&#9733;</label>

  <input type="radio" id="star4" name="rating" value="4" />
  <label for="star4" title="4 stelle">&#9733;</label>

  <input type="radio" id="star3" name="rating" value="3" />
  <label for="star3" title="3 stelle">&#9733;</label>

  <input type="radio" id="star2" name="rating" value="2" />
  <label for="star2" title="2 stelle">&#9733;</label>

  <input type="radio" id="star1" name="rating" value="1" />
  <label for="star1" title="1 stella">&#9733;</label>
</div>

        <br><br>

        <label for="comment">Commento:</label><br>
        <textarea name="comment" id="comment" rows="4" cols="50" required></textarea>

        <br><br>
        <button type="submit">Invia recensione</button>
    </form>
    
 <%} %>
</body>
</html>