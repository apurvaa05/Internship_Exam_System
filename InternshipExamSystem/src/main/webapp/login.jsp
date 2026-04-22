<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<title>Login</title>

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
.bg {
    position: fixed;
    width: 100%;
    height: 100%;
    background: url("https://images.unsplash.com/photo-1519389950473-47ba0277781c") no-repeat center/cover;
    filter: blur(12px) brightness(0.5);
    transform: scale(1.1);
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
    width: 350px;
    padding: 40px;
    border-radius: 20px;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(25px);
    box-shadow: 0 20px 60px rgba(0,0,0,0.4);
    text-align: center;
    color: white;
}

h2 {
    margin-bottom: 20px;
}

/* 🔥 INPUT (CLEAN GLASS STYLE) */
input, select {
    width: 100%;
    padding: 12px;
    margin: 10px 0;

    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.2);

    outline: none;
    font-size: 14px;

    background: rgba(255,255,255,0.08);
    color: white;
}

/* PLACEHOLDER */
input::placeholder {
    color: #bbb;
}

/* SELECT */
select {
    color: #ccc;
}

select option {
    color: black;
}

/* 🔥🔥 FINAL AUTOFILL FIX (STRONG + STABLE) */
input:-webkit-autofill {
    -webkit-text-fill-color: white !important;
    transition: background-color 9999s ease-in-out 0s;
}

input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 1000px rgba(255,255,255,0.08) inset !important;
    box-shadow: 0 0 0 1000px rgba(255,255,255,0.08) inset !important;
}

/* BUTTON */
button {
    width: 100%;
    padding: 12px;
    margin-top: 10px;
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
    font-size: 14px;
    margin-bottom: 10px;
}

.error {
    color: #ff6b6b;
}

.success {
    color: #2ecc71;
}

</style>
</head>

<body>

<div class="bg"></div>

<div class="container">
    <div class="card">

        <h2>Login</h2>

        <!-- SUCCESS -->
        <%
        String msg = request.getParameter("msg");
        if("registered".equals(msg)){
        %>
            <div class="msg success">Registration successful! Please login.</div>
        <%
        }
        %>

        <!-- ERROR -->
        <%
        String error = request.getParameter("error");
        if("invalid".equals(error)){
        %>
            <div class="msg error">Invalid email or password</div>
        <%
        } else if("wrongrole".equals(error)){
        %>
            <div class="msg error">Selected role does not match account</div>
        <%
        }
        %>

        <!-- FORM -->
        <form action="login" method="post">

            <input type="email" name="email" placeholder="Email" required>

            <input type="password" name="password" placeholder="Password" required>

            <select name="role" required>
                <option value="">Select Role</option>
                <option value="STUDENT">Student</option>
                <option value="ADMIN">Admin</option>
            </select>

            <button type="submit">Login</button>

        </form>

        <a href="register.jsp" class="link">Create new account</a>

    </div>
</div>

</body>
</html>