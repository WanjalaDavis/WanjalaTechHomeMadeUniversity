<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    String courseId = request.getParameter("course_id");
    if (courseId != null && !courseId.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
            PreparedStatement stmt = conn.prepareStatement("SELECT unit_code, unit_name FROM course_units WHERE course_id = ?");
            stmt.setString(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                out.println("<option value='" + rs.getString("unit_code") + "'>" + rs.getString("unit_name") + "</option>");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
