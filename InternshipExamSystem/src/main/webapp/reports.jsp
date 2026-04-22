<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = DBConnection.getConnection();
%>

<!DOCTYPE html>
<html>
<head>
<title>Reports Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

/* RESET */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI';
    overflow-x: hidden;
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
}

.sidebar a:hover,
.sidebar a.active {
    background: rgba(255,255,255,0.2);
}

/* MAIN */
.main {
    margin-left: 240px;
    padding: 40px;
}

/* SECTION */
.section {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(25px);
    padding: 30px;
    border-radius: 20px;
    margin-bottom: 30px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.4);
}

/* HEADINGS */
h1, h2 {
    color: white;
    margin-bottom: 20px;
}

/* TABLE */
table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 18px;
}

th {
    background: rgba(255,255,255,0.15);
    padding: 14px;
    border-radius: 12px;
    color: white;
}

td {
    background: rgba(255,255,255,0.08);
    padding: 16px;
    border-radius: 14px;
    text-align: center;
    color: white;
}

tr:hover td {
    transform: translateY(-4px);
    background: rgba(255,255,255,0.12);
}

</style>

</head>

<body>

<div class="sidebar">
    <h2>Admin</h2>
    <a href="admin.jsp">Dashboard</a>
    <a href="reports.jsp" class="active">Reports</a>
    <a href="logout">Logout</a>
</div>

<div class="main">

<h1>Reports Dashboard</h1>

<!-- REPORT 1 -->
<div class="section">
<h2>Students Selected Per Company</h2>

<table>
<tr>
<th>Company</th>
<th>Selected Students</th>
</tr>

<%
PreparedStatement ps1 = con.prepareStatement(
    "SELECT c.company_name, COUNT(a.application_id) AS total " +
    "FROM companies c " +
    "JOIN internships i ON c.company_id = i.company_id " +
    "JOIN applications a ON i.internship_id = a.internship_id " +
    "WHERE a.status = 'SELECTED' " +
    "GROUP BY c.company_name"
);

ResultSet rs1 = ps1.executeQuery();

while(rs1.next()){
%>
<tr>
<td><%= rs1.getString("company_name") %></td>
<td><%= rs1.getInt("total") %></td>
</tr>
<%
}
%>
</table>
</div>

<!-- REPORT 2 -->
<div class="section">
<h2>Internship-wise Application Count</h2>

<table>
<tr>
<th>Role</th>
<th>Total Applications</th>
</tr>

<%
PreparedStatement ps2 = con.prepareStatement(
    "SELECT i.role, COUNT(a.application_id) AS total " +
    "FROM internships i " +
    "LEFT JOIN applications a ON i.internship_id = a.internship_id " +
    "GROUP BY i.role"
);

ResultSet rs2 = ps2.executeQuery();

String roles = "";
String counts = "";

while(rs2.next()){
    roles += "'" + rs2.getString("role") + "',";
    counts += rs2.getInt("total") + ",";
%>
<tr>
<td><%= rs2.getString("role") %></td>
<td><%= rs2.getInt("total") %></td>
</tr>
<%
}
%>
</table>
</div>

<!-- CHART -->
<div class="section">
<h2>Application Analytics</h2>
<canvas id="appChart"></canvas>
</div>

<!-- REPORT 3 -->
<div class="section">
<h2>Exam Rank List</h2>

<table>
<tr>
<th>Student ID</th>
<th>Exam ID</th>
<th>Score</th>
</tr>

<%
PreparedStatement ps3 = con.prepareStatement(
    "SELECT student_id, exam_id, score FROM exam_attempts ORDER BY score DESC"
);

ResultSet rs3 = ps3.executeQuery();

while(rs3.next()){
%>
<tr>
<td><%= rs3.getInt("student_id") %></td>
<td><%= rs3.getInt("exam_id") %></td>
<td><%= rs3.getInt("score") %></td>
</tr>
<%
}
%>
</table>
</div>

<!-- ✅ REPORT 4 (NEW) -->
<div class="section">
<h2>Question-wise Performance Analysis</h2>

<table>
<tr>
<th>Question ID</th>
<th>Average Score</th>
<th>Total Attempts</th>
</tr>

<%
PreparedStatement ps4 = con.prepareStatement(
    "SELECT question_id, AVG(marks_awarded) AS avg_score, COUNT(*) AS attempts FROM answers GROUP BY question_id"
);

ResultSet rs4 = ps4.executeQuery();

while(rs4.next()){
%>
<tr>
<td><%= rs4.getInt("question_id") %></td>
<td><%= String.format("%.2f", rs4.getDouble("avg_score")) %></td>
<td><%= rs4.getInt("attempts") %></td>
</tr>
<%
}
%>
</table>
</div>

</div>

<script>
const ctx = document.getElementById('appChart').getContext('2d');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [<%= roles %>],
        datasets: [{
            label: 'Applications',
            data: [<%= counts %>],
            borderWidth: 1
        }]
    },
    options: {
        plugins: {
            legend: { labels: { color: "white" } }
        },
        scales: {
            x: { ticks: { color: "white" } },
            y: { ticks: { color: "white" } }
        }
    }
});
</script>

</body>
</html>

<%
con.close();
%>