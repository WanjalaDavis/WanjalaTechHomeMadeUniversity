<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Get student ID from the request
    int studentId = Integer.parseInt(request.getParameter("id")); 

    // Database credentials
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Delete query
        stmt = conn.prepareStatement("DELETE FROM students WHERE id = ?");
        stmt.setInt(1, studentId);
        int rowsDeleted = stmt.executeUpdate();

        // Redirect based on success/failure
        if (rowsDeleted > 0) {
            response.sendRedirect("manageStudents.jsp?message=Student deleted successfully");
        } else {
            response.sendRedirect("manageStudents.jsp?error=Failed to delete student");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageStudents.jsp?error=An error occurred while deleting");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
