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
<div id="google_translate_element" style="text-align: right;"></div>
<nav>
  <h2>SpeakUp!</h2>
  <a href="<%= request.getContextPath() %>/ProductView.jsp">Home</a>

  <% 
    if (session.getAttribute("user") != null) {
    	%>
	<a href="<%= request.getContextPath() %>/OrderControl?action=viewFatture">I miei ordini</a>  
	<a href="<%= request.getContextPath() %>/Favorite.jsp">Wishlist</a>
	 
    <%
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
  
  <div class="search-container">
    <input type="text" id="search" placeholder="Cerca prodotti..." autocomplete="off">
    <span class="search-icon">🔍</span>
    <div id="results"></div>
</div>

</nav>

<div id="details-container">
  <div>
    <button id="close-popup">X</button>
    <div id="popup-content"></div>
  </div>
</div>


<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

<script>
  const contextPath = "<%= request.getContextPath() %>";
</script>


<script>
function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'it',
    includedLanguages: 'it,en',
    layout: google.translate.TranslateElement.InlineLayout.SIMPLE
  }, 'google_translate_element');
}
</script>

<script>
  const input = document.getElementById('search');
  const results = document.getElementById('results');
  let timeout = null;

  input.addEventListener('input', () => {
    clearTimeout(timeout);
    const query = input.value.trim();

    if (query.length < 2) {
      results.innerHTML = '';
      results.style.display = 'none';
      return;
    }

    // Debounce: aspetta 300ms prima di fare la chiamata
    timeout = setTimeout(() => {
        fetch("product?action=cerca&q="+ encodeURIComponent(query))
          .then(response => response.json())
          .then(data => {
            if (data.length === 0) {
              results.innerHTML = '<p style="padding: 8px;">Nessun prodotto trovato.</p>';
              results.style.display = 'block';
              return;
            }

            let html = "<ul>";
            data.forEach(item => {
            	  html += '<li data-id="'+ item.idProdotto +'">' + item.nome+ ' - €' + item.prezzo.toFixed(2) + '</li>';
            	});
            html += "</ul>";
            results.innerHTML = html;
            results.style.display = 'block';

            // Aggiungi evento click su ogni risultato
            results.querySelectorAll('li').forEach(li => {
              li.addEventListener('click', () => {
                productOpen(li);  // Passa il li cliccato
              });
            });
          })
          .catch(() => {
            results.innerHTML = '<p style="padding: 8px;">Errore nella ricerca.</p>';
            results.style.display = 'block';
          });
      }, 300);
    });

    // Nascondi i risultati cliccando fuori
    document.addEventListener('click', (event) => {
      if (!results.contains(event.target) && event.target !== input) {
        results.style.display = 'none';
      }
    });

    // Chiudi popup cliccando la X
    document.getElementById('close-popup').addEventListener('click', () => {
      document.getElementById('details-container').style.display = 'none';
    });

  // Funzione per mostrare i dettagli e aggiungere al carrello
  function productOpen(li){
      const id = li.dataset.id;

      if (!id) {
        console.error("ID prodotto non valido.");
        return;
      }
      const url = "order?productId=" + id;

      window.location.href = url;
  }
</script>

</body>
</html>
