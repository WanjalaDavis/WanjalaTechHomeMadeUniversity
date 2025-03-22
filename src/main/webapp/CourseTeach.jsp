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
    <title>Register Course</title>
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
        <div class="card shadow-lg">
            <div class="card-body">
                <h3 class="text-center">Register a Course to Teach</h3>

                <!-- Display error or success messages -->
                <% 
                    String message = request.getParameter("message");
                    if (message != null) { 
                %>
                    <div class="alert alert-success text-center"><%= message %></div>
                <% } %>

                <!-- Course Registration Form -->
                <form action="registerCourse.jsp" method="post">
                    <div class="mb-3">
                        <label class="form-label">Select Course</label>
                        <select class="form-control" name="course_id" required>
                            <option value="">-- Choose a Course --</option>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection(url, dbUser, dbPass);
                                    stmt = conn.prepareStatement("SELECT id, course_name FROM course");
                                    rs = stmt.executeQuery();

                                    while (rs.next()) {
                                        String courseId = rs.getString("id");
                                        String courseName = rs.getString("course_name");
                            %>
                                        <option value="<%= courseId %>"><%= courseName %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </select>
                    </div>

                    <input type="hidden" name="staffNo" value="<%= staffNo %>">
                    
                    <button type="submit" class="btn btn-primary w-100">Register Course</button>
                </form>
            </div>
        </div>

        <div class="card mt-4 shadow-lg">
            <div class="card-body">
                <h4>Courses You Are Teaching</h4>
                <ul class="list-group">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(url, dbUser, dbPass);
                            stmt = conn.prepareStatement("SELECT c.course_name FROM course c INNER JOIN assigned_courses ac ON c.id = ac.courseId WHERE ac.staffNo = ?");
                            stmt.setString(1, staffNo);
                            rs = stmt.executeQuery();

                            boolean hasCourses = false;
                            while (rs.next()) {
                                hasCourses = true;
                    %>
                                <li class="list-group-item"><%= rs.getString("course_name") %></li>
                    <%
                            }

                            if (!hasCourses) {
                    %>
                                <li class="list-group-item text-danger">You have not registered for any courses yet.</li>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </ul>
            </div>
        </div>
    </div>
                
    <footer class="bg-dark text-white pt-5 pb-4 mt-5">
        <div class="container">
            <div class="row">
               
                
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