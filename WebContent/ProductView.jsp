<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.*, it.unisa.product.ProductBean" %>

<%
    // Lista prodotti
    Collection<ProductBean> products = (Collection<ProductBean>) request.getAttribute("products");
    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/product");
        return;
    }

    // Lista prodotti preferiti (lista completa di ProductBean)
    Collection<ProductBean> favoriteProducts = (Collection<ProductBean>) request.getAttribute("favoriteProductIds");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Catalogo</title>

</head>
<body>

<jsp:include page="NavBar.jsp" />

<h2>Corsi</h2>
<div class="element-container">
<%
    for (ProductBean bean : products) {
        if (bean.getCategoria() != null && bean.getCategoria().toLowerCase().contains("corso")) {
            boolean isFavorite = false;
            if (favoriteProducts != null) {
                for (ProductBean fav : favoriteProducts) {
                    if (fav.getIdProdotto() == bean.getIdProdotto()) {
                        isFavorite = true;
                        break;
                    }
                }
            }
%>
    <div class="element-card">
        <form action="FavoriteController" method="post">
            <input type="hidden" name="productId" value="<%= bean.getIdProdotto() %>" />
            <button type="submit" name="action" value="<%= isFavorite ? "remove" : "add" %>" class="favorite-button" aria-label="Toggle Favorite">
                <% if (isFavorite) { %>
                    <span class="filled-heart">&#10084;</span>
                <% } else { %>
                    <span class="empty-heart">&#9825;</span>
                <% } %>
            </button>
        </form>

        <img class="element-image" src="<%= request.getContextPath() + "/" + bean.getLinkImg() %>" alt="Immagine corso" />
        <h3 class="element-title"><%= bean.getNome() %></h3>
        <p class="element-description"><%= bean.getDescrizione() %></p>
        <p class="element-description">Prezzo: €<%= bean.getPrezzo() %></p>

        <div class="element-actions">
            <button class="details-btn" data-id="<%= bean.getIdProdotto() %>">Details</button>
            <a class="review" href="<%= request.getContextPath() + "/order?productId=" + bean.getIdProdotto() %>">Review</a>
            <a href="product?action=add&id=<%= bean.getIdProdotto() %>">AddCarrello</a>
        </div>
    </div>
<%
        }
    }
%>
</div>

<h2>Materiali di supporto</h2>
<div class="element-container">
<%
    for (ProductBean bean : products) {
        if (bean.getCategoria() != null && !bean.getCategoria().toLowerCase().contains("corso") && bean.getStock() > 0) {
            boolean isFavorite = false;
            if (favoriteProducts != null) {
                for (ProductBean fav : favoriteProducts) {
                    if (fav.getIdProdotto() == bean.getIdProdotto()) {
                        isFavorite = true;
                        break;
                    }
                }
            }
%>
    <div class="element-card">
        <form action="FavoriteController" method="post">
            <input type="hidden" name="productId" value="<%= bean.getIdProdotto() %>" />
            <button type="submit" name="action" value="<%= isFavorite ? "remove" : "add" %>" class="favorite-button" aria-label="Toggle Favorite">
                <% if (isFavorite) { %>
                    <span class="filled-heart">&#10084;</span>
                <% } else { %>
                    <span class="empty-heart">&#9825;</span>
                <% } %>
            </button>
        </form>

        <img class="element-image" src="<%= request.getContextPath() + "/" + bean.getLinkImg() %>" alt="Immagine materiale" />
        <h3 class="element-title"><%= bean.getNome() %></h3>
        <p class="element-description"><%= bean.getDescrizione() %></p>
        <p class="element-description">Prezzo: €<%= bean.getPrezzo() %></p>

        <div class="element-actions">
            <button class="details-btn" data-id="<%= bean.getIdProdotto() %>">Details</button>
            <a class="review" href="<%= request.getContextPath() + "/order?productId=" + bean.getIdProdotto() %>">Review</a>
            <a href="product?action=add&id=<%= bean.getIdProdotto() %>">AddCarrello</a>
        </div>
    </div>
<%
        }
    }
%>
</div>

<!-- Dettagli prodotto popup -->
<div id="details-container" style="
    display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5);
    justify-content:center; align-items:center; z-index:1000;">
    <div style="
        background:white; padding:20px; border-radius:8px; width:300px; max-width:90%; position:relative;">
        <button id="close-popup" style="position:absolute; top:5px; right:5px; font-weight:bold; cursor:pointer;">X</button>
        <div id="popup-content"></div>
    </div>
</div>

<script>
    const contextPath = "<%= request.getContextPath() %>";
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.details-btn').forEach(button => {
            button.addEventListener('click', () => {
                const id = button.dataset.id;
                if (!id) {
                    console.error("ID prodotto non valido.");
                    return;
                }

                fetch(`product?action=read&id=${id}`, {
                    headers: { "X-Requested-With": "XMLHttpRequest" }
                })
                .then(response => {
                    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                    return response.json();
                })
                .then(data => {
                    const container = document.getElementById('details-container');
                    const popupContent = document.getElementById('popup-content');

                    container.style.display = 'flex';

                    let html = `<h3>Dettagli prodotto</h3>
                                <p><strong>Nome:</strong> ${data.nome}</p>
                                <p><strong>Categoria:</strong> ${data.categoria}</p>
                                <p><strong>Descrizione:</strong> ${data.descrizione}</p>`;

                    if (!data.categoria.toLowerCase().includes("corso")) {
                        html += `<p><strong>Stato:</strong> ${data.stato ? 'Disponibile' : 'Non disponibile'}</p>
                                 <p><strong>Stock:</strong> ${data.stock}</p>`;
                    }

                    html += `<p><strong>Lingua:</strong> ${data.lingua}</p>
                             <p><strong>IVA:</strong> ${data.iva}%</p>
                             <p><strong>Prezzo:</strong> €${data.prezzo}</p>
                             <a href="product?action=add&id=${data.IdProdotto}">
                                <img src="${contextPath}/images/chart.jpg" alt="chart" style="width:60px; height:auto; display:block; margin: 0 auto;">
                             </a>`;

                    popupContent.innerHTML = html;
                })
                .catch(error => console.error("Errore nella richiesta AJAX:", error));
            });
        });

        document.getElementById('close-popup').addEventListener('click', () => {
            document.getElementById('details-container').style.display = 'none';
        });
    });
</script>

</body>
</html>