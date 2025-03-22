<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("LoginPage.jsp?error=Please login first.");
        return;
    }

   
    String adminUsername = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (adminUsername == null || !"admin".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Unauthorized access!");
        return;
    }

  
    String url = "jdbc:mysql://localhost:3306/Managementdb"; 
    String dbUser = "root";  
    String dbPass = "";      

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    int studentCount = 0, courseCount = 0, lecturerCount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
        stmt = conn.createStatement();

       
        rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM students");
        if (rs.next()) studentCount = rs.getInt("total");

       
        rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM course");
        if (rs.next()) courseCount = rs.getInt("total");

        
        rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM staff WHERE rank = 'Lecturer'");
        if (rs.next()) lecturerCount = rs.getInt("total");

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
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .card {
            margin-bottom: 20px;
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .card-text {
            font-size: 2rem;
        }
        .btn-outline-primary, .btn-outline-success, .btn-outline-danger {
            margin: 5px;
        }
        .recent-activities, .upcoming-exams, .system-notifications {
            margin-top: 30px;
        }
        .list-group-item {
            border: none;
            margin-bottom: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>


<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Admin Portal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ViewExamTimetable.jsp">Exam Timetable</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="manageStudents.jsp">Manage Students</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="manageCourses.jsp">Manage Courses</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="manageStaff.jsp">Manage Staff</a>
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
    <div class="card shadow-lg">
        <div class="card-body text-center">
            <h2 class="mb-4">Welcome, Admin!</h2>

            <!-- Quick Stats -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card text-white bg-primary mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Total Students</h5>
                            <p class="card-text fs-3"><%= studentCount %></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Total Courses</h5>
                            <p class="card-text fs-3"><%= courseCount %></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-danger mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Total Lecturers</h5>
                            <p class="card-text fs-3"><%= lecturerCount %></p>
                        </div>
                    </div>
                </div>
            </div>

            
            <div class="mt-4">
                <a href="manageStudents.jsp" class="btn btn-outline-primary">Manage Students</a>
                <a href="manageCourses.jsp" class="btn btn-outline-success">Manage Courses</a>
                <a href="manageStaff.jsp" class="btn btn-outline-danger">Manage Staff</a>
            </div>

            <div class="recent-activities mt-5">
                <h4>Recent Activities</h4>
                <ul class="list-group">
                    <li class="list-group-item">Added a new student: Gloria Susan</li>
                    <li class="list-group-item">Updated course: Java Programming</li>
                    <li class="list-group-item">Assigned lecturer: Dr. Moureen Nekoye to Course ID 101</li>
                </ul>
            </div>

         
            <div class="upcoming-exams mt-5">
                <h4>Upcoming Exams</h4>
                <ul class="list-group">
                    <li class="list-group-item">Java Programming - 2025-04-15 - Room 101</li>
                    <li class="list-group-item">Database Systems - 2025-04-20 - Room 202</li>
                    <li class="list-group-item">Web Development - 2025-04-25 - Room 303</li>
                </ul>
            </div>

            
            <div class="system-notifications mt-5">
                <h4>System Notifications</h4>
                <ul class="list-group">
                    <li class="list-group-item">New student registrations pending approval.</li>
                    <li class="list-group-item">Course timetable update required.</li>
                    <li class="list-group-item">System maintenance scheduled for 2023-10-30.</li>
                </ul>
            </div>

           
            <div class="mt-4">
                <a href="logout.jsp" class="btn btn-danger">Logout</a>
            </div>
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

            
            <div class="col-md-3 col-sm-6 mb-4">
                <h5 class="text-uppercase mb-4">Follow Us</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-facebook-f me-2"></i>Facebook</a></li>
                    <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-twitter me-2"></i>Twitter</a></li>
                    <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-instagram me-2"></i>Instagram</a></li>
                    <li><a href="#" class="text-white text-decoration-none"><i class="fab fa-linkedin-in me-2"></i>LinkedIn</a></li>
                </ul>
            </div>

           
            <div class="col-md-3 col-sm-6 mb-4">
                <h5 class="text-uppercase mb-4">Newsletter</h5>
                <p>Subscribe to our newsletter for the latest updates.</p>
                <form>
                    <div class="input-group">
                        <input type="email" class="form-control" placeholder="Your Email" aria-label="Your Email">
                        <button class="btn btn-primary" type="button">Subscribe</button>
                    </div>
                </form>
            </div>
        </div>

       
        <div class="row mt-4">
            <div class="col-12 text-center">
                <p class="mb-0">&copy; 2025 WanjalaTech. All Rights Reserved.</p>
            </div>
        </div>
    </div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<script src="https://kit.fontawesome.com/a076d05399.js"></script>

</body>
</html>