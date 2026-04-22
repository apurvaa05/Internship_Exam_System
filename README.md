# Integrated Internship & Online Examination Management System

A full-scale enterprise web application designed to manage the complete student lifecycle — from training to internship placement and certification exams.

---

## 🚀 Project Overview

This system provides a centralized platform for managing:

- Student Registration & Authentication  
- Training Module Completion  
- Internship Applications & Selection  
- Secure Online Examination with Proctoring  
- Result Evaluation & Certificate Generation  
- Reports and Analytics Dashboard  

Built using **Java Servlets, JSP, JDBC, and MySQL**, following the **MVC architecture**.

---

## 🧩 Features

### 👤 Student Module
- Register and Login  
- Complete Training Modules  
- Browse Internships (CGPA-based filtering)  
- Apply for Internships  
- Track Application Status  
- Attempt Online Exam  
- View Results  
- Download Certificate  

---

### 🏢 Admin Module
- Manage Users  
- Manage Companies and Internships  
- Shortlist / Select Students  
- Manage Exams and Questions  
- Evaluate Results  
- Generate Reports  
- View Audit Logs  

---

### 🏢 Company Module
- Post Internships  
- View Applications  
- Shortlist Candidates  

---

## 📝 Online Examination System

- Timed Exam  
- MCQ + Subjective Questions  
- Next / Previous Navigation  
- Auto Submission (Timer + Tab Switch)  
- Tab Switching Detection (Anti-Cheating)  
- Session Management  

---

## 🔐 Security Features

- Role-Based Access Control (AuthFilter)  
- Session Handling using HttpSession  
- Tab Switch Detection  
- Audit Logging  
- Prevention of Duplicate Applications  
- Prevention of Multiple Exam Attempts  

---

## 📊 Reports & Analytics

- Students Selected per Company  
- Internship-wise Application Count  
- Exam Rank List  
- Question-wise Performance Analysis  
- Suspicious Activity Logs  

---

## 🏗️ Tech Stack

Frontend:
- JSP
- HTML
- CSS

Backend:
- Java Servlets

Database:
- MySQL

Connectivity:
- JDBC

Server:
- Apache Tomcat  

---

## 📂 Project Structure

project-root/

├── controller/        (Servlets - Business Logic)  
├── dao/               (Database Operations)  
├── util/              (DBConnection, AuditLogger)  
├── webapp/  
│   ├── *.jsp          (Frontend Pages)  
│   ├── css/           (Styles)  
│   ├── js/            (Scripts)  
└── database/  
    └── schema.sql     (Database Schema)  

---

## ⚙️ Setup Instructions

1. Clone the repository  
   git clone https://github.com/your-username/your-repo-name.git  

2. Import into IDE (Eclipse / IntelliJ)

3. Configure Apache Tomcat Server  

4. Setup MySQL Database  
   - Create a database  
   - Run schema.sql  

5. Update database credentials in  
   DBConnection.java  

6. Run the project on Tomcat Server  

---

## 📸 Screenshots


### 📝 Create Account
![Create Account](images/create_acc.png)

---

### 🔐 Login Page
![Login](images/login.png)

---

### 📊 Student Dashboard
![Dashboard](images/dashboard.png)

---

### 🏢 Browse Internships
![Internships](images/internships.png)

---

### 📄 Applications
![Applications](images/applications.png)

---

### 🧪 Online Exam
![Exam](images/exam.png)

---

### 🏆 Certificate
![Certificate](images/certificate.png)

---

### 🛠️ Admin Dashboard
![Admin Dashboard](images/admin_dashboard.png) 

---

### 📈 Reports Dashboard
![Reports](images/reports.png)

![Reports 1](images/reports1.png)

![Reports 2](images/reports2.png)



## 🧠 System Architecture

- MVC Architecture  
- Servlets as Controller Layer  
- JSP as View Layer  
- JDBC as DAO Layer  
- Transaction Management using commit() and rollback()  

---

## 📌 Key Highlights

- Complete Student Lifecycle Automation  
- Secure Online Exam with Proctoring  
- Real-Time Reporting and Analytics  
- Enterprise-Level Design using Servlets  

---

## 📈 Future Enhancements

- AI-based Proctoring  
- Mobile Application  
- Cloud Deployment (AWS)  
- Advanced Analytics Dashboard  

---

## 👩‍💻 Author

Apurva Dighe  

---

## 📜 License

This project is developed for academic purposes.
