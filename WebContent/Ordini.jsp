<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import = "it.unisa.order.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>I miei ordini</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/ProductStyle.css">
</head>
<body>
<jsp:include page="NavBar.jsp" />

<h1>Storico ordini di <%= session.getAttribute("nome") %> </h1>

<%
	List<FatturaBean> fatture = (List<FatturaBean>) request.getAttribute("fatture");
    if (fatture == null || fatture.isEmpty()) {
%>
    <p>Non ci sono fatture da mostrare.</p>
<%
    } else {
%>
    <table border="1">
        <thead>
            <tr>
                <th>ID Fattura</th>
                <th>Data Ordine</th>
                <th>Prezzo Totale</th>
                <th>Dettagli</th>
            </tr>
        </thead>
        <tbody>
        <% for (FatturaBean fattura : fatture) { %>
            <tr>
                <td><%= fattura.getIdFattura() %></td>
                <td><%= fattura.getDataOrdine() %></td>
                <td><%= String.format("%.2f", fattura.getPrezzoTotale()) %> €</td>
                <td><a href="OrderControl?action=viewOrdineCompleto&idFattura=<%= fattura.getIdFattura() %>">Vedi dettagli</a><br>
                	<a href="OrderControl?action=inviofattura&idFattura=<%= fattura.getIdFattura() %>">Ricevi fattura</a></td>
            </tr>
        <% } %>
        </tbody>
    </table>
<%
    }
%>


</body>
</html>