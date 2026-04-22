package util;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class AuditLogger {

    public static void log(HttpServletRequest request, String action) {
        try {
            Connection con = DBConnection.getConnection();

            HttpSession session = request.getSession(false);
            Integer userId = (session != null) ? (Integer) session.getAttribute("user_id") : null;

            String ip = request.getRemoteAddr();
            String agent = request.getHeader("User-Agent");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO audit_logs (user_id, action, ip_address, user_agent) VALUES (?, ?, ?, ?)"
            );

            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }

            ps.setString(2, action);
            ps.setString(3, ip);
            ps.setString(4, agent);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace(); // safe fallback
        }
    }
}