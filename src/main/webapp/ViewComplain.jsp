<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Check if the user is a lecturer
    String userRole = (String) session.getAttribute("userRole");
    String fullName = (String) session.getAttribute("fullName");
    String staffNo = (String) session.getAttribute("staffNo"); 

    if (userRole == null || !"lecturer".equals(userRole)) {
        response.sendRedirect("LoginPage.jsp?error=Access Denied. Please log in as a Lecturer.");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int staffId = -1; // Default value to avoid query issues

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");

        // Retrieve staffId using staffNo
        String staffQuery = "SELECT staffId FROM staff WHERE staffNo = ?";
        ps = con.prepareStatement(staffQuery);
        ps.setString(1, staffNo);
        rs = ps.executeQuery();

        if (rs.next()) {
            staffId = rs.getInt("staffId");
        } else {
            out.println("<div class='alert alert-danger'>Staff ID not found for your account.</div>");
            return;
        }

        // Close previous statement
        rs.close();
        ps.close();
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>Database Error: " + e.getMessage() + "</div>");
        return;
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Unexpected Error: " + e.getMessage() + "</div>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Complaints</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
        .card { border: none; border-radius: 10px; transition: transform 0.2s; }
        .card:hover { transform: translateY(-5px); }
        .table thead { background-color: #007bff; color: white; }
        .table tbody tr:hover { background-color: #f1f1f1; }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="  Lecture.jsp">HomeMade University</a>
            <span class="navbar-text text-white">Welcome, <%= fullName %> (Staff No: <%= staffNo %>)</span>
            <a href="logout.jsp" class="btn btn-danger btn-sm">Logout <i class="fas fa-sign-out-alt"></i></a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-5">
        <h2 class="mb-4 text-center">Student Complaints</h2>
        <div class="card shadow-lg">
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Complaint ID</th>
                            <th>Student Name</th>
                            <th>Email</th>
                            <th>Complaint</th>
                        
                        </tr>                        
                        
                    </thead>
                    <tbody>
                        <%
                            PreparedStatement complaintPs = null;
                            ResultSet complaintRs = null;
                            boolean hasComplaints = false;

                            try {
                                // Query to fetch complaints assigned to the lecturer
                                String complaintQuery = "SELECT complaintId, name, email, complaint FROM complaints WHERE staffId = ?";
                                complaintPs = con.prepareStatement(complaintQuery);
                                complaintPs.setInt(1, staffId);
                                complaintRs = complaintPs.executeQuery();

                                while (complaintRs.next()) {
                                    hasComplaints = true;
                        %>
                     <tr>
                               <td><%= complaintRs.getInt("complaintId") %></td>
                                <td><%= complaintRs.getString("name") %></td>
                                <td><%= complaintRs.getString("email") %></td>
                                <td><%= complaintRs.getString("complaint") %></td>
                                                              
                                
                            </tr>

                        <%
                                }

                                // If no complaints found, show a message
                                if (!hasComplaints) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center text-muted">No complaints assigned to you.</td>
                        </tr>
                        <%
                                }
                            } catch (SQLException e) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center text-danger">Database Error: <%= e.getMessage() %></td>
                        </tr>
                        <%
                            } finally {
                                try {
                                    if (complaintRs != null) complaintRs.close();
                                    if (complaintPs != null) complaintPs.close();
                                    if (con != null) con.close();
                                } catch (SQLException e) {
                                    out.println("<div class='alert alert-warning'>Database closing error: " + e.getMessage() + "</div>");
                                }
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


</body>
</html>
