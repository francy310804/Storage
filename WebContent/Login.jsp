<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login page</title>
<style>
body {
    height: 100vh;
    margin: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
    background: linear-gradient(-45deg,
        #e6f7fb,
        #cceeff,
        #aeefff,
        #b2f0f7,
        #23a6d5,
        #87ceeb,
        #f0f8ff,
        #b8e6ff
    );
    background-size: 600% 600%;
    animation: gradientFlow 15s ease-in-out infinite;
}

@keyframes gradientFlow {
    0% {
        background-position: 0% 50%;
        filter: hue-rotate(0deg) saturate(1);
    }
    12.5% {
        background-position: 25% 25%;
        filter: hue-rotate(5deg) saturate(1.1);
    }
    25% {
        background-position: 100% 0%;
        filter: hue-rotate(10deg) saturate(1.2);
    }
    37.5% {
        background-position: 75% 75%;
        filter: hue-rotate(15deg) saturate(1.1);
    }
    50% {
        background-position: 50% 100%;
        filter: hue-rotate(20deg) saturate(1);
    }
    62.5% {
        background-position: 25% 75%;
        filter: hue-rotate(15deg) saturate(1.1);
    }
    75% {
        background-position: 0% 50%;
        filter: hue-rotate(10deg) saturate(1.2);
    }
    87.5% {
        background-position: 75% 25%;
        filter: hue-rotate(5deg) saturate(1.1);
    }
    100% {
        background-position: 0% 50%;
        filter: hue-rotate(0deg) saturate(1);
    }
}


</style>
<link rel="stylesheet" type="text/css" href="Login.css">
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
