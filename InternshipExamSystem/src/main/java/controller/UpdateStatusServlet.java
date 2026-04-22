package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appIdStr = request.getParameter("application_id");
            String status = request.getParameter("status");

            // ✅ SAFE CHECK (prevents your crash)
            if(appIdStr == null || status == null){
                response.getWriter().println("Invalid request");
                return;
            }

            int applicationId = Integer.parseInt(appIdStr);

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE applications SET status=? WHERE application_id=?"
            );

            ps.setString(1, status);
            ps.setInt(2, applicationId);

            ps.executeUpdate();

            // ✅ Redirect back (no blank page)
            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}