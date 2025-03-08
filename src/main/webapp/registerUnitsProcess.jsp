<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Retrieve form data
    String studentEmail = request.getParameter("studentEmail");
    String[] selectedUnits = request.getParameterValues("selectedUnits");

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/Managementdb";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    boolean registrationSuccess = false;

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get course_id for each unit (assuming course_id is the same for all units)
        String courseQuery = "SELECT course_id FROM registered_units WHERE unit_code = ? LIMIT 1";
        PreparedStatement courseStmt = conn.prepareStatement(courseQuery);

        // Register selected course units
        if (selectedUnits != null) {
            String sql = "INSERT INTO registered_units (student_email, course_id, unit_code) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            
            for (String unit : selectedUnits) {
                // Retrieve the course_id for this unit
                courseStmt.setString(1, unit);
                ResultSet rs = courseStmt.executeQuery();
                int courseId = 1; // Default value in case the query fails
                
                if (rs.next()) {
                    courseId = rs.getInt("course_id");
                }
                rs.close();

                // Insert registration record
                stmt.setString(1, studentEmail);
                stmt.setInt(2, courseId);
                stmt.setString(3, unit);
                stmt.addBatch();
            }

            int[] results = stmt.executeBatch();
            if (results.length > 0) {
                registrationSuccess = true;
            }
        }

        courseStmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Unit Registration Status</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center">Unit Registration</h2>
    
    <div class="alert <% if (registrationSuccess) { %>alert-success<% } else { %>alert-danger<% } %> text-center">
        <% if (registrationSuccess) { %>
            ✅ Registration successful! Your selected course units have been registered.
        <% } else { %>
            ❌ Registration failed! Please try again or contact the administrator.
        <% } %>
    </div>

    <div class="text-center mt-4">
        <a href="RegisterUnits.jsp" class="btn btn-primary">Go Back</a>
        <a href="studentDashboard.jsp" class="btn btn-success">Go to Dashboard</a>
    </div>
</div>

</body>
</html>
