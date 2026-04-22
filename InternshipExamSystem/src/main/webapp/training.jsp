<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if(userId == null){
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

Connection con = DBConnection.getConnection();

// GET student_id
PreparedStatement ps1 = con.prepareStatement("SELECT student_id FROM students WHERE user_id=?");
ps1.setInt(1, userId);
ResultSet rs1 = ps1.executeQuery();

int studentId = 0;
if(rs1.next()){
    studentId = rs1.getInt("student_id");
}

// FETCH MODULES
PreparedStatement ps = con.prepareStatement("SELECT * FROM training WHERE student_id=?");
ps.setInt(1, studentId);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Training</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI'; }

body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background: url("https://images.unsplash.com/photo-1519389950473-47ba0277781c") no-repeat center/cover;
    filter: blur(12px) brightness(0.5);
    z-index: -1;
}

.sidebar {
    position: fixed;
    width: 220px;
    height: 100%;
    background: rgba(0,0,0,0.75);
    padding: 20px;
}

.sidebar h2 { color: white; margin-bottom: 30px; }

.sidebar a {
    display: block;
    color: white;
    text-decoration: none;
    padding: 12px;
    border-radius: 10px;
    margin-bottom: 10px;
}

.sidebar a:hover, .sidebar a.active {
    background: rgba(255,255,255,0.2);
}

.container {
    margin-left: 260px;
    padding: 40px;
}

.glass {
    max-width: 700px;
    margin: auto;
    background: rgba(255,255,255,0.08);
    padding: 30px;
    border-radius: 20px;
}

h1 {
    text-align: center;
    color: white;
    margin-bottom: 25px;
}

.module {
    margin-bottom: 15px;
    padding: 15px;
    border-radius: 12px;
    background: rgba(255,255,255,0.05);
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.status {
    font-weight: bold;
}

.pending { color: orange; }
.completed { color: lightgreen; }

button {
    padding: 8px 12px;
    border-radius: 8px;
    border: none;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    cursor: pointer;
}
</style>

</head>

<body>

<div class="sidebar">
    <h2>Student</h2>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="training.jsp" class="active">Training</a>
    <a href="internships.jsp">Browse Internships</a>
    <a href="applications.jsp">My Applications</a>
    <a href="exam.jsp">Exam / Test</a>
    <a href="logout">Logout</a>
</div>

<div class="container">
<div class="glass">

<h1>Training Modules</h1>

<%
while(rs.next()){
    String status = rs.getString("status");
%>

<div class="module">

    <div>
        <strong><%= rs.getString("module_name") %></strong><br>
        <span class="status <%= status.equals("COMPLETED") ? "completed" : "pending" %>">
            <%= status %>
        </span>
    </div>

    <div>
    <% if("PENDING".equals(status)) { %>
        <form action="completeTraining" method="post">
            <input type="hidden" name="training_id" value="<%= rs.getInt("training_id") %>">
            <button type="submit">Mark Complete</button>
        </form>
    <% } else { %>
        Done
    <% } %>
    </div>

</div>

<%
}
%>

</div>
</div>

</body>
</html>

<%
con.close();
%>