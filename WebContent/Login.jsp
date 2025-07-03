<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login page</title>
<link rel = "stylesheet" type = "text/css" href="Login.css">
</head>
<body>

<jsp:include page="NavBar.jsp"/>


<div>
<form id = "login" action="UserControl?action=login" method="post" onsubmit="return validationEmail()">
  <h1>Login</h1>
  <span class = "c1">email: <input type="text" id="email" name="email" placeholder="insert your email.." onfocus="myFunction(this)"></span><br><br>
  <span class = "c1">password: <input type="password" name="password" placeholder="insert your password.." onfocus="myFunction(this)"></span><br><br> 
  <input type="submit" value="Accedi">
  <br><br>
  <span>  <a href ="Registration.jsp">Per registrarti premi qui!</a></span>
  
</form>
<br><br> 
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
