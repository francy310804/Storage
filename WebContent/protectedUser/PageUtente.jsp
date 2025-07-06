<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<%
    String path = request.getContextPath();
%>

<link rel="stylesheet" type="text/css"
	href="<%= path %>/protectedUser/PageUtente.css">

<title>Benvenuto <%= session.getAttribute("nome") %></title>
</head>
<body>
	<h1>
		Benvenuto
		<%= session.getAttribute("nome") %>
	</h1>
	<div class="paragrafo">Qui puoi cambiare i tuoi dati personali</div>
	<div>

		<div class="back">
			<a href="<%=path%>/ProductView.jsp">Ritorna alla Home</a>
		</div>

		<form id="logout-form"
			action="<%= request.getContextPath() %>/user?action=modifica"
			method="post">
			<!-- fa comparire i dati dell'utente per l'eventuale modifica -->
			<a href="<%= request.getContextPath() %>/UserControl?action=logout">
				<img src="<%= request.getContextPath() %>/images/logout.png"
				alt="Logout" style="width: 40px; height: auto;">
			</a>
	</div>

	<div class="form-row">
		<label for="email" class="descrizione">Email:</label> <input
			class="input" type="text" name="email" id="email"
			value="<%= session.getAttribute("email") %>">
	</div>

	<div class="form-row">
		<label for="nome" class="descrizione">Nome:</label> <input
			class="input" type="text" name="nome" id="nome"
			value="<%= session.getAttribute("nome") %>">
	</div>

	<div class="form-row">
		<label for="cognome" class="descrizione">Cognome:</label> <input
			class="input" type="text" name="cognome" id="cognome"
			value="<%= session.getAttribute("cognome") %>">
	</div>

	<div class="form-row">
		<label for="indirizzo" class="descrizione">Indirizzo:</label> <input
			class="input" type="text" name="indirizzo" id="indirizzo"
			value="<%= session.getAttribute("indirizzo") %>">
	</div>

	<div class="form-row">
		<label for="citta" class="descrizione">Città:</label> <input
			class="input" type="text" name="citta" id="citta"
			value="<%= session.getAttribute("città") %>">
	</div>

	<div class="form-row">
		<label for="provincia" class="descrizione">Provincia:</label> <input
			class="input" type="text" name="provincia" id="provincia"
			value="<%= session.getAttribute("provincia") %>">
	</div>

	<div class="form-row">
		<label for="cap" class="descrizione">CAP:</label> <input class="input"
			type="number" name="cap" id="cap"
			value="<%= session.getAttribute("Cap") %>">
	</div>




	<div class="password-section">
		<h2>Sezione cambio password</h2>
		<div class="paragrafo">In questa sezione puoi cambiare la tua
			password! Assicurati di inserire la tua vecchia password...</div>



		<div class="form-row">
			<label for="oldPass" class="descrizione">Vecchia password:</label> <input
				class="input" type="password" name="oldPass" id="oldPass"
				placeholder="Inserisci la vecchia password">
		</div>

		<div class="form-row">
			<label for="newPass" class="descrizione" required>Nuova
				password:</label> <input class="input" type="password" name="newPass"
				id="newPass" placeholder="Inserisci la nuova password">
		</div>

		<input type="submit" value="Modifica dati">
	</div>

	</form>