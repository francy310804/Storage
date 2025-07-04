<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">		
<title>Registration page</title>
<link rel = "stylesheet" type = "text/css" href="Registration.css">

</head>
<body>
<div class = "container">
	<div class = "heading">Benvenuto Admin!</div>
<form class="form" action = "AdminControl?action=registration" method = "post" onsubmit="return validationEmail()">

<input class="input" type="email" name="email" placeholder="E-mail" required>
<input class="input" type="text" name="nome" placeholder="Nome" required>
<input class="input" type="text" name="cognome" placeholder="Cognome" required>
<input class="input" type="password" name="password" placeholder="Password" required> 
  
<input class="login-button" type="submit" value="Registrati">

  <div class="agreement">
    <a href="Login.jsp">Sei già registrato? Clicca qui per il login!</a>
  </div>
</form>
</div>

<script>
function validationEmail() {
	  var email = document.getElementById("email").value;
	  var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

	  if (!regex.test(email)) {
	    alert("Email non valida. Riprova.");
	    return false;
	  }

	  return true;
	}

</script>
</body>
</html>