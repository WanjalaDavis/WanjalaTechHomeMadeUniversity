<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
</head>
<body>

<div class="container">
    <h2 class="text-center text-primary">Submit a Complaint</h2>
    
    <form action="SubmitComplain.jsp" method="post">
        <div class="mb-3">
            <label for="name" class="form-label">Your Name:</label>
            <input type="text" class="form-control" name="name" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Your Email:</label>
            <input type="email" class="form-control" name="email" required>
        </div>

        <div class="mb-3">
            <label for="lecturer" class="form-label">Select Lecturer:</label>
            <select class="form-select" name="staffId" required>
                <option value="">-- Select Lecturer --</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT staffId, name FROM staff WHERE rank = 'Lecturer'");

                        while (rs.next()) {
                            String staffId = rs.getString("staffId");
                            String lecturerName = rs.getString("name");
                            out.println("<option value='" + staffId + "'>" + lecturerName + "</option>");
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<option>Error fetching lecturers</option>");
                    }
                %>
            </select>
        </div>

        <div class="mb-3">
            <label for="complaint" class="form-label">Your Complaint:</label>
            <textarea class="form-control" name="complaint" rows="4" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary w-100">Submit Complaint</button>
    </form>

    <%
        // Handling form submission
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String staffId = request.getParameter("staffId");
            String complaint = request.getParameter("complaint");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
                PreparedStatement ps = con.prepareStatement("INSERT INTO complaints (name, email, staffId, complaint) VALUES (?, ?, ?, ?)");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, staffId);
                ps.setString(4, complaint);

                int result = ps.executeUpdate();
                if (result > 0) {
    %>
                    <div class="alert alert-success mt-3">Complaint submitted successfully!</div>
    <%
                } else {
    %>
                    <div class="alert alert-danger mt-3">Error submitting complaint.</div>
    <%
                }
                con.close();
            } catch (Exception e) {
    %>
                <div class="alert alert-danger mt-3">Error: <%= e.getMessage() %></div>
    <%
            }
        }
    %>
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
