<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>
<%@ page
	import="java.util.*,it.unisa.product.ProductBean,it.unisa.order.Carrello,it.unisa.user.UserBean, it.unisa.order.*"%>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("admin");
    Collection<?> products = (Collection<?>) request.getAttribute("products");
  	Collection<?> users = (Collection<?>) request.getAttribute("users");
    Collection<?> orders = (Collection<?>) request.getAttribute("orders");

  	if(products == null) {
        response.sendRedirect(request.getContextPath() + "/product");
        return; 
    }
  	

  
    ProductBean product = (ProductBean) request.getAttribute("product");
   

    

%>

<!DOCTYPE html>
<html>
<% if (Boolean.TRUE.equals(isAdmin)) { %>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="ProductStyle.css">
<title>Catalogo</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>

<body>
	<h1>
		BENVENUTO AMMINISTRATORE
		<%= session.getAttribute("nome") %>
	</h1>

	<p>In questa pagina puoi visualizzare il materiale del sito,
		apportare delle modifiche e fare inserimenti</p>

	<a href="<%= request.getContextPath() %>/UserControl?action=logout">
		<img src="<%= request.getContextPath() %>/images/logout.png"
		alt="Logout" style="width: 40px; height: auto;">
	</a>
	<br>
	<br>

	<div class="button-group">
		<button data-target="ProdottiCorsi">Corsi</button>
		<button data-target="ProdottiMateriali">Materiali</button>
		<button data-target="insert">Inserimento</button>
		<button data-target="Utenti">Visualizza utenti e ordini</button>
		<button data-target="Ordini">Ordini</button>
		
	</div>

	<!-- Sezione Corsi (modificata per includere anche quelli eliminati) -->
	<div id="ProdottiCorsi" class="element-container">
		<%
        if (products != null && !products.isEmpty()) {
            for (Object obj : products) {
                ProductBean bean = (ProductBean) obj;
                if (bean.getCategoria() != null && bean.getCategoria().toLowerCase().contains("corso")) {
    %>
		<div class="element-card">
			<img class="element-image"
				src="<%= request.getContextPath() %>/<%= bean.getLinkImg() %>"
				alt="Immagine corso">
			<h3 class="element-title"><%= bean.getNome() %></h3>
			<p class="element-description"><%= bean.getDescrizione() %></p>
			<p class="element-description">
				Prezzo: €<%= bean.getPrezzo() %></p>

			<% if (bean.isEliminato()) { %>
			<p style="color: red; font-weight: bold;">CORSO ELIMINATO</p>
			<% } %>

			<div class="element-actions">
				<% if (!bean.isEliminato()) { %>
				<a href="product?action=delete&id=<%=bean.getIdProdotto()%>"
					onclick="return confirm('Sei sicuro di voler eliminare questo corso?')">
					Delete </a>
				<% } else { %>
				<a href="product?action=restore&id=<%=bean.getIdProdotto()%>"
					onclick="return confirm('Sei sicuro di voler ripristinare questo corso?')"
					style="color: green; font-weight: bold;"> Ripristina </a>
				<% } %>
				<button class="details-btn" data-id="<%=bean.getIdProdotto()%>">Details</button>
				<button class="modify-btn" data-id="<%=bean.getIdProdotto()%>">Modifica</button>
				
			</div>
		</div>
		<%
                }
            }
        }
    %>
	</div>

	<!-- Sezione Materiali (modificata per includere anche quelli eliminati) -->
	<div id="ProdottiMateriali" class="element-container">
		<%
        if (products != null && !products.isEmpty()) {
            for (Object obj : products) {
                ProductBean bean = (ProductBean) obj;
                // Mostra tutti i materiali (non corsi), inclusi quelli eliminati
                if (bean.getCategoria() != null && 
                    !bean.getCategoria().toLowerCase().contains("corso")) {
    %>
		<div class="element-card">
			<img class="element-image"
				src="<%= request.getContextPath() %>/<%= bean.getLinkImg() %>"
				alt="Immagine materiale">
			<h3 class="element-title"><%= bean.getNome() %></h3>
			<p class="element-description"><%= bean.getDescrizione() %></p>
			<p class="element-description">
				Prezzo: €<%= bean.getPrezzo() %></p>
			<p class="element-description">
				Stock:
				<%= bean.getStock() %></p>

			<% if (bean.isEliminato()) { %>
			<p style="color: red; font-weight: bold;">MATERIALE ELIMINATO</p>
			<% } %>

			<div class="element-actions">
				<% if (!bean.isEliminato()) { %>
				<a href="product?action=delete&id=<%=bean.getIdProdotto()%>"
					onclick="return confirm('Sei sicuro di voler eliminare questo materiale?')">
					Delete </a>
				<% } else { %>
				<a href="product?action=restore&id=<%=bean.getIdProdotto()%>"
					onclick="return confirm('Sei sicuro di voler ripristinare questo materiale?')"
					style="color: green; font-weight: bold;"> Ripristina </a>
				<% } %>
				<button class="details-btn" data-id="<%=bean.getIdProdotto()%>">Details</button>
			</div>
		</div>
		<%
                }
            }
        }
    %>
	</div>

	<!-- Sezione Inserimento -->
	<div class="element-container" id="insert">
		<form id="inserimento"
			action="<%=request.getContextPath()%>/product?action=insert"
			method="post">
			<label for="nome">Nome:</label><br> <input name="nome"
				type="text" maxlength="20" required placeholder="inserisci nome"><br>

			<label for="categoria">Categoria:</label><br> <label><input
				type="radio" name="categoria" value="corso"> corso</label> <label><input
				type="radio" name="categoria" value="oggetto"> oggetto</label><br>

			<label for="descrizione">Descrizione:</label><br>
			<textarea name="descrizione" maxlength="100" rows="3" required
				placeholder="inserisci descrizione"></textarea>
			<br> <label for="stato">Stato:</label><br> <label><input
				type="radio" name="disponibilita" value="true"> Disponibile</label>
			<label><input type="radio" name="disponibilita" value="false">
				Non disponibile</label><br> <label for="lingua">Lingua:</label><br>
			<textarea name="lingua" maxlength="100" rows="3" required
				placeholder="inserisci lingua"></textarea>
			<br> <label for="IVA">IVA:</label><br> <input name="IVA"
				type="number" max="100" required placeholder="inserisci l'IVA"><br>

			<label for="Prezzo">Prezzo:</label><br> <input name="prezzo"
				type="number" min="0" value="0" required><br> <label
				for="Stock">Stock:</label><br> <input name="stock"
				type="number" min="0" value="0" required><br> <label
				for="LinkAccesso">Link Accesso:</label><br>
			<textarea name="linkaccesso" maxlength="100" rows="3" required
				placeholder="inserisci link accesso"></textarea>
			<br> <label for="linkImg">Link immagine: </label><br>
			<textarea name="linkImg" maxlength="200" rows="3" required
				placeholder="inserisci link immagine"></textarea>
			<br> <input type="submit" value="Add"><input
				type="reset" value="Reset">
		</form>
	</div>

	<!-- Sezione Utenti -->
	<div class="element-container" id="Utenti">
		<table>
			<tr>
				<th>Id</th>
				<th>Email</th>
				<th>Cognome</th>
				<th>Nome</th>
				<th>Ordini Utente</th>
			</tr>
			<%
        if (users != null && !users.isEmpty()) {
            for (Object obj : users) {
                UserBean bean = (UserBean) obj;
    %>
			<tr>
				<th><%=bean.getId()%></th>
				<th><%=bean.getEmail() %></th>
				<th><%=bean.getCognome() %></th>
				<th><%=bean.getNome() %></th>
				<th><a href="order?action=viewFatture&id=<%=bean.getId()%>">
						Ordini</a></th>
			</tr>
			<%}
            } %>
		</table>
	</div>



<div class="element-container" id="Ordini">
		<table>
			<tr>
				<th>Id</th>
				<th>Utente</th>
				<th>Data Ordine</th>
				<th>Totale</th>
			</tr>
			<%
        if (orders != null && !orders.isEmpty()) {
            for (Object obj : orders) {
                FatturaBean bean = (FatturaBean) obj;
    %>
			<tr>
				<th><%=bean.getIdFattura()%></th>
				<th><%=bean.getIdUtente()%></th>
				<th><%=bean.getDataOrdine()%></th>
				<th><%= String.format("%.2f", bean.getPrezzoTotale()) %></th>
			</tr>
			<%}
            } %>
		</table>
	</div>



<div class="element-container" id="modifica">
		<form id="inserimento"
			action="<%=request.getContextPath()%>/product?action=modifica"
			method="post">
			<input type = "hidden" id = "productIdField" name ="id">
					<br> <label for="IVA">IVA:</label><br> <input name="IVA"
				type="number" max="100" required placeholder="inserisci l'IVA"><br>

			<label for="Prezzo">Prezzo:</label><br> <input name="prezzo"
				type="number" min="0" value="0" required><br>
			<br> <input type="submit" value="Add"><input
				type="reset" value="Reset">
		</form>
	</div>



	<!-- Contenitore dettagli prodotti (UNICO) -->
	<div id="details-container">
		<div id="details-background">
			<button id="close-popup">X</button>
			<div id="popup-content"></div>
		</div>
	</div>



	<script>
document.addEventListener('DOMContentLoaded', () => {
    console.log("DOM ready");

    // Trova i bottoni details
    document.querySelectorAll('.details-btn').forEach(button => {
        // Per ogni bottone aggiunge il listener
        button.addEventListener('click', () => {
            // Prende l'id del prodotto dal bottone
            const id = button.dataset.id;
            
            // Verifica che l'ID non sia nullo o vuoto
            if (!id) {
                console.error("ID prodotto non valido.");
                return;
            }

            const url = "product?action=read&id=" + id;

            fetch(url, {
                headers: {
                    "X-Requested-With": "XMLHttpRequest" // per distinguere richiesta AJAX
                }
            })
            // Converte la risposta in JSON
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                // Trova il div dove mostrare i dettagli
                const container = document.getElementById('details-container');
                const popupContent = document.getElementById('popup-content');

                // Mostra il div
                container.style.display = 'flex';

                // Costruiamo l'html con i dettagli base
                let html = 
                    '<h3>Dettagli prodotto</h3>' +
                    '<p><strong>Nome:</strong> ' + data.nome + '</p>' +
                    '<p><strong>Categoria:</strong> ' + data.categoria + '</p>' +
                    '<p><strong>Descrizione:</strong> ' + data.descrizione + '</p>';

                // Se non è un corso ma un oggetto vengono mostrati lo stato e il num. in stock
                if (!data.categoria.toLowerCase().includes("corso")) {
                    html += 
                        '<p><strong>Stato:</strong> ' + (data.stato ? 'Disponibile' : 'Non disponibile') + '</p>' +
                        '<p><strong>Stock:</strong> ' + data.stock + '</p>';
                }

                // Aggiungiamo lingua, IVA e prezzo
                html += 
                    '<p><strong>Lingua:</strong> ' + data.lingua + '</p>' +
                    '<p><strong>IVA:</strong> ' + data.iva + '%</p>' +
                    '<p><strong>Prezzo:</strong> €' + data.prezzo + '</p>';

                // Inserisce l'html nel div
                popupContent.innerHTML = html;
            })
            .catch(error => {
                console.error("Errore nella richiesta AJAX:", error);
            });
        });
    });

    // Chiusura popup
    document.getElementById('close-popup').addEventListener('click', () => {
        document.getElementById('details-container').style.display = 'none';
    });
});
</script>

	<script>
$(document).ready(function(){
    $(".element-container").hide();

    // Mostra solo il contenitore desiderato all'avvio
    $("#ProdottiCorsi").show();
    
    $(".button-group button").click(function(){
        const targetId = $(this).data("target");
        // Nasconde tutti i div aperti
        $(".element-container").slideUp(300);
        // Mostra solo il div selezionato
        $("#" + targetId).delay(300).slideDown(300);
    });
});
</script>



<script>
$(document).ready(function() {
	$(".modify-btn").click(function() {
	    $("#modifica").show();
	    var id = $(this).data("id");
	    $("#productIdField").val(id);
		$("#modifica").slideDown(300);
	})
})


</script>
</body>

<% } else { %>
<head>
<meta http-equiv="refresh" content="5;URL=Login.jsp">
<title>ACCESSO NEGATO</title>
</head>
<body>
	<p style="color: red;">
	<h1>ACCESSO NEGATO SARAI RINDIRIZZATO TRA 5 SECONDI</h1>
	</p>
</body>
<% } %>
</html>