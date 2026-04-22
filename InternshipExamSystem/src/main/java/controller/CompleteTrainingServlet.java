package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

import util.DBConnection;
import util.AuditLogger;

@WebServlet("/completeTraining")
public class CompleteTrainingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();

            int trainingId = Integer.parseInt(request.getParameter("training_id"));

            // ✅ UPDATE TRAINING STATUS
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE training SET status='COMPLETED' WHERE training_id=?"
            );
            ps.setInt(1, trainingId);
            ps.executeUpdate();

            // ✅ OPTIONAL: CHECK IF ALL TRAINING COMPLETED
            HttpSession session = request.getSession(false);
            int userId = (int) session.getAttribute("user_id");

            PreparedStatement psStudent = conn.prepareStatement(
                "SELECT student_id FROM students WHERE user_id=?"
            );
            psStudent.setInt(1, userId);
            ResultSet rsStudent = psStudent.executeQuery();

            int studentId = 0;
            if(rsStudent.next()){
                studentId = rsStudent.getInt("student_id");
            }

            PreparedStatement checkAll = conn.prepareStatement(
                "SELECT COUNT(*) FROM training WHERE student_id=? AND status='PENDING'"
            );
            checkAll.setInt(1, studentId);
            ResultSet rs = checkAll.executeQuery();

            if(rs.next() && rs.getInt(1) == 0){
                // All modules completed
                AuditLogger.log(request, "Training Completed Fully");
            } else {
                AuditLogger.log(request, "Training Module Completed");
            }

            // ✅ REDIRECT BACK
            response.sendRedirect("training.jsp");

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}