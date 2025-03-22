<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    
    String userRole = (String) session.getAttribute("userRole");
    String fullName = (String) session.getAttribute("fullName");
    String staffNo = (String) session.getAttribute("staffNo");

    if (userRole == null || !"lecturer".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Access Denied. Please log in as a Lecturer.");
        return;
    }

    %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lecturer Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
</head>
<body>

   
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">HomeMade University</a>
            <span class="navbar-text text-white">Welcome, <%= fullName %> (Staff No: <%= staffNo %>)</span>
            <a href="logout.jsp" class="btn btn-danger btn-sm">Logout <i class="fas fa-sign-out-alt"></i></a>
        </div>
    </nav>

   
    <div class="container mt-5">
        <div class="row">
            <!-- Profile Card -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-lg">
                    <div class="card-body text-center">
                        <h4 class="card-title">Profile</h4>
                        <p><strong>Name:</strong> <%= fullName %></p>
                        <p><strong>Staff No:</strong> <%= staffNo %></p>
                        <p><strong>Role:</strong> Lecturer</p>
                    </div>
                </div>
            </div>

           
                        
            <div class="col-md-8">
                <div class="card shadow-lg">
                    <div class="card-body">
                        <h4 class="card-title">Actions</h4>
                        <ul class="list-group">
                            
                            <li class="list-group-item">
                                <a href="CourseTeach.jsp"><i class="fas fa-book me-2"></i>Register a Course to Teach</a>
                            </li>                
                                                     
                            <li class="list-group-item">
                                <a href="viewCourseStudents.jsp"><i class="fas fa-users me-2"></i>View Students Registered for the Course</a>
                            </li>
                             <li class="list-group-item">
                                <a href="ViewStudentResults.jsp"><i class="fas fa-eye me-2"></i>View Student Results</a>
                            </li>
                            <li class="list-group-item">
                                <a href="ViewComplain.jsp"><i class="fas fa-eye me-2"></i>View Student Complain</a>
                            </li>
                            <li class="list-group-item">
                                <a href="StudentViewExamTimetable.jsp"><i class="fas fa-calendar-alt me-2"></i>View Exam/Test Timetable</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <div class="card shadow-lg mt-4">
        <div class="card-body">
            <h4 class="card-title">Taught Course</h4>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

                           
                            String query = "SELECT c.id, c.course_name FROM course c " +
                                           "WHERE c.id IN (SELECT courseId FROM assigned_courses WHERE staffNo = ?)";

                            ps = con.prepareStatement(query);
                            ps.setString(1, staffNo);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                                int courseId = rs.getInt("id");
                    %>
                    <tr>
                        <td><%= courseId %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><a href="?courseId=<%= courseId %>&staffNo=<%= staffNo %>" class="btn btn-primary">View Units</a></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='3'>Error loading courses: " + e.getMessage() + "</td></tr>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (con != null) con.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

   <%
    String courseId = request.getParameter("courseId");
    if (courseId != null) {
%>
<div class="card shadow-lg mt-4">
    <div class="card-body">
        <h4 class="card-title">Course Units</h4>
        <form method="POST" action="register_unit.jsp">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Select</th>
                        <th>Unit Code</th>
                        <th>Unit Name</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

                            // Query to get course units for the selected course
                            String query = "SELECT id, unit_code, unit_name FROM course_units WHERE course_id = ?";
                            ps = con.prepareStatement(query);
                            ps.setString(1, courseId);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                String unitId = rs.getString("id");
                                String unitCode = rs.getString("unit_code");
                    %>
                    <tr>
                        <td>
                            <input type="radio" name="unit_id" value="<%= unitId %>" required>
                        </td>
                        <td><%= unitCode %></td>
                        <td><%= rs.getString("unit_name") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='3'>Error loading units: " + e.getMessage() + "</td></tr>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (con != null) con.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </tbody>
            </table>
            <input type="hidden" name="staffNo" value="<%= staffNo %>">
            <button type="submit" class="btn btn-success mt-2">Register Selected Unit</button>
        </form>
    </div>
</div>
<%
    }
%>


   
    <div class="card shadow-lg mt-4">
        <div class="card-body">
            <h4 class="card-title">Upload Course Material</h4>
            <form action="uploadMaterial.jsp" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">Select File:</label>
                    <input type="file" class="form-control" name="file">
                </div>
                <div class="mb-3">
                    <label class="form-label">Course Code:</label>
                    <input type="text" class="form-control" name="courseCode" required>
                </div>
                <button type="submit" class="btn btn-success">Upload</button>
            </form>
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
                            <input type="email" class="form-control" placeholder="Your Email" aria-label="wanjaladevis81@gmail.com">
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