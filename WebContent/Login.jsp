<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login page</title>
<link rel = "stylesheet" type = "text/css" href="Login.css">
</head>
<body>

<div class="container">
  <div class="heading">Ciao!</div>
  <form action="UserControl?action=login" method="post" class="form" onsubmit="return validationEmail()">
    
    <input required class="input" type="text" id="email" name="email" placeholder="E-mail" onfocus="myFunction(this)">
    
    <input required class="input" type="password" name="password" placeholder="Password" onfocus="myFunction(this)">
    
    <span class="forgot-password">
      <a href="#">Password dimenticata ?</a>
    </span>
    <%if(session.getAttribute("failLogin") != null){ %>
    	<p class="error">Password/Email errate</p>
	<%} %>    
    <input class="login-button" type="submit" value="Benvenuto!">
    
    <div class="agreement">
      <a href="Registration.jsp">Per registrarti premi qui!</a>
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

function myFunction(x) {
  x.style.background = "lightblue";
}
</script>

</body>
</html>
