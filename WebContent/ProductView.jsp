<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	session ="true"%>
	

<%
	Collection<?> products = (Collection<?>) request.getAttribute("products");
	if(products == null) {
        response.sendRedirect(request.getContextPath() + "/product");
		return; 
	}
	ProductBean product = (ProductBean) request.getAttribute("product");
%>

<!DOCTYPE html>
<html>
<%@ page contentType="text/html; charset=UTF-8" 
import="java.util.*,it.unisa.product.ProductBean,it.unisa.order.Carrello,it.unisa.order.ItemOrder"
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Catalogo</title>
</head>


<body>

<jsp:include page="NavBar.jsp" />

<h2>Corsi</h2>
<div class="element-container">
  <%
    if (products != null && !products.isEmpty()) {
      Iterator<?> it = products.iterator();
      while (it.hasNext()) {
        ProductBean bean = (ProductBean) it.next();
        if (bean.getCategoria() != null && bean.getCategoria().toLowerCase().contains("corso")) {
  %>
    
<div class="element-card">
<img class="element-image" src="<%= request.getContextPath() %>/<%= bean.getLinkImg() %>" alt="Immagine corso">
  <h3 class="element-title"><%= bean.getNome() %></h3>
  <p class="element-description"><%= bean.getDescrizione() %></p>
  <p class="element-description">Prezzo: €<%= bean.getPrezzo() %></p>
  <div class="element-actions">
  <button class="details-btn" data-id="<%=bean.getIdProdotto()%>">Details</button>    
<a class="review" href="<%=request.getContextPath()%>/order?productId=<%=bean.getIdProdotto()%>">Review</a>
 <a href="product?action=add&id=<%=bean.getIdProdotto()%>">AddCarrello</a>
</div>
    </div>
  <%
        }
      }
    }
  %>
</div>



<!--contenitore dettagli prodotti-->
<div id="details-container" style="
    display: none; 
    position: fixed; 
    top: 0; left: 0; 
    width: 100%; height: 100%; 
    background-color: rgba(0,0,0,0.5); 
    justify-content: center; 
    align-items: center; 
    z-index: 1000;">
  <div style="
      background: white; 
      padding: 20px; 
      border-radius: 8px; 
      width: 300px; 
      max-width: 90%; 
      position: relative;">
    <button id="close-popup" style="
        position: absolute; 
        top: 5px; 
        right: 5px; 
        font-weight: bold; 
        cursor: pointer;">X</button>
    <div id="popup-content"></div>
  </div>
</div>




	<br><br><br>
	<h2>Materiali di supporto</h2>
	
	<div class="element-container">
  <%
    if (products != null && !products.isEmpty()) {
      Iterator<?> it = products.iterator();
      while (it.hasNext()) {
        ProductBean bean = (ProductBean) it.next();
        if (bean.getCategoria() != null && bean.getStock() != 0) {
  %>
<div class="element-card">
<img class="element-image" src="<%= request.getContextPath() %>/<%= bean.getLinkImg() %>" alt="Immagine materiale">
  <h3 class="element-title"><%= bean.getNome() %></h3>
  <p class="element-description"><%= bean.getDescrizione() %></p>
  <p class="element-description">Prezzo: €<%= bean.getPrezzo() %></p>
  <div class="element-actions">
<button class="details-btn" data-id="<%=bean.getIdProdotto()%>">Details</button>   
<a class="review" href="<%=request.getContextPath()%>/order?productId=<%=bean.getIdProdotto()%>">Review</a>

 <a href="product?action=add&id=<%=bean.getIdProdotto()%>">AddCarrello</a>
</div>
    </div>
  <%
        }
      }
    }
  %>
</div>


<script>
  const contextPath = "<%= request.getContextPath() %>";
</script>

<script>
document.addEventListener('DOMContentLoaded', () => {
	  console.log("DOM ready");
	

  // trova i bottoni details
  document.querySelectorAll('.details-btn').forEach(button => {

    // per ogni bottone aggiunge il listener
    button.addEventListener('click', () => {


      // prende l'id del prodotto dal bottone
      const id = button.dataset.id;
      
      
      // Verifica che l'ID non sia nullo o vuoto
      if (!id) {
        console.error("ID prodotto non valido.");
        return;
      }

      const url = "product?action=read&id="+id;
      

      fetch(url, {
        headers: {
          "X-Requested-With": "XMLHttpRequest" // per distinguere richiesta AJAX
        }
      })

      // converte la risposta in JSON
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })

      .then(data => {

        // trova il div dove mostrare i dettagli
        const container = document.getElementById('details-container');
        const popupContent = document.getElementById('popup-content');

        // mostra il div
        container.style.display = 'flex';

        // costruiamo l'html con i dettagli base
        let html = 
          '<h3>Dettagli prodotto</h3>' +
          '<p><strong>Nome:</strong> ' + data.nome + '</p>' +
          '<p><strong>Categoria:</strong> ' + data.categoria + '</p>' +
          '<p><strong>Descrizione:</strong> ' + data.descrizione + '</p>';

        // se non è un corso ma un oggetto vengono mostrati lo stato e il num. in stock
        if (!data.categoria.toLowerCase().includes("corso")) {
          html += 
            '<p><strong>Stato:</strong> ' + (data.stato ? 'Disponibile' : 'Non disponibile') + '</p>' +
            '<p><strong>Stock:</strong> ' + data.stock + '</p>';
        }

        // aggiungiamo lingua, IVA e prezzo
		html += 
  			'<p><strong>Lingua:</strong> ' + data.lingua + '</p>' +
  			'<p><strong>IVA:</strong> ' + data.iva + '%</p>' +
  			'<p><strong>Prezzo:</strong> €' + data.prezzo + '</p>' +
 			'<a href="product?action=add&id=' + data.IdProdotto + '">' +
   	 		'<img src="' + contextPath + '/images/chart.jpg" alt="chart" style="width:60px; height:auto; display: block; margin: 0 auto;">' +
			'</a>';


        // inserisce l'html nel div
        popupContent.innerHTML = html;
      })

      .catch(error => {
        console.error("Errore nella richiesta AJAX:", error);
      });
    });

  });
});
</script>


<script>

document.getElementById('close-popup').addEventListener('click', () => {
	  document.getElementById('details-container').style.display = 'none';
	});

</script>





</body>
</html>


