package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/addInternship")
public class AddInternshipServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection con = DBConnection.getConnection();

            // 📌 Get form values
            String role = request.getParameter("role");
            int companyId = Integer.parseInt(request.getParameter("company_id"));
            double stipend = Double.parseDouble(request.getParameter("stipend"));
            String deadline = request.getParameter("deadline");

            // 📌 Debug print
            System.out.println(role + " " + companyId + " " + stipend + " " + deadline);

            // 📌 Insert query
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO internships (company_id, role, stipend, deadline) VALUES (?, ?, ?, ?)"
            );

            ps.setInt(1, companyId);
            ps.setString(2, role);
            ps.setDouble(3, stipend);
            ps.setString(4, deadline);

            ps.executeUpdate();

            // ✅ REDIRECT (IMPORTANT)
            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace(); // VERY IMPORTANT

            // show error on browser (so not blank)
            response.setContentType("text/html");
            response.getWriter().println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
}