<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

Connection con = DBConnection.getConnection();

// GET exam_id
PreparedStatement psExam = con.prepareStatement("SELECT exam_id FROM exams LIMIT 1");
ResultSet rsExam = psExam.executeQuery();

int examId = 0;
if(rsExam.next()){
    examId = rsExam.getInt("exam_id");
} else {
%>
<html>
<body style="background:black; color:white; text-align:center; margin-top:100px;">
    <h1>No exam available</h1>
</body>
</html>
<%
    return;
}

// GET QUESTIONS
PreparedStatement psQ = con.prepareStatement(
    "SELECT question_id, question_text FROM questions WHERE exam_id=? LIMIT 3"
);
psQ.setInt(1, examId);
ResultSet rsQ = psQ.executeQuery();

int qid1=0, qid2=0, qid3=0;
String q1="", q2="", q3="";

if(rsQ.next()){ qid1 = rsQ.getInt("question_id"); q1 = rsQ.getString("question_text"); }
if(rsQ.next()){ qid2 = rsQ.getInt("question_id"); q2 = rsQ.getString("question_text"); }
if(rsQ.next()){ qid3 = rsQ.getInt("question_id"); q3 = rsQ.getString("question_text"); }
%>

<!DOCTYPE html>
<html>
<head>
<title>Exam</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', sans-serif;
}

body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background: url("https://images.unsplash.com/photo-1519389950473-47ba0277781c") no-repeat center/cover;
    filter: blur(14px) brightness(0.5);
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
    padding: 50px;
}

/* GLASS CARD */
.glass {
    max-width: 700px;
    margin: auto;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(30px);
    padding: 40px;
    border-radius: 24px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.5);
}

/* TITLE */
h1 {
    text-align: center;
    color: white;
    margin-bottom: 30px;
    font-size: 28px;
}

/* QUESTION */
.question {
    display: none;
    margin-bottom: 25px;
    padding: 20px;
    border-radius: 16px;
    background: rgba(255,255,255,0.05);
    color: white;
    transition: 0.3s;
}

.active {
    display: block;
}

/* OPTIONS */
label {
    display: block;
    margin: 10px 0;
    cursor: pointer;
    font-size: 15px;
}

/* RADIO */
input[type="radio"] {
    margin-right: 8px;
    transform: scale(1.1);
}

/* TEXTAREA (🔥 FIXED PREMIUM LOOK) */
textarea {
    width: 100%;
    margin-top: 12px;
    padding: 12px;
    border-radius: 10px;
    border: none;
    outline: none;
    resize: none;
    background: rgba(255,255,255,0.15);
    color: white;
    font-size: 14px;
}

textarea::placeholder {
    color: rgba(255,255,255,0.6);
}

/* BUTTON ROW */
.btn-row {
    display: flex;
    gap: 10px;
    margin-top: 20px;
}

/* BUTTONS */
button {
    flex: 1;
    padding: 14px;
    border-radius: 12px;
    border: none;
    background: linear-gradient(135deg, #36d1dc, #5b86e5);
    color: white;
    font-size: 15px;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.3);
}

/* SUBMIT BUTTON */
.submit-btn {
    margin-top: 20px;
    width: 100%;
    background: linear-gradient(135deg, #00c9ff, #92fe9d);
}

/* TIMER */
.timer {
    position: fixed;
    top: 20px;
    right: 30px;
    color: #ff4d4d;
    font-weight: bold;
    font-size: 16px;
}
</style>

<script>
let timeLeft = 300;
let isSubmitting = false;
let isNavigating = false;
let currentQ = 0;

// TIMER
function startTimer() {
    let timer = setInterval(function() {

        let m = Math.floor(timeLeft / 60);
        let s = timeLeft % 60;

        document.getElementById("timer").innerHTML =
            m + ":" + (s < 10 ? "0" : "") + s;

        timeLeft--;

        if (timeLeft < 0) {
            clearInterval(timer);
            alert("Time is up! Submitting exam...");
            submitExam();
        }
    }, 1000);
}

// NAVIGATION
function showQ(i){
    document.querySelectorAll(".question").forEach(q => q.classList.remove("active"));
    document.getElementById("q"+i).classList.add("active");
    currentQ = i;
    localStorage.setItem("currentQ", i);
}

function nextQ(){ if(currentQ < 2) showQ(currentQ+1); }
function prevQ(){ if(currentQ > 0) showQ(currentQ-1); }

// SAFE SUBMIT
function submitExam() {
    if (!isSubmitting) {
        isSubmitting = true;
        document.getElementById("examForm").submit();
    }
}

// ON LOAD
window.onload = function () {
    startTimer();

    let saved = localStorage.getItem("currentQ");
    if(saved) currentQ = parseInt(saved);

    showQ(currentQ);

    document.getElementById("examForm").addEventListener("submit", function () {
        isSubmitting = true;
    });

    document.querySelectorAll("a").forEach(link => {
        link.addEventListener("click", function () {
            isNavigating = true;
        });
    });
};

// TAB SWITCH
document.addEventListener("visibilitychange", function () {
    if (document.hidden && !isSubmitting && !isNavigating) {
        document.getElementById("cheated").value = "true";
        alert("Warning: Tab switching detected!");
    }
});

// AUTO SUBMIT
window.addEventListener("beforeunload", function (e) {
    if (!isSubmitting) {
        document.getElementById("cheated").value = "true";

        navigator.sendBeacon(
            document.getElementById("examForm").action,
            new FormData(document.getElementById("examForm"))
        );

        e.preventDefault();
        e.returnValue = '';
    }
});

// DISABLE RIGHT CLICK
document.addEventListener("contextmenu", e => e.preventDefault());

// DISABLE BACK BUTTON
history.pushState(null, null, location.href);
window.onpopstate = function () {
    history.go(1);
};
</script>

</head>

<body>

<div class="sidebar">
    <h2>Student</h2>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="training.jsp">Training</a>
    <a href="internships.jsp">Browse Internships</a>
    <a href="applications.jsp">My Applications</a>
    <a href="exam.jsp" class="active">Exam / Test</a>
    <a href="logout">Logout</a>
</div>

<div class="timer">Time Left: <span id="timer">5:00</span></div>

<div class="container">
<div class="glass">

<h1>Online Exam</h1>

<form id="examForm" action="<%= request.getContextPath() %>/submitExam" method="post">

<input type="hidden" name="exam_id" value="<%= examId %>">
<input type="hidden" name="total" value="3">
<input type="hidden" name="cheated" id="cheated" value="false">

<div id="q0" class="question">
<p><%= q1 %></p>
<label><input type="radio" name="q1" value="1"> Language</label>
<label><input type="radio" name="q1" value="2"> Animal</label>
<textarea name="subj1" placeholder="Optional subjective answer"></textarea>
<input type="hidden" name="qid1" value="<%= qid1 %>">
</div>

<div id="q1" class="question">
<p><%= q2 %></p>
<label><input type="radio" name="q2" value="3"> HyperText Markup Language</label>
<label><input type="radio" name="q2" value="4"> HighText Machine Language</label>
<textarea name="subj2"></textarea>
<input type="hidden" name="qid2" value="<%= qid2 %>">
</div>

<div id="q2" class="question">
<p><%= q3 %></p>
<label><input type="radio" name="q3" value="5"> Styling</label>
<label><input type="radio" name="q3" value="6"> Cooking</label>
<textarea name="subj3"></textarea>
<input type="hidden" name="qid3" value="<%= qid3 %>">
</div>

<button type="button" class="nav-btn" onclick="prevQ()">Previous</button>
<button type="button" class="nav-btn" onclick="nextQ()">Next</button>

<br><br>

<button type="submit">Submit Exam</button>

</form>

</div>
</div>

</body>
</html>

<%
con.close();
%>