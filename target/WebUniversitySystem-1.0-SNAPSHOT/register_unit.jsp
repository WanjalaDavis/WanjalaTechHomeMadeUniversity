<%@ page import="java.sql.*" %>
<%
    String staffNo = request.getParameter("staffNo");
    String unitId = request.getParameter("unit_id");

    if (staffNo != null && unitId != null) {
        Connection con = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            // Connect to MySQL database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

            // Check if the lecturer has already registered a unit
            String checkQuery = "SELECT COUNT(*) AS count FROM assigned_courses WHERE staffNo = ?";
            psCheck = con.prepareStatement(checkQuery);
            psCheck.setString(1, staffNo);
            rs = psCheck.executeQuery();
            
            int unitCount = 0;
            if (rs.next()) {
                unitCount = rs.getInt("count");
            }

            if (unitCount > 0) {
                // Lecturer has already registered a unit
                out.println("<script>alert('You have already registered a unit. You cannot register more than one.'); window.location.href='Lecture.jsp';</script>");
            } else {
                // Register the selected unit
                String insertQuery = "INSERT INTO assigned_courses (staffNo, unit_id) VALUES (?, ?)";
                psInsert = con.prepareStatement(insertQuery);
                psInsert.setString(1, staffNo);
                psInsert.setString(2, unitId);

                int rowsInserted = psInsert.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<script>alert('Unit successfully registered!'); window.location.href='Lecture.jsp';</script>");
                } else {
                    out.println("<script>alert('Failed to register unit. Try again.'); window.location.href='Lecture.jsp';</script>");
                }
            }

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href='Lecture.jsp';</script>");
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
        out.println("<script>alert('Invalid request. Please try again.'); window.location.href='Lecture.jsp';</script>");
    }
%>
