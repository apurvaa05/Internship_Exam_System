package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/internship_system",
                "root",
                "OpenMe@13"   // ⚠️ TRY EMPTY FIRST
            );

            System.out.println("✅ Database Connected");

        } catch (Exception e) {
            System.out.println("❌ DB FAILED");
            e.printStackTrace();   // VERY IMPORTANT
        }

        return con;
    }
}