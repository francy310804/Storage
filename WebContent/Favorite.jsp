<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"
	import="it.unisa.product.*, it.unisa.favorite.*, java.util.*"%>

<%
    Collection<ProductBean> products = (Collection<ProductBean>) request.getAttribute("favoriteProducts");

    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/favorites");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="<%= request.getContextPath() %>/ProductStyle.css">
<title>Prodotti Preferiti</title>
<style>
.prodotto-eliminato {
	opacity: 0.6;
	background-color: #f8f9fa;
	border: 2px dashed #dc3545;
	border-radius: 8px;
	position: relative;
}

.prodotto-eliminato .element-image {
	filter: grayscale(100%);
}

.warning-message {
	color: #dc3545;
	font-weight: bold;
	text-align: center;
	background-color: #f8d7da;
	border: 1px solid #f5c6cb;
	border-radius: 4px;
	padding: 8px;
	margin: 10px 0;
}

.prodotto-disponibile {
	background-color: #fff;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
}

.cleanup-button {
	background-color: #ffc107;
	color: #212529;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	margin: 20px 0;
	font-weight: bold;
}

.cleanup-button:hover {
	background-color: #e0a800;
}
</style>
</head>
<body>

	<jsp:include page="NavBar.jsp" />

	<h2>I tuoi prodotti preferiti</h2>

	<%
    if (products.isEmpty()) {
%>
	<p>Non hai ancora aggiunto prodotti ai preferiti.</p>
	<%
    } else {
        // Conta i prodotti eliminati
        int prodottiEliminati = 0;
        for (ProductBean bean : products) {
            if (bean.isEliminato()) {
                prodottiEliminati++;
            }
        }
        
        // Mostra pulsante per pulire i preferiti se ci sono prodotti eliminati
        if (prodottiEliminati > 0) {
%>
	<div style="text-align: center; margin-bottom: 20px;">
		<p
			style="color: #856404; background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; border-radius: 5px; display: inline-block;">
			⚠️ Hai
			<%= prodottiEliminati %>
			prodotto<%= prodottiEliminati > 1 ? "i" : "" %>
			non più disponibile<%= prodottiEliminati > 1 ? "i" : "" %>
			nei preferiti
		</p>
		<br>
		<form action="<%= request.getContextPath() %>/favorites" method="post"
			style="display: inline;">
			<input type="hidden" name="action" value="cleanup">
			<button type="submit" class="cleanup-button">🧹 Rimuovi
				tutti i prodotti non disponibili</button>
		</form>
	</div>
	<%
        }
%>

	<div class="element-container">
		<% for (ProductBean bean : products) { %>
		<div
			class="element-card <%= bean.isEliminato() ? "prodotto-eliminato" : "prodotto-disponibile" %>">
			<img class="element-image"
				src="<%= request.getContextPath() + "/" + bean.getLinkImg()%>"
				alt="Immagine prodotto" />
			<h3 class="element-title"><%= bean.getNome() %></h3>
			<p class="element-description"><%= bean.getDescrizione() %></p>

			<% if (bean.isEliminato()) { %>
			<div class="warning-message">⚠️ PRODOTTO NON PIÙ DISPONIBILE</div>
			<p style="color: #6c757d; font-style: italic;">Questo prodotto è
				stato rimosso dal catalogo</p>
			<% } else { %>
			<p class="element-price">
				Prezzo: €<%= bean.getPrezzo() %></p>

			<% } %>

			<div
				style="display: flex; align-items: center; justify-content: space-between; margin-top: 15px;">
				<!-- Pulsante di rimozione sempre disponibile -->
				<form action="<%= request.getContextPath() %>/favorites"
					method="post" style="display: inline;">
					<input type="hidden" name="action" value="remove"> <input
						type="hidden" name="id" value="<%= bean.getIdProdotto() %>">
					<button type="submit"
						style="background: none; border: none; padding: 0; margin: 0; line-height: 0; font-size: 0; width: 30px; height: 30px; cursor: pointer;"
						title="Rimuovi dai preferiti">
						<img src="<%= request.getContextPath() %>/images/trash.png"
							alt="Rimuovi" style="width: 30px; height: 30px; display: block;">
					</button>
				</form>

				<!-- Link per visualizzare il prodotto solo se non è eliminato -->
				<% if (!bean.isEliminato()) { %>
				<a
					href="<%= request.getContextPath() + "/order?productId=" + bean.getIdProdotto() %>"
					title="Visualizza prodotto"> <img
					src="<%= request.getContextPath() %>/images/lente.png"
					alt="Visualizza" style="width: 40px; height: 40px;">
				</a>
				<% } else { %>
				<span style="color: #6c757d; font-style: italic;">Non
					visualizzabile</span>
				<% } %>
			</div>
		</div>
		<% } %>
	</div>
	<% } %>

</body>
</html>