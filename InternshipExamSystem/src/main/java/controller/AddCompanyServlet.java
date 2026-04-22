package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/addCompany")   // ✅ THIS LINE IS CRITICAL
public class AddCompanyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connection con = DBConnection.getConnection();

            String name = request.getParameter("name");            String location = request.getParameter("location");
            double cgpa = Double.parseDouble(request.getParameter("cgpa"));

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO companies (company_name, location, eligibility_cgpa) VALUES (?, ?, ?)"
            );

            ps.setString(1, name);
            ps.setString(2, location);
            ps.setDouble(3, cgpa);

            ps.executeUpdate();

            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}