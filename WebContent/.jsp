<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registration page</title>
</head>
<body>
	<form action="Login" method="post">
		<h1>Registration page</h1>
		email: <input type="text" name="email"
			placeholder="insert your email here..."><br>
		<br> nome: <input type="text" name="nome"
			placeholder="insert your name here..."><br>
		<br> cognome: <input type="text" name="cognome"
			placeholder="insert your surname here..."><br>
		<br> indirizzo: <input type="text" name="indirizzo"
			placeholder="insert your address here..."><br>
		<br> città: <input type="text" name="citta"
			placeholder="insert your city here..."><br>
		<br> provincia: <input type="text" name="provincia"><br>
		<br> cap: <input type="number" name="cap"><br>
		<br> password: <input type="password" name="password"
			placeholder="insert your password here..."><br>
		<br> <input type="submit" value="registrati">
	</form>
</body>
</html>