<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="it.unisa.product.*, it.unisa.favorite.*, java.util.*" %>

<%
    Collection<ProductBean> products = (Collection<ProductBean>) request.getAttribute("favoriteProductIds");

    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/favorites");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
      <link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">
    
    <title>Prodotti Preferiti</title>

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
%>
    <div class="element-container">
    <%
        for (ProductBean bean : products) {
    %>
        <div class="element-card">
            <img class="element-image" src="<%= request.getContextPath() + "/" + bean.getLinkImg()%>" alt="Immagine prodotto" />
            <h3 class="element-title"><%= bean.getNome() %></h3>
            <p class="element-description"><%= bean.getDescrizione() %></p>
            <p class="element-price">Prezzo: €<%= bean.getPrezzo() %></p>
			<form action="${pageContext.request.contextPath}/favorites" method="post">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="id" value="<%= bean.getIdProdotto() %>">
				<button type="submit" style="background:none; border:none; padding:0; margin:0; line-height:0; font-size:0; width:30px; height:30px; cursor:pointer;">
    			<img src="<%= request.getContextPath() %>/images/trash.png" alt="Rimuovi" style="width:30px; height:30px; display:block;">
				</button>   
				
				<a href="<%= request.getContextPath() + "/order?productId=" + bean.getIdProdotto() %>">
				<img src = "<%= request.getContextPath() %>/images/lente.png" alt="Visualizza" style="width:40px; height:40px; margin-left:30px;">
				</a>     
		</form>        
   	
		    
        </div>
    <%
        }
    %>
    </div>
<%
    }
%>

</body>
</html>