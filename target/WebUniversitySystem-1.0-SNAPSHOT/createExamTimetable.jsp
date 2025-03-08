<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Get form data
    String courseId = request.getParameter("course_id");
    String courseUnit = request.getParameter("course_unit");
    String examDate = request.getParameter("exam_date");
    String venue = request.getParameter("venue");
    String capacityStr = request.getParameter("room_capacity");

    // Validate input to prevent errors
    if (courseId == null || courseUnit == null || examDate == null || venue == null || capacityStr == null ||
        courseId.isEmpty() || courseUnit.isEmpty() || examDate.isEmpty() || venue.isEmpty() || capacityStr.isEmpty()) {
        response.sendRedirect("manageCourses.jsp?error=All fields are required");
        return;
    }

    int roomCapacity = 0;
    try {
        roomCapacity = Integer.parseInt(capacityStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("manageCourses.jsp?error=Invalid room capacity");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
        
        // Insert exam timetable record
        String sql = "INSERT INTO exam_timetable (course_id, course_unit, exam_date, venue, room_capacity) VALUES (?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, courseId);
        stmt.setString(2, courseUnit);
        stmt.setString(3, examDate);
        stmt.setString(4, venue);
        stmt.setInt(5, roomCapacity);
        stmt.executeUpdate();

        response.sendRedirect("manageCourses.jsp?message=Timetable created successfully");

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("manageCourses.jsp?error=Database error: " + e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageCourses.jsp?error=Unexpected error: " + e.getMessage());
    } finally {
        // Close resources
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
