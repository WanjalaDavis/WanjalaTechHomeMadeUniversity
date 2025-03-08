<%@ page import="java.sql.*" %>
<%
    // Retrieve staffNo from session
    String staffNo = (String) session.getAttribute("staffNo");
    String courseId = request.getParameter("course_id");

    if (staffNo != null && courseId != null && !courseId.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            // Connect to MySQL database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

            // Check if the lecturer has already registered a course
            String checkQuery = "SELECT COUNT(*) AS count FROM assigned_courses WHERE staffNo = ?";
            psCheck = con.prepareStatement(checkQuery);
            psCheck.setString(1, staffNo);
            rs = psCheck.executeQuery();
            
            int courseCount = 0;
            if (rs.next()) {
                courseCount = rs.getInt("count");
            }

            if (courseCount > 0) {
                // Lecturer has already registered a course
                response.sendRedirect("CourseTeach.jsp?message=You have already registered a course. You cannot register more than one.");
            } else {
                // Register the selected course
                String insertQuery = "INSERT INTO assigned_courses (staffNo, courseId) VALUES (?, ?)";
                psInsert = con.prepareStatement(insertQuery);
                psInsert.setString(1, staffNo);
                psInsert.setString(2, courseId);

                int rowsInserted = psInsert.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("CourseTeach.jsp?message=Course successfully registered!");
                } else {
                    response.sendRedirect("CourseTeach.jsp?message=Failed to register course. Try again.");
                }
            }

        } catch (Exception e) {
            response.sendRedirect("CourseTeach.jsp?message=Error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (psCheck != null) psCheck.close();
                if (psInsert != null) psInsert.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        response.sendRedirect("CourseTeach.jsp?message=Invalid request. Please select a course.");
    }
%>
