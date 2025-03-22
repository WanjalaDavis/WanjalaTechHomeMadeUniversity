<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Retrieve login inputs
    String username = request.getParameter("username").trim();
    String password = request.getParameter("password").trim();

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Admin Login Check
        if ("admin".equals(username) && "admin".equals(password)) {
            session.setAttribute("userRole", "admin");
            session.setAttribute("username", "Administrator");
            response.sendRedirect("adminDashboard.jsp");
        } else {
            // Student Login Check
            String studentSQL = "SELECT full_name FROM students WHERE email = ? AND reg_no = ?";
            stmt = conn.prepareStatement(studentSQL);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("userRole", "student");
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("email", username);
                response.sendRedirect("studentDashboard.jsp");
                return;
            }
            
            // Lecturer Login Check
            String lecturerSQL = "SELECT name FROM staff WHERE staffNo = ? AND employeeNo = ? AND rank = 'Lecturer'";
            stmt = conn.prepareStatement(lecturerSQL);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("userRole", "lecturer");
                session.setAttribute("fullName", rs.getString("name"));
                session.setAttribute("staffNo", username);
                response.sendRedirect("Lecture.jsp");
                return;
            }
            
            // Invalid Credentials
            response.sendRedirect("LoginPage.jsp?error=Invalid Credentials");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("LoginPage.jsp?error=Something went wrong!");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
