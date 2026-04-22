<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn.prepareStatement(
"SELECT a.application_id, u.name, i.role, c.company_name, a.status " +
"FROM applications a " +
"JOIN students s ON a.student_id = s.student_id " +
"JOIN users u ON s.user_id = u.user_id " +
"JOIN internships i ON a.internship_id = i.internship_id " +
"JOIN companies c ON i.company_id = c.company_id"
);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Panel</title>

<style>

/* RESET */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI';
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

.sidebar a:hover {
    background: rgba(255,255,255,0.2);
}

/* MAIN */
.main {
    margin-left: 240px;
    padding: 40px;
}

/* GLASS SECTION */
.section {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(25px);
    padding: 30px;
    border-radius: 20px;
    margin-bottom: 30px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.4);
}

h1 {
    color: white;
    margin-bottom: 20px;
}

/* FORM */
.form-row {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

/* INPUT TEXT FIX */
input {
    padding: 12px;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.25);

    background: rgba(255,255,255,0.10);
    color: #ffffff;                /* 🔥 bright text */

    outline: none;
    font-size: 14px;
}

/* PLACEHOLDER FIX */
input::placeholder {
    color: rgba(255,255,255,0.75);   /* 🔥 brighter placeholder */
    font-weight: 500;
}

/* DATE INPUT ICON FIX */
input[type="date"] {
    color: rgba(255,255,255,0.9);
}

/* AUTOFILL FIX (keep this) */
input:-webkit-autofill {
    -webkit-text-fill-color: white !important;
    -webkit-box-shadow: 0 0 0 1000px rgba(255,255,255,0.10) inset !important;
}
input:focus {
    border: 1px solid rgba(91,134,229,0.8);
    box-shadow: 0 0 8px rgba(91,134,229,0.5);
}
/* BUTTON */
.primary-btn {
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    border: none;
    padding: 12px 18px;
    border-radius: 10px;
    color: white;
    cursor: pointer;
}

.primary-btn:hover {
    transform: scale(1.05);
}

/* 🔥 APPLICATION CARDS */
.app-card {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: rgba(255,255,255,0.08);
    padding: 20px;
    border-radius: 18px;
    margin-bottom: 18px;
    backdrop-filter: blur(20px);
    transition: 0.3s;
}

.app-card:hover {
    transform: translateY(-5px);
    background: rgba(255,255,255,0.12);
}

/* LEFT INFO */
.info {
    display: flex;
    flex-direction: column;
    gap: 6px;
    color: white;
}

/* STATUS */
.status {
    font-weight: bold;
}

.approved { color: #00e676; }
.rejected { color: #ff5252; }
.pending { color: #ffca28; }

/* ACTION */
.actions {
    display: flex;
    gap: 10px;
}

/* BUTTONS */
.approve-btn {
    background: #00c853;
    border: none;
    padding: 10px 14px;
    border-radius: 8px;
    color: white;
    cursor: pointer;
}

.reject-btn {
    background: #ff1744;
    border: none;
    padding: 10px 14px;
    border-radius: 8px;
    color: white;
    cursor: pointer;
}

button:hover {
    transform: scale(1.05);
}

</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Admin</h2>
    <a href="#">Dashboard</a>
    <a href="#company">Add Company</a>
    <a href="#internship">Add Internship</a>
    <a href="#applications">Applications</a>
    <a href="reports.jsp">Reports</a>
    <a href="logout">Logout</a>
</div>

<div class="main">

<!-- ADD COMPANY -->
<div class="section" id="company">
<h1>Add Company</h1>

<form action="addCompany" method="post">
<div class="form-row">
<input type="text" name="company_name" placeholder="Company Name" required>
<input type="text" name="location" placeholder="Location" required>
<input type="number" step="0.1" name="cgpa" placeholder="Min CGPA" required>
<button class="primary-btn">Add Company</button>
</div>
</form>

</div>

<!-- ADD INTERNSHIP -->
<div class="section" id="internship">
<h1>Add Internship</h1>

<form action="addInternship" method="post">
<div class="form-row">
<input type="number" name="company_id" placeholder="Company ID" required>
<input type="text" name="role" placeholder="Role" required>
<input type="number" name="stipend" placeholder="Stipend" required>
<input type="date" name="deadline" required>
<button class="primary-btn">Add Internship</button>
</div>
</form>

</div>

<!-- APPLICATIONS -->
<div class="section" id="applications">
<h1>Applications Management</h1>

<%
while(rs.next()){
String status = rs.getString("status");
%>

<div class="app-card">

<div class="info">
    <div><b><%= rs.getString("name") %></b></div>
    <div><%= rs.getString("company_name") %></div>
    <div><%= rs.getString("role") %></div>

    <div class="status 
    <%= status.equals("Approved") ? "approved" :
        status.equals("Rejected") ? "rejected" : "pending" %>">
        <%= status %>
    </div>
</div>

<div class="actions">

<form action="updateStatus" method="post">
<input type="hidden" name="application_id" value="<%= rs.getInt("application_id") %>">
<input type="hidden" name="status" value="Approved">
<button class="approve-btn">Approve</button>
</form>

<form action="updateStatus" method="post">
<input type="hidden" name="application_id" value="<%= rs.getInt("application_id") %>">
<input type="hidden" name="status" value="Rejected">
<button class="reject-btn">Reject</button>
</form>

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
conn.close();
%>