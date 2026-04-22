<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");
String name = (String) session.getAttribute("user");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = DBConnection.getConnection();

// 📊 Stats
PreparedStatement ps1 = conn.prepareStatement(
    "SELECT COUNT(*) FROM applications WHERE student_id=?"
);
ps1.setInt(1, userId);
ResultSet r1 = ps1.executeQuery();
r1.next();

PreparedStatement ps2 = conn.prepareStatement(
    "SELECT COUNT(*) FROM applications WHERE student_id=? AND status='Approved'"
);
ps2.setInt(1, userId);
ResultSet r2 = ps2.executeQuery();
r2.next();

PreparedStatement ps3 = conn.prepareStatement(
    "SELECT COUNT(*) FROM applications WHERE student_id=? AND status='Pending'"
);
ps3.setInt(1, userId);
ResultSet r3 = ps3.executeQuery();
r3.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<style>

/* 🌌 BODY */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    overflow-x: hidden;
}

/* 🔥 BLURRED BACKGROUND */
.bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: url('https://images.unsplash.com/photo-1519389950473-47ba0277781c') no-repeat center center;
    background-size: cover;
    filter: blur(14px) brightness(0.6);
    z-index: -2;
}

/* OVERLAY */
.overlay {
    position: fixed;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.45);
    z-index: -1;
}

/* ✅ SIDEBAR (ADDED) */
.sidebar {
    position: fixed;
    width: 220px;
    height: 100%;
    background: rgba(0,0,0,0.7);
    backdrop-filter: blur(15px);
    padding: 20px;
}

.sidebar h2 {
    color: white;
    margin-bottom: 30px;
}

.sidebar a {
    display: block;
    color: white;
    text-decoration: none;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 10px;
    transition: 0.3s;
}

.sidebar a:hover {
    background: rgba(255,255,255,0.2);
}

/* 📦 MAIN CONTAINER */
.container {
    text-align: center;
    padding-top: 60px;
    margin-left: 240px; /* ✅ ADDED to adjust for sidebar */
    animation: fadeIn 1s ease;
}

/* 👋 TITLE */
h1 {
    color: white;
    font-size: 34px;
    margin-bottom: 30px;
}

/* 📊 STATS GRID */
.stats {
    display: flex;
    justify-content: center;
    gap: 25px;
    margin-bottom: 40px;
    flex-wrap: wrap;
}

/* 💎 STAT CARD */
.card {
    width: 180px;
    padding: 25px;
    border-radius: 20px;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(20px);
    color: white;
    box-shadow: 0 15px 40px rgba(0,0,0,0.4);
    transition: 0.3s;
}

.card:hover {
    transform: translateY(-8px) scale(1.05);
}

/* 🔢 NUMBERS */
.card b {
    font-size: 26px;
}

/* 🎯 BUTTON GRID */
.actions {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
}

/* 💼 ACTION BUTTON */
.action-btn {
    padding: 14px 25px;
    border-radius: 12px;
    border: none;
    font-size: 15px;
    cursor: pointer;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    transition: 0.3s;
}

.action-btn:hover {
    transform: scale(1.08);
}

/* 🚪 LOGOUT */
.logout {
    position: absolute;
    top: 20px;
    right: 30px;
}

.logout button {
    padding: 10px 18px;
    border-radius: 10px;
    border: none;
    background: red;
    color: white;
    cursor: pointer;
}

/* ✨ ANIMATION */
@keyframes fadeIn {
    from {opacity: 0; transform: translateY(30px);}
    to {opacity: 1; transform: translateY(0);}
}

</style>
</head>

<body>

<div class="bg"></div>
<div class="overlay"></div>

<!-- ✅ SIDEBAR (ADDED) -->
<div class="sidebar">
    <h2>Student</h2>
    <a href="dashboard.jsp"class="active">Dashboard</a>
    <a href="training.jsp">Training</a> <!-- ✅ ADDED -->
    <a href="internships.jsp">Browse Internships</a>
    <a href="applications.jsp">My Applications</a>
    <a href="exam.jsp" >Exam / Test</a>
    <a href="logout">Logout</a>
</div>

<!-- 🚪 LOGOUT -->
<div class="logout">
    <form action="logout">
        <button>Logout</button>
    </form>
</div>

<div class="container">

<h1>Welcome, <%= name %></h1>

<!-- 📊 STATS -->
<div class="stats">
    <div class="card">
        Total Applications<br><br>
        <b><%= r1.getInt(1) %></b>
    </div>

    <div class="card">
        Approved<br><br>
        <b><%= r2.getInt(1) %></b>
    </div>

    <div class="card">
        Pending<br><br>
        <b><%= r3.getInt(1) %></b>
    </div>
</div>

<!-- 🎯 ACTIONS -->
<div class="actions">

    <form action="internships.jsp">
        <button class="action-btn">Browse Internships</button>
    </form>

    <form action="applications.jsp">
        <button class="action-btn">My Applications</button>
    </form>

    <!-- ✅ EXAM BUTTON ADDED -->
    <form action="exam.jsp">
        <button class="action-btn">Take Exam</button>
    </form>

</div>

</div>

</body>
</html>

<%
conn.close();
%>