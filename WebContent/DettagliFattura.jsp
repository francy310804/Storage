<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="it.unisa.order.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dettaglio Ordine</title>
<link rel="stylesheet"
	href="<%= request.getContextPath() %>/ProductStyle.css">

</head>
<body>
	<%if((Boolean)session.getAttribute("admin") == false){%>
	<jsp:include page="NavBar.jsp" />
	<%} %>

	<%
    List<ItemOrder> items = (List<ItemOrder>) request.getAttribute("dettagliFattura");
    if (items != null && !items.isEmpty()) {
%>

	<table>
		<tr>
			<th>Prodotto</th>
			<th>Immagine</th>
			<th>Quantità</th>
			<th>Prezzo Unitario</th>
			<th>Totale</th>
			<th>link accesso</th>
		</tr>
		<%
        for (ItemOrder item : items) {
            double totale = item.getNumItems() * item.getUnitCost();
    %>
		<tr>
			<td><%= item.getNome() %></td>
			<td><img
				src="<%= request.getContextPath() + "/" + item.getLinkImg() %>"
				alt="img prodotto" width="100" height="100" /></td>
			<td><%= item.getNumItems() %></td>
			<td>€ <%= String.format("%.2f", item.getUnitCost()) %></td>
			<td>€ <%= String.format("%.2f", totale) %></td>
			<td>
				<%
        		String link = item.getlinkAccesso();
        if(link == null) {%> nessun link disponibile. Il tuo prodotto
				arriverà presto. <%} else { %> <a href="<%= link%>"> link accesso
			</a> <%}%>
			
		</tr>
		<% } %>
	</table>

	<%
    } else {
%>
	<p style="text-align: center;">Nessun prodotto trovato per questa
		fattura.</p>
	<%
    }
%>

	<%if((Boolean)session.getAttribute("admin")){%>
	<a
		href="<%= request.getContextPath() %>/protectedUser/Administrator.jsp">Ritorna
		alla pagina admin</a>
	<%} %>


</body>
</html>