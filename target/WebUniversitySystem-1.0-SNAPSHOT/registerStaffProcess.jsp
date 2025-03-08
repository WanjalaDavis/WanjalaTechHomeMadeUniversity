<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Get form data
    String staffNo = request.getParameter("staffNo");
    String employeeNo = request.getParameter("employeeNo");
    String name = request.getParameter("name");
    int deptId = Integer.parseInt(request.getParameter("deptId"));

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/Managementdb";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Insert into staff table
        String sql = "INSERT INTO staff (staffNo, employeeNo, name, deptId, rank) VALUES (?, ?, ?, ?, 'Lecturer')";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, staffNo);
        stmt.setString(2, employeeNo);
        stmt.setString(3, name);
        stmt.setInt(4, deptId);
        int rowsInserted = stmt.executeUpdate();

        if (rowsInserted > 0) {
            response.sendRedirect("manageStaff.jsp?message=Lecturer Registered Successfully!");
        } else {
            response.sendRedirect("manageStaff.jsp?message=Failed to Register Lecturer!");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageStaff.jsp?message=Error Occurred!");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
