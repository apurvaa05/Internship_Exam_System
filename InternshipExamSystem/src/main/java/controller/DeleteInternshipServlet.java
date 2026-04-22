package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/deleteInternship")
public class DeleteInternshipServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection con = DBConnection.getConnection();

            int id = Integer.parseInt(request.getParameter("id"));

            // 🔥 delete applications first (important)
            PreparedStatement ps1 = con.prepareStatement(
                "DELETE FROM applications WHERE internship_id=?"
            );
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // 🔥 then delete internship
            PreparedStatement ps2 = con.prepareStatement(
                "DELETE FROM internships WHERE internship_id=?"
            );
            ps2.setInt(1, id);
            ps2.executeUpdate();

            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}