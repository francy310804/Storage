<%@ page import="java.sql.*, it.unisa.order.*, java.util.*" %>
<%
    String productId = request.getParameter("productId");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    if (reviews == null) {
        response.sendRedirect(request.getContextPath() + "/order");
        return;
    }
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

    <% if(session.getAttribute("user") == null) { %>
        <h2>se vuoi scrivere una recensione autenticati prima</h2>
    <% } %>

    <% if(session.getAttribute("user") != null) { %>
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
    <% } %>

    <div class="reviews-section">
        <h2>Recensioni degli utenti</h2>

        <% if (!reviews.isEmpty()) {
            for (Review review : reviews) {
        %>
        <div class="review-card">
            <div class="review-header">
                <span class="review-stars">
                    <%
                        for (int i = 1; i <= review.getRating(); i++) {
                    %>
                    <span>&#9733;</span>
                    <%
                        }
                        for (int i = review.getRating() + 1; i <= 5; i++) {
                    %>
                    <span class="empty-star">&#9734;</span>
                    <%
                        }
                    %>
                </span>
            </div>
            <div class="review-comment">
                <p><%= review.getComment() %></p>
            </div>
            <p>____________________________________</p>
        </div>
        <% 
            }
        } else { 
        %>
        <p>Nessuna recensione disponibile.</p>
        <% } %>
    </div>

</body>
</html>