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
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String courseName = "Not Assigned";

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Retrieve student's course
        String sql = "SELECT c.course_name FROM students s JOIN course c ON s.course_id = c.id WHERE s.email = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, studentEmail);
        rs = stmt.executeQuery();

        if (rs.next()) {
            courseName = rs.getString("course_name");
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Custom Styles */
        body {
            background-color: darkgray;
            font-family: 'Arial', sans-serif;
            color: #333;
        }

        /* Navbar */
        .navbar {
            background-color: #2c3e50; /* Dark blue */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .nav-link:hover {
            color: #1abc9c !important; /* Teal */
        }

        /* Dashboard Card */
        .dashboard-card {
            max-width: 600px;
            margin: auto;
            margin-top: 50px;
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        /* Buttons */
        .btn-primary {
            background-color: #3498db; /* Blue */
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #2980b9; /* Darker Blue */
        }
        .btn-success {
            background-color: #1abc9c; /* Teal */
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-success:hover {
            background-color: #16a085; /* Darker Teal */
        }
        .btn-danger {
            background-color: #e74c3c; /* Red */
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-danger:hover {
            background-color: #c0392b; /* Darker Red */
        }

        /* Progress Bar */
        .progress {
            height: 20px;
            border-radius: 10px;
        }
        .progress-bar {
            background-color: #1abc9c; /* Teal */
        }

        /* Footer */
        .footer {
            background-color: #2c3e50; /* Dark Blue */
            color: white;
            padding: 40px 0;
            margin-top: 50px;
        }
        .footer a {
            color: #1abc9c; /* Teal */
            text-decoration: none;
        }
        .footer a:hover {
            color: #16a085; /* Darker Teal */
        }
        .footer h5 {
            color: #1abc9c; /* Teal */
            font-weight: bold;
        }
    </style>
</head>
<body>


<nav class="navbar navbar-expand-lg navbar-dark">
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
                    <a class="nav-link" href="ViewResults.jsp">Results</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="SubmitComplain.jsp">Submit Complain</a>
                </li>
            </ul>
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>
</nav>

<!-- Quick Links -->
<div class="container mt-4">
    <div class="row text-center">
        <div class="col-md-3">
            <a href="Library.jsp" class="btn btn-outline-primary w-100">📚 Library</a>
        </div>
        <div class="col-md-3">
            <a href="FeePayment.jsp" class="btn btn-outline-warning w-100">💳 Fee Payment</a>
        </div>
        <div class="col-md-3">
            <a href="studentDashboard.jsp" class="btn btn-outline-info w-100">👤 Profile</a>
        </div>
        <div class="col-md-3">
            <a href="HelpDesk.jsp" class="btn btn-outline-danger w-100">📞 Help Desk</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card shadow-lg p-4 text-center dashboard-card">
        <h2 class="mb-3">Welcome, <%= (studentName != null) ? studentName : "Guest" %>! 🎓</h2>
        <p class="fs-5"><strong>Email:</strong> <%= (studentEmail != null) ? studentEmail : "Not Provided" %></p>
        <p class="fs-5"><strong>Enrolled Course:</strong> <%= courseName %></p>
        
        <div class="mt-4">
            <a href="StudentViewExamTimetable.jsp" class="btn btn-primary me-2">View Exam Timetable</a>
            <a href="ViewResults.jsp" class="btn btn-success">View Results</a>
        </div>
    </div>
</div>

<!-- Upcoming Events & Notices -->
<div class="container mt-4">
    <div class="card shadow-lg p-4">
        <h4 class="text-center">📢 Upcoming Events & Notices</h4>
        <ul class="list-group list-group-flush">
            <li class="list-group-item">🗓 Mid-Semester Exams: March 15 - March 20</li>
            <li class="list-group-item">📢 Course Registration Deadline: March 10</li>
            <li class="list-group-item">🎓 Graduation Ceremony: June 25</li>
        </ul>
    </div>
</div>


<div class="container mt-4">
    <div class="card shadow-lg p-4">
        <h4 class="text-center">📊 Academic Progress</h4>
        <p><strong>GPA:</strong> 3.75 (Current Semester)</p>
        <p><strong>Registered Units:</strong> 6</p>
        <p><strong>Pending Assignments:</strong> 2</p>
        <div class="progress mt-3">
            <div class="progress-bar" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">75% Completed</div>
        </div>
    </div>
</div>

<!-- Latest University News -->
<div class="container mt-5">
    <div class="card shadow-lg p-4">
        <h4 class="text-center">📰 Latest University News</h4>
        <ul class="list-group list-group-flush">
            <li class="list-group-item">🎉 New Computer Lab Opening on March 12</li>
            <li class="list-group-item">💡 Research Grants Available for Final Year Students</li>
            <li class="list-group-item">🏆 Inter-University Sports Competition Begins Next Week</li>
        </ul>
    </div>
</div>

<!-- Student Testimonials -->
<div class="container mt-5">
    <div class="card shadow-lg p-4 text-center">
        <h4>💬 Student Testimonials</h4>
        <blockquote class="blockquote">
            <p>"This portal has made my academic journey seamless! Everything is at my fingertips."</p>
            <footer class="blockquote-footer">Alex Wanjala, Computer Science</footer>
        </blockquote>
        <blockquote class="blockquote">
            <p>"The best student dashboard ever! Easy access to all resources I need."</p>
            <footer class="blockquote-footer">Linda Atieno, Business Administration</footer>
        </blockquote>
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>