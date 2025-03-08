<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Ensure the user is logged in as a Lecturer
    String userRole = (String) session.getAttribute("userRole");
    String fullName = (String) session.getAttribute("fullName");
    String staffNo = (String) session.getAttribute("staffNo");

    if (userRole == null || !"lecturer".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Access Denied. Please log in as a Lecturer.");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Map to store students and their unit codes
    Map<String, List<String>> studentMap = new LinkedHashMap<>();

    try {
        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

        // Query to fetch students registered under the lecturer's assigned courses
        String sql = "SELECT DISTINCT c.course_name, s.full_name, s.reg_no, s.email, s.dob, s.nationality, ru.unit_code " +
                     "FROM assigned_courses ac " +
                     "JOIN course c ON ac.courseId = c.id " +
                     "JOIN students s ON s.course_id = ac.courseId " +
                     "JOIN registered_units ru ON ru.student_email = s.email " +
                     "WHERE ac.staffNo = ? ";

        stmt = conn.prepareStatement(sql);
        stmt.setString(1, staffNo);
        rs = stmt.executeQuery();

        while (rs.next()) {
            String studentKey = rs.getString("course_name") + "|" + rs.getString("full_name") + "|" + rs.getString("reg_no") + "|" +
                                rs.getString("email") + "|" + rs.getString("dob") + "|" + rs.getString("nationality");

            String unitCode = rs.getString("unit_code");

            if (!studentMap.containsKey(studentKey)) {
                studentMap.put(studentKey, new ArrayList<>());
            }
            studentMap.get(studentKey).add(unitCode);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Students Registered for Courses</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="Lecture.jsp">HomeMade-University</a>
            <span class="navbar-text text-white">Welcome, <%= fullName %> (Staff No: <%= staffNo %>)</span>
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="mb-4">Students Registered for Your Courses</h2>
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Course Name</th>
                    <th>Student Name</th>
                    <th>Registration Number</th>
                    <th>Email</th>
                    <th>Date of Birth</th>
                    <th>Nationality</th>
                    <th>Unit Codes</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map.Entry<String, List<String>> entry : studentMap.entrySet()) {
                    String[] details = entry.getKey().split("\\|");
                    List<String> unitCodes = entry.getValue();
                %>
                    <tr>
                        <td><%= details[0] %></td>
                        <td><%= details[1] %></td>
                        <td><%= details[2] %></td>
                        <td><%= details[3] %></td>
                        <td><%= details[4] %></td>
                        <td><%= details[5] %></td>
                        <td><%= String.join(", ", unitCodes) %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

<!-- Bootstrap 5 Footer -->
<footer class="bg-dark text-white pt-5 pb-4 mt-5">
  <div class="container">
    <div class="row">
      <!-- Quick Links -->
      <div class="col-md-3 col-sm-6 mb-4">
        <h5 class="text-uppercase mb-4">Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="#" class="text-white text-decoration-none">Home</a></li>
          <li><a href="#" class="text-white text-decoration-none">About Us</a></li>
          <li><a href="#" class="text-white text-decoration-none">Services</a></li>
          <li><a href="#" class="text-white text-decoration-none">Portfolio</a></li>
          <li><a href="#" class="text-white text-decoration-none">Contact</a></li>
        </ul>
      </div>

      <!-- Contact Information -->
      <div class="col-md-3 col-sm-6 mb-4">
        <h5 class="text-uppercase mb-4">Contact Us</h5>
        <ul class="list-unstyled">
          <li><i class="fas fa-map-marker-alt me-2"></i>039 Moi Avenue, Bungoma, Kenya</li>
          <li><i class="fas fa-phone me-2"></i>+245 115 855 856</li>
          <li><i class="fas fa-envelope me-2"></i>wanjaladevis81@gmail.com</li>
        </ul>
      </div>

      <!-- Social Media Links -->
      <div class="col-md-3 col-sm-6 mb-4">
        <h5 class="text-uppercase mb-4">Follow Us</h5>
        <ul class="list-unstyled">
          <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-facebook-f me-2"></i>Facebook</a></li>
          <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-twitter me-2"></i>Twitter</a></li>
          <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-instagram me-2"></i>Instagram</a></li>
          <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-linkedin-in me-2"></i>LinkedIn</a></li>
        </ul>
      </div>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
