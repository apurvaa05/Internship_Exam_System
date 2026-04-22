package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			Connection con = DBConnection.getConnection();

			// 🔹 GET FORM DATA
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String course = request.getParameter("course");
			String cgpaStr = request.getParameter("cgpa");
			String phone = request.getParameter("phone");

			// 🔹 BASIC VALIDATION
			if (name == null || email == null || password == null || course == null || cgpaStr == null || phone == null
					|| name.isEmpty() || email.isEmpty() || password.isEmpty()) {

				response.getWriter().println("All fields are required.");
				return;
			}

			double cgpa = Double.parseDouble(cgpaStr);

			// ✅ CHECK DUPLICATE EMAIL
			PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE email=?");
			check.setString(1, email);
			ResultSet rsCheck = check.executeQuery();

			if (rsCheck.next()) {
				response.getWriter().println("Email already registered. Please login.");
				return;
			}

			// 🔥 INSERT INTO USERS
			PreparedStatement ps1 = con.prepareStatement("INSERT INTO users (name, email, password) VALUES (?, ?, ?)",
					Statement.RETURN_GENERATED_KEYS);

			ps1.setString(1, name);
			ps1.setString(2, email);
			ps1.setString(3, password);

			ps1.executeUpdate();

			// 🔥 GET USER ID
			ResultSet rs = ps1.getGeneratedKeys();
			rs.next();
			int userId = rs.getInt(1);

			// 🔥 INSERT INTO STUDENTS
			PreparedStatement ps2 = con
					.prepareStatement("INSERT INTO students (user_id, course, cgpa, phone) VALUES (?, ?, ?, ?)");

			ps2.setInt(1, userId);
			ps2.setString(2, course);
			ps2.setDouble(3, cgpa);
			ps2.setString(4, phone);

			ps2.executeUpdate();

			// ✅ SUCCESS REDIRECT
			response.sendRedirect("login.jsp?msg=registered");

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("Error: " + e.getMessage());
		}
	}
}