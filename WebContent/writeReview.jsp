<%@ page import="java.sql.*, it.unisa.order.*, java.util.*, it.unisa.product.*" %>
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
    <style>
        table.product-table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        table.product-table td {
            vertical-align: top;
            padding: 15px;
            border: 1px solid #ccc;
        }
        .product-image {
            max-width: 300px;
            height: auto;
        }
        .reviews-section {
            width: 80%;
            margin: 30px auto;
        }
        .review-card {
            border: 1px solid #ccc;
            padding: 15px;
            margin-bottom: 20px;
        }
        table.product-table, 
table.product-table td, 
table.product-table th {
    border: none;
    border-collapse: collapse;
}
    </style>
</head>

<body>
    <jsp:include page="NavBar.jsp" />

<%
    ProductBean bean = (ProductBean)request.getAttribute("object");
%>

<h2 style="text-align: center;"><%= bean.getNome() %></h2>

<table class="product-table">
    <tr>
        <td>
            <img class="product-image" src="<%= request.getContextPath() + "/" + bean.getLinkImg() %>" alt="Immagine materiale" />
        </td>
        <td>
            <p class="element-description"><%= bean.getDescrizione() %></p>
            <p class="element-description">Prezzo: &#8364;<%= bean.getPrezzo() %></p>
            <p class="element-description">Lingua: <%= bean.getLingua() %></p>
            <p class="element-description">IVA: <%= bean.getIva() %>%</p>
            <br><br>
            <a href="product?action=add&id=<%=bean.getIdProdotto()%>">
  			<img src="<%= request.getContextPath() + "/images/chart.jpg"%>" alt="chart" style="width:60px; height:auto; display: block; margin: 0 auto;">
			</a>
        </td>
    </tr>
</table>

<div style="width: 80%; margin: 20px auto;">
<h2>Scrivi anche tu una recensione</h2>
    <% if (session.getAttribute("user") == null) { %>
        <h3>Se vuoi scrivere una recensione autenticati prima</h3>
    <% } else { %>
        <h3>Scrivi la tua recensione per il prodotto</h3>
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
</div>

<div class="reviews-section">
    <h2>Recensioni degli utenti</h2>
    <% if (!reviews.isEmpty()) { 
        for (Review review : reviews) { 
    %>
        <div class="review-card">
            <div class="review-header">
                <span class="review-stars">
                    <% for (int i = 1; i <= review.getRating(); i++) { %>
                        <span>&#9733;</span>
                    <% } %>
                    <% for (int i = review.getRating() + 1; i <= 5; i++) { %>
                        <span class="empty-star">&#9734;</span>
                    <% } %>
                </span>
            </div>
            <div class="review-comment">
                <p><%= review.getComment() %></p>
            </div>
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