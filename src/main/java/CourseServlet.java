import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/Managementdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseName = request.getParameter("courseName");
        String[] unitNames = request.getParameterValues("unitNames[]");
        String[] unitCodes = request.getParameterValues("unitCodes[]");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Insert course
            String insertCourseSQL = "INSERT INTO course (course_name) VALUES (?)";
            PreparedStatement courseStmt = conn.prepareStatement(insertCourseSQL, Statement.RETURN_GENERATED_KEYS);
            courseStmt.setString(1, courseName);
            courseStmt.executeUpdate();

            // Get generated Course ID
            java.sql.ResultSet generatedKeys = courseStmt.getGeneratedKeys();
            int courseId = 0;
            if (generatedKeys.next()) {
                courseId = generatedKeys.getInt(1);
            }

            // Insert course units
            if (unitNames != null && unitCodes != null) {
                String insertUnitSQL = "INSERT INTO course_units (course_id, unit_name, unit_code) VALUES (?, ?, ?)";
                PreparedStatement unitStmt = conn.prepareStatement(insertUnitSQL);

                for (int i = 0; i < unitNames.length; i++) {
                    unitStmt.setInt(1, courseId);
                    unitStmt.setString(2, unitNames[i]);
                    unitStmt.setString(3, unitCodes[i]);
                    unitStmt.addBatch();
                }
                unitStmt.executeBatch();
                unitStmt.close();
            }

            courseStmt.close();
            conn.close();

            response.sendRedirect("success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
