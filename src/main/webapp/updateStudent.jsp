<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    int studentId = Integer.parseInt(request.getParameter("id")); // Change "studentNo" to "id"
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String regNo = request.getParameter("reg_no");
    String dob = request.getParameter("dob");
    String nationality = request.getParameter("nationality");
    String courseId = request.getParameter("course_id");

    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
        stmt = conn.prepareStatement("UPDATE students SET full_name=?, email=?, reg_no=?, dob=?, nationality=?, course_id=? WHERE id=?"); // Change "studentNo" to "id"
        stmt.setString(1, fullName);
        stmt.setString(2, email);
        stmt.setString(3, regNo);
        stmt.setString(4, dob);
        stmt.setString(5, nationality);
        stmt.setString(6, courseId);
        stmt.setInt(7, studentId);
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
            response.sendRedirect("manageStudents.jsp?message=Updated successfully");
        } else {
            response.sendRedirect("manageStudents.jsp?error=No student found");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageStudents.jsp?error=Update failed");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
