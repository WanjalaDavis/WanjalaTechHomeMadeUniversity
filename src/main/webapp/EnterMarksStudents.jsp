<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Prevent access if not logged in as admin
    String adminUsername = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (adminUsername == null || !"admin".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Unauthorized access!");
        return;
    }

    // Database Connection
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", ""); 

        // ✅ FIXED QUERY: Fetch students and units based on course_id
        String sql = "SELECT s.full_name, s.reg_no, s.email, c.course_name, c.id AS course_id, " +
                     "cu.unit_code, cu.unit_name, cu.id AS unit_id " +
                     "FROM students s " +
                     "JOIN course c ON s.course_id = c.id " +  // Links students to their actual course
                     "JOIN course_units cu ON cu.course_id = c.id " +  // Fetches only units for the course
                     "ORDER BY s.reg_no, cu.unit_code";

        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Track previously displayed student
        String prevRegNo = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Enter Student Marks</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    
     
    <style>
        body { background-color: #f8f9fa; }
        .navbar { box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
        .card { border: none; border-radius: 10px; transition: transform 0.2s; }
        .card:hover { transform: translateY(-5px); }
        .list-group-item { border: none; padding: 15px; margin-bottom: 10px; border-radius: 8px; transition: background-color 0.3s; }
        .list-group-item:hover { background-color: #f1f1f1; }
        .list-group-item a { text-decoration: none; color: #333; font-weight: 500; }
        .list-group-item a:hover { color: #007bff; }
        .card-body h4 { color: #333; margin-bottom: 20px; }
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .navbar-text { font-size: 1rem; }
    </style>
   <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="adminDashboard.jsp">Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ViewExamTimetable.jsp">Exam Timetable</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="EnterMarksStudents.jsp">Enter Marks for Students</a>
                </li>
            </ul>
            <form class="d-flex">
                <input class="form-control me-2 search-bar" type="search" placeholder="Search courses..." aria-label="Search">
                <button class="btn btn-light" type="submit">Search</button>
            </form>
        </div>
    </div>
</nav>


    <div class="container mt-5">
        <h2 class="mb-4">Enter Student Marks</h2>
        <form action="saveMarks.jsp" method="post">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Reg No</th>
                        <th>Email</th>
                        <th>Course</th>
                        <th>Unit Code</th>
                        <th>Unit Name</th>
                        <th>CAT Marks</th>
                        <th>Exam Marks</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            String studentName = rs.getString("full_name");
                            String regNo = rs.getString("reg_no");
                            String email = rs.getString("email");
                            String courseName = rs.getString("course_name");
                            int courseId = rs.getInt("course_id");
                            String unitCode = rs.getString("unit_code");
                            String unitName = rs.getString("unit_name");
                            int unitId = rs.getInt("unit_id");

                            // ✅ Print student details only if it's a new student
                            boolean isNewStudent = !regNo.equals(prevRegNo);

                            if (isNewStudent) {
                                if (!prevRegNo.isEmpty()) {
                                    // Close the previous student's row before starting a new one
                                    out.println("</tbody></table><br>");
                                }
                    %>
                    <!-- New Student Row -->
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <td rowspan="999"><strong><%= studentName %></strong></td>
                                <td rowspan="999"><%= regNo %></td>
                                <td rowspan="999"><%= email %></td>
                                <td rowspan="999"><%= courseName %></td>
                    <%
                            }

                            // ✅ Now, only the unit row is repeated
                    %>
                            <tr>
                                <td><%= unitCode %></td>
                                <td><%= unitName %></td>
                                <td>
                                    <input type="hidden" name="studentEmail" value="<%= email %>">
                                    <input type="hidden" name="unitId" value="<%= unitId %>">
                                    <input type="hidden" name="courseId" value="<%= courseId %>">
                                    <input type="number" name="courseWorkMarks" class="form-control" required>
                                </td>
                                <td>
                                    <input type="number" name="examMarks" class="form-control" required>
                                </td>
                            </tr>
                    <%
                            prevRegNo = regNo;  // ✅ Update last printed student
                        }
                    %>
                </tbody>
            </table>
            <button type="submit" class="btn btn-primary">Save Marks</button>
        </form>
    </div>

                                                  
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

      <!-- Newsletter Subscription -->
      <div class="col-md-3 col-sm-6 mb-4">
        <h5 class="text-uppercase mb-4">Newsletter</h5>
        <p>Subscribe to our newsletter for the latest updates.</p>
        <form>
          <div class="input-group">
            <input type="email" class="form-control" placeholder="Your Email" aria-label="wanjaladevis81@gmail.com">
            <button class="btn btn-primary" type="button">Subscribe</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Copyright Notice -->
    <div class="row mt-4">
      <div class="col-12 text-center">
        <p class="mb-0">&copy; 2025 WanjalaTech. All Rights Reserved.</p>
      </div>
    </div>
  </div>
</footer>

<!-- Bootstrap JS and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- Font Awesome for Icons -->
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
                        


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
