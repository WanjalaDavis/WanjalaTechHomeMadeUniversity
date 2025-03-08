<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Check if the user is an admin
    String adminUsername = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (adminUsername == null || !"admin".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Unauthorized access!");
        return;
        
    }

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Exam Timetable</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="adminDashboard.jsp">Admin Portal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ViewExamTimetable.jsp">Exam Timetable</a>
                </li> 
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Exam Timetable</h2>
    
    <!-- Display success/error messages -->
    <% if (request.getParameter("message") != null) { %>
        <div class="alert alert-success"><%= request.getParameter("message") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger"><%= request.getParameter("error") %></div>
    <% } %>

    <div class="card shadow">
        <div class="card-body">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Course</th>
                        <th>Course Unit</th>
                        <th>Exam Date</th>
                        <th>Venue</th>
                        <th>Seats</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(url, dbUser, dbPass);
                            String sql = "SELECT et.id, c.course_name, et.course_unit, et.exam_date, et.venue, et.room_capacity " +
                                         "FROM exam_timetable et " +
                                         "JOIN course c ON et.course_id = c.id";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getString("course_unit") %></td>
                        <td><%= rs.getDate("exam_date") %></td>
                        <td><%= rs.getString("venue") %></td>
                        <td><%= rs.getInt("room_capacity") %></td>
                        <td>
                            <a href="deleteExamTimetable.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this timetable?');">Delete</a>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
