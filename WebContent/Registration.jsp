<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">		
<title>Registration page</title>
<link rel = "stylesheet" type = "text/css" href="Login.css">

</head>
<body>

<div>
<form id = "login" action = "UserControl?action=registration" method = "post" onsubmit="return validationEmail()">
<h1>Registration</h1>
email: <input type = "text" name = "email" placeholder = "insert your email.." required><br><br> 
nome: <input type = "text" name = "nome" placeholder = "insert your name.." required><br><br> 
cognome: <input type = "text" name = "cognome" placeholder = "insert your surname.." required><br><br> 
indirizzo: <input type = "text" name = "indirizzo" placeholder = "insert your address.." required><br><br> 
città: <input type = "text" name = "citta" placeholder = "insert your city.." required><br><br> 
provincia: <input type = "text" name = "provincia" required><br><br> 	
cap: <input type = "number" name = "cap" required><br><br> 
password: <input type = "password" name = "password" placeholder = "insert your password.." required><br><br> 
<input type = "submit" value ="registrati"> 
<br>
<br>

<h2>Sei già registrato? </h2>
<a href = "Login.jsp">Clicca qui per il Login!</a>
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