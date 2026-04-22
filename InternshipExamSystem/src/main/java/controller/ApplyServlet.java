package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;
import util.AuditLogger;

@WebServlet("/apply")
@MultipartConfig
public class ApplyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("user_id");

            String internshipParam = request.getParameter("internship_id");

            if (internshipParam == null || internshipParam.isEmpty()) {
                if (con != null) con.rollback(); // ✅ ADDED
                response.getWriter().println("Error: Internship ID missing");
                return;
            }

            int internshipId = Integer.parseInt(internshipParam);

            PreparedStatement psStudent = con.prepareStatement(
                    "SELECT student_id, cgpa FROM students WHERE user_id=?"
            );
            psStudent.setInt(1, userId);
            ResultSet rsStudent = psStudent.executeQuery();

            if (!rsStudent.next()) { // ✅ ADDED SAFETY
                if (con != null) con.rollback();
                response.getWriter().println("Error: Student not found");
                return;
            }

            int studentId = rsStudent.getInt("student_id");
            double studentCgpa = rsStudent.getDouble("cgpa");

            PreparedStatement check = con.prepareStatement(
                    "SELECT * FROM applications WHERE student_id=? AND internship_id=?"
            );
            check.setInt(1, studentId);
            check.setInt(2, internshipId);

            if (check.executeQuery().next()) {
                if (con != null) con.rollback(); // ✅ ADDED
                response.sendRedirect("message.jsp?msg=already_applied");
                return;
            }

            PreparedStatement psDeadline = con.prepareStatement(
                    "SELECT deadline FROM internships WHERE internship_id=?"
            );
            psDeadline.setInt(1, internshipId);
            ResultSet rsDeadline = psDeadline.executeQuery();

            if (!rsDeadline.next()) { // ✅ ADDED SAFETY
                if (con != null) con.rollback();
                response.getWriter().println("Error: Internship not found");
                return;
            }

            if (rsDeadline.getDate("deadline").before(new java.util.Date())) {
                if (con != null) con.rollback(); // ✅ ADDED
                response.sendRedirect("message.jsp?msg=deadline_passed");
                return;
            }

            PreparedStatement psCgpa = con.prepareStatement(
                    "SELECT c.eligibility_cgpa FROM internships i " +
                    "JOIN companies c ON i.company_id=c.company_id " +
                    "WHERE i.internship_id=?"
            );
            psCgpa.setInt(1, internshipId);
            ResultSet rsCgpa = psCgpa.executeQuery();

            if (!rsCgpa.next()) { // ✅ ADDED SAFETY
                if (con != null) con.rollback();
                response.getWriter().println("Error: Eligibility not found");
                return;
            }

            if (studentCgpa < rsCgpa.getDouble("eligibility_cgpa")) {
                if (con != null) con.rollback(); // ✅ ADDED
                response.sendRedirect("message.jsp?msg=not_eligible");
                return;
            }

            PreparedStatement psInsert = con.prepareStatement(
                    "INSERT INTO applications (student_id, internship_id) VALUES (?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );

            psInsert.setInt(1, studentId);
            psInsert.setInt(2, internshipId);
            psInsert.executeUpdate();

            ResultSet rs = psInsert.getGeneratedKeys();
            rs.next();
            int appId = rs.getInt(1);

            PreparedStatement log = con.prepareStatement(
                    "INSERT INTO application_logs (application_id, action) VALUES (?, ?)"
            );
            log.setInt(1, appId);
            log.setString(2, "APPLIED");
            log.executeUpdate();

            con.commit();

            // ✅ AUDIT LOG (WITH IP + DEVICE INFO internally)
            AuditLogger.log(request, "Applied Internship ID: " + internshipId);

            response.sendRedirect("message.jsp?msg=applied");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {}

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}