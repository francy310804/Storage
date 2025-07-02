<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>SpeakUp</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">
<style type="text/css">
/* Campo di ricerca principale */
#search-input {
  width: 300px;
  padding: 10px 40px 10px 16px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 25px;
  background-color: #fff;
  transition: border 0.3s, box-shadow 0.3s;
  background-image: url('https://cdn-icons-png.flaticon.com/512/622/622669.png');
  background-size: 20px;
  background-position: 270px center;
  background-repeat: no-repeat;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  outline: none;
}

#search-input:focus {
  border-color: #66afe9;
  box-shadow: 0 0 5px rgba(102,175,233,0.6);
}

/* Risultati dropdown */
#results {
  position: absolute;
  background: #fff;
  border: 1px solid #ccc;
  max-height: 250px;
  overflow-y: auto;
  width: 300px;
  margin-top: 4px;
  z-index: 1000;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  border-radius: 8px;
  font-family: Arial, sans-serif;
}

#results ul {
  list-style: none;
  margin: 0;
  padding: 0;
}

#results li {
  padding: 10px 16px;
  font-size: 14px;
  cursor: pointer;
  transition: background-color 0.2s;
}

#results li:hover {
  background-color: #f5f5f5;
}
</style>
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
  <input type="text" id="search" placeholder="cerca..." autocomplete="off" style="width: 25%; margin-left: 20px; position: relative;">
  <div id="results" style="position: relative;"></div>

</nav>

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
                dettagli(li);  // Passa il li cliccato
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
  function dettagli(li){
      const id = li.dataset.id;

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
      .then(response => {
        if (!response.ok) {
          throw new Error('HTTP error! status: '+ response.status);
        }
        return response.json();
      })
      .then(data => {
        const container = document.getElementById('details-container');
        const popupContent = document.getElementById('popup-content');

        container.style.display = 'flex';

        let html = 
          '<h3>Dettagli prodotto</h3>' +
          '<p><strong>Nome:</strong> ' + data.nome + '</p>' +
          '<p><strong>Categoria:</strong> ' + data.categoria + '</p>' +
          '<p><strong>Descrizione:</strong> ' + data.descrizione + '</p>';

        if (!data.categoria.toLowerCase().includes("corso")) {
          html += 
            '<p><strong>Stato:</strong> ' + (data.stato ? 'Disponibile' : 'Non disponibile') + '</p>' +
            '<p><strong>Stock:</strong> ' + data.stock + '</p>';
        }

        html += 
          '<p><strong>Lingua:</strong> ' + data.lingua + '</p>' +
          '<p><strong>IVA:</strong> ' + data.iva + '%</p>' +
          '<p><strong>Prezzo:</strong> €' + data.prezzo.toFixed(2) + '</p>' +
		  '<a href="product?action=add&id=' + data.IdProdotto + '">' +
	 	  '<img src="' + contextPath + '/images/chart.jpg" alt="chart" style="width:60px; height:auto; display: block; margin: 0 auto;">' +
		  '</a>';


        popupContent.innerHTML = html;
      })
      .catch(error => {
        console.error("Errore nella richiesta AJAX:", error);
      });
  }
</script>

</body>
</html>
