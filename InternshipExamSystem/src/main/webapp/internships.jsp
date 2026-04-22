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
		"SELECT i.internship_id, i.role, i.stipend, i.deadline, c.company_name " +
		"FROM internships i JOIN companies c ON i.company_id = c.company_id"
);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Internships</title>

<style>

/* GLOBAL */
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

/* MAIN CONTAINER */
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

/* TABLE */
table {
    width: 100%;
    border-collapse: collapse; /* 🔥 important */
}

/* REMOVE OLD HEADER STYLE */
th {
    display: none; /* 🔥 hide ugly header row */
}

/* EACH ROW = CARD */
tr {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 30px;
    margin-bottom: 20px;
    padding: 20px 25px;

    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(20px);
    border-radius: 16px;

    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
}
td {
    display: flex;
    flex-direction: column;
    gap: 5px;
    color: white;
    font-size: 14px;
    min-width: 120px;
}

td::before {
    font-size: 12px;
    color: #aaa;
    font-weight: 500;
}

td:nth-child(1)::before { content: "Role"; }
td:nth-child(2)::before { content: "Company"; }
td:nth-child(3)::before { content: "Stipend"; }
td:nth-child(4)::before { content: "Deadline"; }
td:nth-child(5)::before { content: "Apply"; }

td:last-child {
    align-items: flex-end;
    gap: 10px;
}

/* FILE INPUT */
input[type="file"] {
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: white;
    border-radius: 8px;
    padding: 6px;
}

.apply-btn {
    padding: 8px 16px;
    border-radius: 10px;
    font-size: 14px;
}

.apply-btn:hover {
    transform: scale(1.05);
}
/* HOVER */
tr:hover td {
    transform: translateY(-4px);
}

/* APPLY BUTTON */
.apply-btn {
    padding: 10px 18px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    cursor: pointer;
    transition: 0.3s;
}

.apply-btn:hover {
    transform: scale(1.08);
}

/* FILE INPUT */
input[type="file"] {
    padding: 6px;
    border-radius: 6px;
    font-size: 12px;
}

/* LOGOUT */
.logout-btn {
    position: fixed;
    top: 20px;
    right: 30px;
    z-index: 1000;
}

.logout-btn button {
    padding: 10px 18px;
    border-radius: 10px;
    border: none;
    background: linear-gradient(135deg, #ff4b5c, #ff6b6b);
    color: white;
    font-weight: 500;
    cursor: pointer;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    transition: 0.3s;
}

.logout-btn button:hover {
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
    <a href="internships.jsp" class="active">Browse Internships</a>
    <a href="applications.jsp">My Applications</a>
    <a href="exam.jsp"> Exam / Test</a>
    <a href="logout">Logout</a>
</div>

<!-- LOGOUT -->
<div class="logout-btn">
    <form action="logout">
        <button type="submit">Logout</button>
    </form>
</div>

<!-- MAIN -->
<div class="container">

<div class="glass">

<h1>Available Internships</h1>

<table>

<tr>
<th>Role</th>
<th>Company</th>
<th>Stipend</th>
<th>Deadline</th>
<th>Action</th>
</tr>

<%
while(rs.next()){
%>

<tr>
<td><%= rs.getString("role") %></td>
<td><%= rs.getString("company_name") %></td>
<td><%= rs.getDouble("stipend") %></td>
<td><%= rs.getDate("deadline") %></td>

<td>
<form action="apply" method="post" enctype="multipart/form-data">
<input type="hidden" name="internship_id" value="<%= rs.getInt("internship_id") %>">
<input type="file" name="resume" required><br><br>
<button type="submit" class="apply-btn">Apply</button>
</form>
</td>

</tr>

<%
}
%>

</table>

</div>

</div>

</body>
</html>