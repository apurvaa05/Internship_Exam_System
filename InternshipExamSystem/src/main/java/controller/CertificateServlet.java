package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBConnection;

@WebServlet("/certificate")
public class CertificateServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection con = DBConnection.getConnection();

            int userId = (int) request.getSession().getAttribute("user_id");

            // ✅ GET NAME + SCORE
            PreparedStatement ps = con.prepareStatement(
                "SELECT u.name, s.student_id, ea.score " +
                "FROM users u " +
                "JOIN students s ON u.user_id = s.user_id " +
                "JOIN exam_attempts ea ON s.student_id = ea.student_id " +
                "WHERE u.user_id=? ORDER BY ea.score DESC LIMIT 1"
            );

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("studentId", rs.getInt("student_id"));
                request.setAttribute("score", rs.getInt("score"));
            }

            request.getRequestDispatcher("certificate.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}