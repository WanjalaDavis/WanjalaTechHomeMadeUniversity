<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    int studentId = Integer.parseInt(request.getParameter("id")); // Change parameter to "id"
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String fullName = "", email = "", regNo = "", dob = "", nationality = "", courseId = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
        stmt = conn.prepareStatement("SELECT * FROM students WHERE id = ?"); // Change column to "id"
        stmt.setInt(1, studentId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("full_name");
            email = rs.getString("email");
            regNo = rs.getString("reg_no");
            dob = rs.getString("dob");
            nationality = rs.getString("nationality");
            courseId = rs.getString("course_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Student</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-body">
            <h2 class="text-center mb-4">Edit Student</h2>
            <form action="updateStudent.jsp" method="post">
                <input type="hidden" name="id" value="<%= studentId %>">
                
                <div class="mb-3">
                    <label class="form-label">Full Name:</label>
                    <input type="text" name="full_name" class="form-control" value="<%= fullName %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="email" name="email" class="form-control" value="<%= email %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Reg No:</label>
                    <input type="text" name="reg_no" class="form-control" value="<%= regNo %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">DOB:</label>
                    <input type="date" name="dob" class="form-control" value="<%= dob %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Nationality:</label>
                    <input type="text" name="nationality" class="form-control" value="<%= nationality %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Course ID:</label>
                    <input type="text" name="course_id" class="form-control" value="<%= courseId %>" required>
                </div>

                <button type="submit" class="btn btn-success">Update</button>
                <a href="manageStudents.jsp" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</div>

</body>
</html>
