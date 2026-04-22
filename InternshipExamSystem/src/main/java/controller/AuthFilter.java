package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import util.DBConnection;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        String uri = request.getRequestURI();

        // PUBLIC
        if (uri.contains("login") || uri.contains("register") ||
            uri.contains("css") || uri.contains("js") || uri.contains("images")) {

            chain.doFilter(req, res);
            return;
        }

        // NOT LOGGED IN
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ADMIN PROTECTION
        if ((uri.endsWith("admin.jsp") || uri.endsWith("reports.jsp")) &&
            !"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect("dashboard.jsp");
            return;
        }

        // STUDENT PROTECTION
        if ((uri.endsWith("dashboard.jsp") ||
             uri.endsWith("training.jsp") ||
             uri.endsWith("internships.jsp") ||
             uri.endsWith("applications.jsp") ||
             uri.endsWith("exam.jsp")) &&
            !"STUDENT".equalsIgnoreCase(role)) {

            response.sendRedirect("admin.jsp");
            return;
        }

        // STUDENT LOGIC
        if ("STUDENT".equalsIgnoreCase(role)) {

            try {
                Connection con = DBConnection.getConnection();
                int userId = (int) session.getAttribute("user_id");

                // GET student_id
                PreparedStatement ps1 = con.prepareStatement(
                    "SELECT student_id FROM students WHERE user_id=?"
                );
                ps1.setInt(1, userId);
                ResultSet rs1 = ps1.executeQuery();

                int studentId = 0;
                if (rs1.next()) studentId = rs1.getInt("student_id");

                // TRAINING CHECK
                PreparedStatement ps2 = con.prepareStatement(
                    "SELECT COUNT(*) FROM training WHERE student_id=? AND status='PENDING'"
                );
                ps2.setInt(1, studentId);
                ResultSet rs2 = ps2.executeQuery();

                if (rs2.next() && rs2.getInt(1) > 0) {
                    if (uri.endsWith("internships.jsp") ||
                        uri.endsWith("applications.jsp") ||
                        uri.endsWith("exam.jsp")) {

                        response.sendRedirect("training.jsp");
                        return;
                    }
                }

                // ✅ SELECTION CHECK
                PreparedStatement psSelect = con.prepareStatement(
                    "SELECT COUNT(*) FROM applications WHERE student_id=? AND status='SELECTED'"
                );
                psSelect.setInt(1, studentId);
                ResultSet rsSelect = psSelect.executeQuery();

                boolean isSelected = false;
                if (rsSelect.next() && rsSelect.getInt(1) > 0) {
                    isSelected = true;
                }

                if (!isSelected && uri.endsWith("exam.jsp")) {
                    response.sendRedirect("dashboard.jsp");
                    return;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(req, res);
    }
}