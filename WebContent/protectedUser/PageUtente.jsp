<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session = "true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<%
    String path = request.getContextPath();
%>

<link rel = "stylesheet" type = "text/css" href="<%= path %>/Login.css">
<title>Benvenuto <%= session.getAttribute("nome") %></title>
</head>
<body>

<h1>BENVENUTO <%= session.getAttribute("nome") %> </h1>
<form action = "<%= request.getContextPath() %>/user?action=modifica" method = "post">
<!-- fa comparire i dati dell'utente per l'eventuale modifica -->
<a href="<%= request.getContextPath() %>/UserControl?action=logout">
  <img src="<%= request.getContextPath() %>/images/logout.png" alt="Logout" style="width:40px; height:auto;">
</a>
<br>
<br>

email: <input type = "text" name = "email" value = <%= session.getAttribute("email") %>><br><br> 
nome: <input type = "text" name = "nome" value = <%= session.getAttribute("nome") %>><br><br> 
cognome: <input type = "text" name = "cognome" value = <%= session.getAttribute("cognome") %>><br><br> 
indirizzo: <input type = "text" name = "indirizzo" value = <%= session.getAttribute("indirizzo") %>><br><br> 
città: <input type = "text" name = "citta" value = <%= session.getAttribute("città") %>><br><br> 
provincia: <input type = "text" name = provincia value =  <%= session.getAttribute("provincia") %> ><br><br> 	
cap: <input type = "number" name = "cap" value =  <%= session.getAttribute("Cap") %>><br><br> 

<br><br>

<h3>Sezione cambio password</h3>
<p>In questa sezione puoi cambiare la tua password! <br>
assicurati di inserire la tua vecchia password...</p>
<br>
<input type = "checkbox" name = "check" value = "true"> clicca per cambiare la password 
<br>
<br>

vecchia password: <input type = "text" name = "oldPass" placeholder = "insert old password">
<br>
<br>

nuova passoword: <input type = "text" name = "newPass" placeholder = "insert new passowrd">

<br><br>

<input type = "submit" value = "modifica dati">

<a href = "<%=request.getContextPath()%>/ProductView.jsp"> Ritorna allo store</a>
</form>
</html>