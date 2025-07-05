<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session = "true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<%
    String path = request.getContextPath();
%>

<link rel = "stylesheet" type = "text/css" href="<%= path %>/PageUtente.css">
<title>Benvenuto <%= session.getAttribute("nome") %></title>
</head>
<body>
<h1>Benvenuto <%= session.getAttribute("nome") %> </h1>
<div class="paragrafo">Qui puoi cambiare i tuoi dati personali</div>
<div>
<form id="logout-form" action = "<%= request.getContextPath() %>/user?action=modifica" method = "post">
<!-- fa comparire i dati dell'utente per l'eventuale modifica -->
<a href="<%= request.getContextPath() %>/UserControl?action=logout">
  <img src="<%= request.getContextPath() %>/images/logout.png" alt="Logout" style="width:40px; height:auto;">
</a>
</form>
</div>

<div class="form-row">
  <label for="email" class="descrizione">Email:</label>
  <input class="input" type="text" name="email" id="email" value="<%= session.getAttribute("email") %>">
</div>

<div class="form-row">
  <label for="nome" class="descrizione">Nome:</label>
  <input class="input" type="text" name="nome" id="nome" value="<%= session.getAttribute("nome") %>">
</div>

<div class="form-row">
  <label for="cognome" class="descrizione">Cognome:</label>
  <input class="input" type="text" name="cognome" id="cognome" value="<%= session.getAttribute("cognome") %>">
</div>

<div class="form-row">
  <label for="indirizzo" class="descrizione">Indirizzo:</label>
  <input class="input" type="text" name="indirizzo" id="indirizzo" value="<%= session.getAttribute("indirizzo") %>">
</div>

<div class="form-row">
  <label for="citta" class="descrizione">Città:</label>
  <input class="input" type="text" name="citta" id="citta" value="<%= session.getAttribute("città") %>">
</div>

<div class="form-row">
  <label for="provincia" class="descrizione">Provincia:</label>
  <input class="input" type="text" name="provincia" id="provincia" value="<%= session.getAttribute("provincia") %>">
</div>

<div class="form-row">
  <label for="cap" class="descrizione">CAP:</label>
  <input class="input" type="number" name="cap" id="cap" value="<%= session.getAttribute("Cap") %>">
</div>




<h3>Sezione cambio password</h3>
<div class="paragrafo">In questa sezione puoi cambiare la tua password! 
assicurati di inserire la tua vecchia password...</div>

<input type = "checkbox" name = "check" value = "true"> clicca per cambiare la password 


vecchia password: <input type = "text" name = "oldPass" placeholder = "insert old password">
<br>
<br>

nuova passoword: <input type = "text" name = "newPass" placeholder = "insert new passowrd">

<br><br>

<input type = "submit" value = "modifica dati">

<!--  <a href = "<%=request.getContextPath()%>/ProductView.jsp"> Ritorna allo store</a> -->
</html>