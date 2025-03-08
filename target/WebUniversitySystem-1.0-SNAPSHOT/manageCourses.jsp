<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Create Exam Timetable</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #007bff;
        }
        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }
        .search-bar {
            width: 300px;
        }
    </style>
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
                    <a class="nav-link" href="Create-course.jsp">Register Course</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="manageCourses.jsp">Create Exam Timetable</a>
                </li>                    
            </ul>
            <form class="d-flex">
                <input class="form-control me-2 search-bar" type="search" placeholder="Search courses..." aria-label="Search">
                <button class="btn btn-light" type="submit">Search</button>
            </form>
        </div>
    </div>
</nav>

<!-- Exam Timetable Form -->
<div class="container mt-4">
    <h2>Create Exam Timetable</h2>
    <form action="createExamTimetable.jsp" method="post">
        
        <!-- Select Course -->
        <div class="mb-3">
            <label for="course" class="form-label">Select Course</label>
            <select id="course" name="course_id" class="form-control" required onchange="fetchCourseUnits()">
                <option value="">-- Select Course --</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT id, course_name FROM course");

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                %>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("course_name") %></option>
                <% 
                        }

                        if (!hasData) {
                            out.println("<option value=''>No courses available</option>");
                        }

                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>

        <!-- Select Course Unit -->
        <div class="mb-3">
            <label for="courseUnit" class="form-label">Select Course Unit</label>
            <select id="courseUnit" name="course_unit" class="form-control" required>
                <option value="">-- Select Course Unit --</option>
                <!-- Course units will be dynamically loaded using JavaScript -->
            </select>
        </div>

        <!-- Exam Date -->
        <div class="mb-3">
            <label for="examDate" class="form-label">Exam Date</label>
            <input type="date" id="examDate" name="exam_date" class="form-control" required>
        </div>

        <!-- Exam Venue -->
        <div class="mb-3">
            <label for="venue" class="form-label">Exam Venue</label>
            <input type="text" id="venue" name="venue" class="form-control" required>
        </div>

        <!-- Room Capacity -->
        <div class="mb-3">
            <label for="capacity" class="form-label">Number of Seats</label>
            <input type="number" id="capacity" name="room_capacity" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Create Timetable</button>
    </form>
</div>

<script>
    function fetchCourseUnits() {
        var courseId = document.getElementById("course").value;
        var courseUnitDropdown = document.getElementById("courseUnit");

        // Clear existing options
        courseUnitDropdown.innerHTML = "<option value=''>-- Select Course Unit --</option>";

        if (courseId) {
            fetch("getCourseUnits.jsp?course_id=" + courseId)
                .then(response => response.text())
                .then(data => {
                    courseUnitDropdown.innerHTML += data;
                })
                .catch(error => console.error("Error fetching course units:", error));
        }
    }
</script>



                       
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
