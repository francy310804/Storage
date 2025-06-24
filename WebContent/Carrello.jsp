<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*,it.unisa.product.ProductBean,it.unisa.product.Carrello, it.unisa.product.ItemOrder"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">

</head>
<body>

<h2>Carrello</h2>
<table border="1">
    <tr>
        <th>Nome</th>
        <th>Prezzo</th>
        <th>Quantità</th>
    </tr>

<%
    Carrello carrello = (Carrello) session.getAttribute("carrello");
    if (carrello != null) {
        List<ItemOrder> itemsOrdered = carrello.getProdotti();
        if (itemsOrdered.size() == 0) {
%>
    <tr>
        <td colspan="3">No products in your shopping cart</td>
    </tr>
<%
        } else {
            for (ItemOrder x : itemsOrdered) {
%>
    <tr>
        <td><%= x.getNome() %></td>
        <td><%= x.getUnitCost() %></td>
        <td><%= x.getNumItems() %></td>
    </tr>
<%
            }
        } 
    }
%>


</body>
</html>