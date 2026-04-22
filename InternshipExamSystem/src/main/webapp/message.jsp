<!DOCTYPE html>
<html>
<head>
    <title>Message</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            height: 100vh;
            position: relative;
            overflow: hidden;
        }

        /* BACKGROUND */
        body::before {
            content: "";
            position: fixed;
            width: 100%;
            height: 100%;
            background: url("https://images.unsplash.com/photo-1519389950473-47ba0277781c") no-repeat center/cover;
            filter: blur(14px) brightness(0.6);
            z-index: -2;
        }

        /* OVERLAY */
        body::after {
            content: "";
            position: fixed;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
            z-index: -1;
        }

        /* SIDEBAR */
        .sidebar {
            position: fixed;
            width: 220px;
            height: 100%;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(15px);
            padding: 20px;
            z-index: 2;
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

        .sidebar a:hover,
        .sidebar a.active {
            background: rgba(255,255,255,0.2);
        }

        /* MAIN */
        .main {
            margin-left: 240px;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* CARD */
        .card {
            width: 380px;
            padding: 30px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(20px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
            text-align: center;
            animation: fadeIn 0.8s ease;
        }

        h2 {
            color: white;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 20px;
            margin-top: 10px;
            background: linear-gradient(45deg, #4facfe, #00f2fe);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Student</h2>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="internships.jsp">Browse Internships</a>
    <a href="applications.jsp">My Applications</a>
    <a href="exam.jsp">Exam</a>
    <a href="logout">Logout</a>
</div>

<!-- MAIN -->
<div class="main">

<div class="card">

<%
String msg = request.getParameter("msg");
String message = "Done!";
boolean showCertificate = false;

// DEFAULT CASES
if("applied".equals(msg)){
    message = "Application Successful!";
}
else if("already_applied".equals(msg)){
    message = "You have already applied for this internship.";
}
else if("deadline_passed".equals(msg)){
    message = "Sorry, the deadline has passed.";
}
else if("not_eligible".equals(msg)){
    message = "You are not eligible due to low CGPA.";
}

// ✅ EXAM RESULT CASE
else if("exam_submitted".equals(msg)){
    message = (String) session.getAttribute("exam_message");

    if(message != null && message.contains("PASS")){
        showCertificate = true;
    }
}

// ✅ CHEATING CASE (forwarded)
else if(request.getAttribute("message") != null){
    message = (String) request.getAttribute("message");
}
%>

<h2><%= message %></h2>

<% if(showCertificate){ %>

    <!-- CERTIFICATE BUTTON -->
    <a href="certificate">
        <button class="btn">View Certificate</button>
    </a>

<% } else if("exam_submitted".equals(msg)) { %>

    <!-- FAIL CASE -->
    <a href="dashboard.jsp">
        <button class="btn">Go to Dashboard</button>
    </a>

<% } else { %>

    <!-- DEFAULT -->
    <a href="internships.jsp">
        <button class="btn">Back to Internships</button>
    </a>

<% } %>

</div>

</div>

</body>
</html>