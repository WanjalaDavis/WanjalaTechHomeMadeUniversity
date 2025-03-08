<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Retrieve session attributes
    String studentName = (String) session.getAttribute("fullName");
    String studentEmail = (String) session.getAttribute("email");

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt1 = null, stmt2 = null;
    ResultSet rs1 = null, rs2 = null;
    String courseName = "Not Assigned";

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Query 1: Retrieve student's course
        String sql1 = "SELECT c.course_name FROM students s JOIN course c ON s.course_id = c.id WHERE s.email = ?";
        stmt1 = conn.prepareStatement(sql1);
        stmt1.setString(1, studentEmail);
        rs1 = stmt1.executeQuery();

        if (rs1.next()) {
            courseName = rs1.getString("course_name");
        }

        // Query 2: Retrieve student's results
        String sql2 = "SELECT r.unit_id, u.unit_name, r.coursework, r.exam FROM results r JOIN course_units u ON r.unit_id = u.id WHERE r.student_email = ?";
        stmt2 = conn.prepareStatement(sql2);
        stmt2.setString(1, studentEmail);
        rs2 = stmt2.executeQuery();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>View Results</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .table-container {
            margin-top: 50px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Student Portal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="studentDashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="RegisterUnits.jsp">Register Units</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="StudentViewExamTimetable.jsp">Exam Timetable</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="ViewResults.jsp">Results</a>
                </li>
            </ul>
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container table-container">
    <h2 class="text-center">Student Results</h2>
    <p class="text-center"><strong>Student Name:</strong> <%= (studentName != null) ? studentName : "Guest" %></p>
    <p class="text-center"><strong>Email:</strong> <%= (studentEmail != null) ? studentEmail : "Not Provided" %></p>
    <p class="text-center"><strong>Course:</strong> <%= courseName %></p>

    <table class="table table-bordered table-striped mt-4">
        <thead class="table-dark">
            <tr>
                <th>Unit ID</th>
                <th>Unit Name</th>
                <th>Course Work (30%)</th>
                <th>Exam (70%)</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (rs2 != null) {
                    boolean hasResults = false;
                    while (rs2.next()) {
                        hasResults = true;
                        int unitId = rs2.getInt("unit_id");
                        String unitName = rs2.getString("unit_name");
                        int courseWorkMarks = rs2.getInt("coursework");
                        int examMarks = rs2.getInt("exam");
                        int totalMarks = courseWorkMarks + examMarks;
            %>
            <tr>
                <td><%= unitId %></td>
                <td><%= unitName %></td>
                <td><%= courseWorkMarks %></td>
                <td><%= examMarks %></td>
                <td><%= totalMarks %></td>
            </tr>
            <%
                    }
                    if (!hasResults) {
            %>
            <tr>
                <td colspan="5" class="text-center">No results found.</td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" class="text-center text-danger">Error retrieving results. Please try again later.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<!-- Close database connections -->
<%
    try {
        if (rs1 != null) rs1.close();
        if (stmt1 != null) stmt1.close();
        if (rs2 != null) rs2.close();
        if (stmt2 != null) stmt2.close();
        if (conn != null) conn.close();
    } catch (SQLException ignored) {}
%>


                       <!-- Bootstrap 5 Footer -->
<footer class="bg-dark text-white pt-5 pb-4">
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



<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
