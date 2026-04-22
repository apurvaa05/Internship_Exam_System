<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn.prepareStatement(
    "SELECT a.status, i.role, c.company_name " +
    "FROM applications a " +
    "JOIN internships i ON a.internship_id = i.internship_id " +
    "JOIN companies c ON i.company_id = c.company_id " +
    "WHERE a.student_id=?"
);

ps.setInt(1, userId);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>My Applications</title>

<style>

/* RESET */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI';
}

body {
    min-height: 100vh;
    overflow-x: hidden;
}

/* BACKGROUND */
body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background: url("https://images.unsplash.com/photo-1519389950473-47ba0277781c") no-repeat center/cover;
    filter: blur(12px) brightness(0.5);
    z-index: -1;
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    width: 220px;
    height: 100%;
    background: rgba(0,0,0,0.75);
    backdrop-filter: blur(20px);
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
    border-radius: 10px;
    margin-bottom: 10px;
    transition: 0.3s;
}

.sidebar a:hover,
.sidebar a.active {
    background: rgba(255,255,255,0.2);
}

/* MAIN */
.container {
    margin-left: 260px;
    padding: 40px;
}

/* GLASS CARD */
.glass {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(25px);
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.5);
}

/* TITLE */
h1 {
    text-align: center;
    color: white;
    margin-bottom: 30px;
}

/* ROW CARD */
.application-card {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 30px;

    background: rgba(255,255,255,0.08);
    padding: 20px 25px;
    border-radius: 15px;
    margin-bottom: 20px;

    box-shadow: 0 6px 20px rgba(0,0,0,0.4);
    transition: 0.3s;
}

.application-card:hover {
    transform: translateY(-4px);
}

/* LEFT INFO */
.info {
    display: flex;
    gap: 40px;
}

/* EACH FIELD */
.field {
    display: flex;
    flex-direction: column;
    gap: 5px;
    color: white;
    font-size: 14px;
}

.label {
    font-size: 12px;
    color: #aaa;
}

/* STATUS */
.status {
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-align: center;
}

.pending { background: #f1c40f; color: black; }
.approved { background: #2ecc71; color: white; }
.rejected { background: #e74c3c; color: white; }

/* EMPTY */
.empty {
    text-align: center;
    color: #ccc;
    padding: 20px;
}

/* BUTTON */
.back-btn {
    display: block;
    margin: 30px auto 0;
    padding: 12px 25px;
    border-radius: 10px;
    border: none;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    cursor: pointer;
}

.back-btn:hover {
    transform: scale(1.05);
}

</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Student</h2>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="training.jsp">Training</a> <!-- ✅ ADDED -->
    <a href="internships.jsp">Browse Internships</a>
    <a href="applications.jsp"class="active">My Applications</a>
    <a href="exam.jsp" >Exam / Test</a>
    <a href="logout">Logout</a>
</div>

<!-- MAIN -->
<div class="container">

<div class="glass">

<h1>My Applications</h1>

<%
boolean hasData = false;

while(rs.next()){
    hasData = true;
    String status = rs.getString("status");
%>

<div class="application-card">

    <div class="info">

        <div class="field">
            <div class="label">Role</div>
            <div><%= rs.getString("role") %></div>
        </div>

        <div class="field">
            <div class="label">Company</div>
            <div><%= rs.getString("company_name") %></div>
        </div>

    </div>

    <div class="status 
        <%= status.equals("Approved") ? "approved" :
            status.equals("Rejected") ? "rejected" : "pending" %>">
        <%= status %>
    </div>

</div>

<%
}

if(!hasData){
%>

<div class="empty">No applications found</div>

<%
}
%>

<a href="dashboard.jsp">
    <button class="back-btn">Back to Dashboard</button>
</a>

</div>

</div>

</body>
</html>

<%
conn.close();
%>