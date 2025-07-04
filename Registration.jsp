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
<div class ="container">
	<div class="heading">Benvenuto in SpeakUp!</div>
<form class="form" action="UserControl?action=registration" method="post" onsubmit="return validationEmail()">
  
  
  <input class="input" type="email" name="email" placeholder="E-mail" required>
  

  <div class="row">
    <input class="input half" type="text" name="nome" placeholder="Nome" required>
    <input class="input half" type="text" name="cognome" placeholder="Cognome" required>
  </div>
  
  
  <div class="row">
    <input class="input half" type="text" name="indirizzo" placeholder="Indirizzo" required>
    <input class="input half" type="text" name="citta" placeholder="Città" required>
  </div>
  
  
  <div class="row">
    <input class="input half" type="text" name="provincia" placeholder="Provincia" required>
    <input class="input half" type="number" name="cap" placeholder="CAP" required>
  </div>
  
 
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