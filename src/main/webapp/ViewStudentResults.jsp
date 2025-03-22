<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.HashSet, java.util.Set" %>
<%
    // Ensure the user is logged in as a Lecturer
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
    <title>View Student Results</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table thead { background-color: #007bff; color: white; }
    </style>    
    
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="  Lecture.jsp">HomeMade University</a>
            <span class="navbar-text text-white">Welcome, <%= fullName %> (Staff No: <%= staffNo %>)</span>
            <a href="logout.jsp" class="btn btn-danger btn-sm">Logout <i class="fas fa-sign-out-alt"></i></a>
        </div>
    </nav>
</head>
<body>
    <div class="container mt-5">
        <h4 class="mb-4">Student Results</h4>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Email</th>
                    <th>Course Name</th>
                    <th>Unit Name</th>
                    <th>Cat</th>
                    <th>Exam</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    Set<String> displayedEmails = new HashSet<>();
                    Set<String> displayedCourses = new HashSet<>();

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

                        String query = "SELECT r.id, r.student_email, c.course_name, u.unit_name, r.coursework, r.exam, r.total " +
                                       "FROM results r " +
                                       "JOIN course c ON r.course_id = c.id " +
                                       "JOIN course_units u ON r.unit_id = u.id";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            String email = rs.getString("student_email");
                            String course = rs.getString("course_name");
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= displayedEmails.add(email) ? email : "" %></td>
                    <td><%= displayedCourses.add(course) ? course : "" %></td>
                    <td><%= rs.getString("unit_name") %></td>
                    <td><%= rs.getInt("coursework") %></td>
                    <td><%= rs.getInt("exam") %></td>
                    <td><%= rs.getInt("total") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error loading results: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    }
                %>
            </tbody>
        </table>
    </div>



    <!-- Footer -->
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
</body>
</html>