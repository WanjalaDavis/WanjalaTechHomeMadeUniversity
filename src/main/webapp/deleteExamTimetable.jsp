<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Admin check
    String adminUsername = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (adminUsername == null || !"admin".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Unauthorized access!");
        return;
    }

    // Get the exam timetable ID from URL
    String id = request.getParameter("id");

    if (id == null || id.isEmpty()) {
        response.sendRedirect("ViewExamTimetable.jsp?error=Invalid timetable ID");
        return;
    }

    // Database connection
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Delete timetable entry
        String sql = "DELETE FROM exam_timetable WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(id));
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("ViewExamTimetable.jsp?message=Timetable deleted successfully");
        } else {
            response.sendRedirect("ViewExamTimetable.jsp?error=Failed to delete timetable");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ViewExamTimetable.jsp?error=Database error: " + e.getMessage());
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
