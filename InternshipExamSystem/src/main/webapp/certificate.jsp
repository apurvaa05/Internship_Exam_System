<%
String name = (String) request.getAttribute("name");
Integer studentId = (Integer) request.getAttribute("studentId");
Integer score = (Integer) request.getAttribute("score");
%>

<!DOCTYPE html>
<html>
<head>
<title>Certificate</title>

<style>
body {
    font-family: 'Segoe UI';
    background: #f5f5f5;
    text-align: center;
}

.certificate {
    margin: 40px auto;
    padding: 40px;
    width: 700px;
    border: 10px solid gold;
    background: white;
    box-shadow: 0 0 20px rgba(0,0,0,0.3);
}

h1 {
    font-size: 36px;
    margin-bottom: 20px;
}

h2 {
    margin: 10px 0;
}

p {
    font-size: 18px;
}

/* BUTTON */
button {
    margin-top: 20px;
    padding: 10px 20px;
    border: none;
    background: #5b86e5;
    color: white;
    border-radius: 8px;
    cursor: pointer;
}
</style>

</head>

<body>

<div class="certificate" id="cert">

    <h1>Certificate of Completion</h1>

    <p>This is to certify that</p>

    <h2><%= name %></h2>

    <p>(Student ID: <%= studentId %>)</p>

    <p>has successfully completed the training and certification exam</p>

    <p><b>Score: <%= score %></b></p>

    <p>Congratulations</p>

</div>

<!-- DOWNLOAD BUTTON -->
<button onclick="downloadCertificate()">Download Certificate</button>

<script>
// ✅ DOWNLOAD AS IMAGE
function downloadCertificate() {
    html2canvas(document.getElementById("cert")).then(canvas => {
        let link = document.createElement('a');
        link.download = 'certificate.png';
        link.href = canvas.toDataURL();
        link.click();
    });
}
</script>

<!-- LIBRARY -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

</body>
</html>