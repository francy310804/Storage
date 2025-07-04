<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*,it.unisa.product.ProductBean,it.unisa.order.Carrello,it.unisa.order.ItemOrder"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chart</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">
</head>
<body>

<jsp:include page="NavBar.jsp" />

<h2>Carrello</h2>

<table border="1">
    <tr>
        <th>Nome</th>
        <th>Prezzo</th>
        <th>Quantità</th>
        <th>Rimuovi</th>
    </tr>

<%
    Carrello carrello = (Carrello) session.getAttribute("carrello");
    if (carrello != null) {
        List<ItemOrder> itemsOrdered = carrello.getProdotti();
        if (itemsOrdered.size() == 0) {
%>
    <tr>
        <td colspan="4">No products in your shopping cart</td>
    </tr>
<%
        } else {
            for (ItemOrder x : itemsOrdered) {
%>
    <tr>
        <td><%= x.getNome() %></td>
        <td><%= String.format("%.2f", x.getUnitCost()) %> €</td>
        
	<td>
    <form action="${pageContext.request.contextPath}/product" method="post" style="display: inline-block;">
        <input type="hidden" name="action" value="updateQuantity">
        <input type="hidden" name="id" value="<%= x.getItemID() %>">
        <input type="number" name="quantity" value="<%= x.getNumItems() %>" min="1" style="width: 50px;">
        <button type="submit">Aggiorna</button>
    </form>
    
	</td>       
	<td>
		<form action="${pageContext.request.contextPath}/product" method="post">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="id" value="<%= x.getItemID() %>">
				<button type="submit" style="background:none; border:none; padding:0; margin:0; line-height:0; font-size:0; width:30px; height:30px; cursor:pointer;">
    			<img src="<%= request.getContextPath() %>/images/trash.png" alt="Rimuovi" style="width:30px; height:30px; display:block;">
				</button>          
        	</form>
        </td>
    </tr>
<%
            }
        } 
    }
%>
</table>

<% if (carrello != null && !carrello.getProdotti().isEmpty()) { %>

<p>
    Totale carrello: <strong><%= String.format("%.2f", carrello.getTotale()) %> €</strong>
</p>

<form action="${pageContext.request.contextPath}/order" method="post">
    <input type="hidden" name="action" value="checkout">
    <button type="submit" style="width:60px; height:40px;">Acquista</button>
</form>
<% } %>

</body>
</html>