<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<title>Register</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI';
}

html, body {
    height: 100%;
    overflow: hidden;
}

/* BACKGROUND */
body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background: url('https://images.unsplash.com/photo-1519389950473-47ba0277781c') no-repeat center/cover;
    filter: blur(14px) brightness(0.6);
    z-index: -1;
}

/* CENTER */
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
}

/* CARD */
.card {
    width: 900px;
    padding: 40px;
    border-radius: 20px;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(25px);
    box-shadow: 0 20px 60px rgba(0,0,0,0.4);
    text-align: center;
    color: white;
    animation: fadeUp 1s ease;
}

/* ANIMATION */
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(40px); }
    to { opacity: 1; transform: translateY(0); }
}

h2 {
    margin-bottom: 30px;
    font-size: 28px;
}

/* GRID */
.form-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
}

/* 🔥 INPUT FIX (NO WHITE) */
input {
    padding: 12px;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.2);

    background: rgba(255,255,255,0.08);
    color: white;

    outline: none;
    font-size: 14px;
}

/* PLACEHOLDER */
input::placeholder {
    color: rgba(255,255,255,0.7);
}

/* FOCUS EFFECT */
input:focus {
    border: 1px solid rgba(91,134,229,0.8);
    box-shadow: 0 0 8px rgba(91,134,229,0.4);
}

/* 🔥 AUTOFILL FIX (IMPORTANT) */
input:-webkit-autofill {
    -webkit-text-fill-color: white !important;
    -webkit-box-shadow: 0 0 0 1000px rgba(255,255,255,0.08) inset !important;
    transition: background-color 9999s ease-in-out 0s;
}

/* BUTTON */
button {
    margin-top: 25px;
    padding: 12px 30px;
    border-radius: 10px;
    border: none;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    font-size: 16px;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    transform: scale(1.05);
}

/* LINK */
.link {
    margin-top: 15px;
    display: block;
    color: #bbb;
    text-decoration: none;
}

.link:hover {
    color: white;
}

/* MESSAGE */
.msg {
    margin-bottom: 15px;
    font-size: 14px;
}

.error {
    color: #ff6b6b;
}

</style>
</head>

<body>

<div class="container">

    <div class="card">

        <h2>Create Account</h2>

        <!-- ERROR -->
        <%
        String error = request.getParameter("error");
        if(error != null){
        %>
            <div class="msg error"><%= error %></div>
        <%
        }
        %>

        <!-- FORM -->
        <form action="register" method="post">

            <div class="form-grid">

                <input type="text" name="name" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>

                <input type="text" name="course" placeholder="Course" required>
                <input type="number" step="0.01" name="cgpa" placeholder="CGPA" required>
                <input type="text" name="phone" placeholder="Phone Number" required>

            </div>

            <button type="submit">Register</button>

        </form>

        <a href="login.jsp" class="link">
            Already have an account? Login
        </a>

    </div>

</div>

</body>
</html>