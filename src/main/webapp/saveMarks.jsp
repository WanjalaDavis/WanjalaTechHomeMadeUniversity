<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Ensure only the admin can save marks
    String adminUsername = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (adminUsername == null || !"admin".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Unauthorized access!");
        return;
    }

    // Database connection
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", ""); 

        // Get data from form
        String[] studentEmails = request.getParameterValues("studentEmail");
        String[] unitIds = request.getParameterValues("unitId");
        String[] courseIds = request.getParameterValues("courseId");
        String[] catMarks = request.getParameterValues("courseWorkMarks");
        String[] examMarks = request.getParameterValues("examMarks");

        if (studentEmails != null) {
            // ✅ Prepare the SQL query (INSERT or UPDATE)
            String sql = "INSERT INTO results (student_email, unit_id, course_id, courseWork, exam) " +
                         "VALUES (?, ?, ?, ?, ?) " +
                         "ON DUPLICATE KEY UPDATE courseWork = VALUES(courseWork), exam = VALUES(exam)";

            stmt = conn.prepareStatement(sql);

            // ✅ Loop through the submitted marks and save each record
            for (int i = 0; i < studentEmails.length; i++) {
                stmt.setString(1, studentEmails[i]);
                stmt.setInt(2, Integer.parseInt(unitIds[i]));
                stmt.setInt(3, Integer.parseInt(courseIds[i]));
                stmt.setInt(4, Integer.parseInt(catMarks[i]));
                stmt.setInt(5, Integer.parseInt(examMarks[i]));
                stmt.addBatch(); // Add to batch processing
            }

            // Execute batch insert/update
            stmt.executeBatch();
        }

        // ✅ Redirect to the marks entry page with a success message
        response.sendRedirect("EnterMarksStudents.jsp?success=Marks saved successfully");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("EnterMarksStudents.jsp?error=Failed to save marks");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
ss