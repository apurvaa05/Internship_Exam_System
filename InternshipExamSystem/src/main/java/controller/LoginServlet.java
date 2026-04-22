package controller;

import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;
import util.AuditLogger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // ✅ ADDED: TRACK ACTIVE USERS
    private static Map<Integer, HttpSession> activeUsers = new HashMap<>();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection con = DBConnection.getConnection();

            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String selectedRole = request.getParameter("role");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String dbRole = rs.getString("role");

                if (dbRole == null || dbRole.trim().isEmpty()) {
                    dbRole = "STUDENT";
                }

                if (!dbRole.equalsIgnoreCase(selectedRole)) {
                    response.sendRedirect("login.jsp?error=wrongrole");
                    return;
                }

                int userId = rs.getInt("user_id");

                // ✅ ADDED: DESTROY OLD SESSION IF EXISTS
                if (activeUsers.containsKey(userId)) {
                    HttpSession oldSession = activeUsers.get(userId);
                    try {
                        oldSession.invalidate();
                    } catch (Exception e) {}
                }

                HttpSession session = request.getSession();
                session.setAttribute("user_id", userId);
                session.setAttribute("user", rs.getString("name"));
                session.setAttribute("role", dbRole);

                // ✅ ADDED: STORE NEW SESSION
                activeUsers.put(userId, session);

                // ✅ AUDIT LOG
                AuditLogger.log(request, "User Logged In");

                if ("ADMIN".equalsIgnoreCase(dbRole)) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }

            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}