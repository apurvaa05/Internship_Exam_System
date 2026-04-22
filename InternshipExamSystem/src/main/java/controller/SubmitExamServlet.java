package controller;

import util.AuditLogger;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import util.DBConnection;

@WebServlet("/submitExam")
public class SubmitExamServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ ADDED: CHEATING CHECK (DO NOT REMOVE)
        String cheated = request.getParameter("cheated");
        if ("true".equals(cheated)) {
            request.setAttribute("message", "Tab switching detected. You cannot continue the exam.");
            request.getRequestDispatcher("message.jsp").forward(request, response);
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = (int) request.getSession().getAttribute("user_id");

            PreparedStatement psStudent = conn.prepareStatement(
                "SELECT student_id FROM students WHERE user_id=?"
            );
            psStudent.setInt(1, userId);
            ResultSet rsStudent = psStudent.executeQuery();

            int studentId = 0;
            if(rsStudent.next()){
                studentId = rsStudent.getInt("student_id");
            } else {
                conn.rollback();
                response.getWriter().println("Error: Student not found");
                return;
            }

            int examId = Integer.parseInt(request.getParameter("exam_id"));
            int total = Integer.parseInt(request.getParameter("total"));

            PreparedStatement checkAttempt = conn.prepareStatement(
                "SELECT * FROM exam_attempts WHERE student_id=? AND exam_id=?"
            );
            checkAttempt.setInt(1, studentId);
            checkAttempt.setInt(2, examId);

            if(checkAttempt.executeQuery().next()){
                conn.rollback();
                response.getWriter().println("You have already attempted this exam.");
                return;
            }

            int score = 0;

            PreparedStatement attemptPs = conn.prepareStatement(
                "INSERT INTO exam_attempts(student_id, exam_id, start_time) VALUES(?,?,NOW())",
                Statement.RETURN_GENERATED_KEYS
            );

            attemptPs.setInt(1, studentId);
            attemptPs.setInt(2, examId);
            attemptPs.executeUpdate();

            ResultSet generatedKeys = attemptPs.getGeneratedKeys();
            int attemptId = 0;

            if(generatedKeys.next()){
                attemptId = generatedKeys.getInt(1);
            }

            for(int i = 1; i <= total; i++){

                String selectedOptionStr = request.getParameter("q" + i);
                if(selectedOptionStr == null) continue;

                int selectedOptionId = Integer.parseInt(selectedOptionStr);
                int questionId = Integer.parseInt(request.getParameter("qid" + i));

                PreparedStatement checkPs = conn.prepareStatement(
                    "SELECT is_correct FROM options WHERE option_id=?"
                );

                checkPs.setInt(1, selectedOptionId);
                ResultSet rs = checkPs.executeQuery();

                int marks = 0;

                if(rs.next() && rs.getBoolean("is_correct")){
                    marks = 1;
                    score++;
                }

                PreparedStatement ansPs = conn.prepareStatement(
                    "INSERT INTO answers(attempt_id, question_id, selected_option, marks_awarded) VALUES(?,?,?,?)"
                );

                ansPs.setInt(1, attemptId);
                ansPs.setInt(2, questionId);
                ansPs.setInt(3, selectedOptionId);
                ansPs.setInt(4, marks);

                ansPs.executeUpdate();
            }

            // ✅ PASS / FAIL LOGIC (ADDED)
            String result = (score >= (total / 2)) ? "PASS" : "FAIL";

            PreparedStatement updatePs = conn.prepareStatement(
                "UPDATE exam_attempts SET score=?, status=?, end_time=NOW() WHERE attempt_id=?"
            );

            updatePs.setInt(1, score);
            updatePs.setString(2, result);
            updatePs.setInt(3, attemptId);
            updatePs.executeUpdate();

            conn.commit();

            AuditLogger.log(request, "Exam Submitted. Result: " + result + ", Score: " + score);

            // ✅ STORE MESSAGE IN SESSION (ADDED)
            HttpSession session = request.getSession();
            session.setAttribute("exam_message", "Your Score: " + score + " / " + total + " (" + result + ")");

            // ✅ REDIRECT INSTEAD OF FORWARD (IMPORTANT FIX)
            response.sendRedirect("message.jsp?msg=exam_submitted");

        } catch(Exception e){

            try {
                if(conn != null) conn.rollback();
            } catch(Exception ex){}

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}