<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register Student</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .navbar {
            background-color: #007bff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .alert {
            border-radius: 8px;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .container {
            margin-top: 50px;
        }
        .card-body {
            padding: 40px;
        }
        .text-center {
            text-align: center;
        }
        .footer {
            background-color: #343a40;
            color: white;
            padding: 20px 0;
            text-align: center;
            margin-top: 50px;
        }
        .footer a {
            color: #007bff;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Header (Navbar) -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">HomeMade University</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="StudentRegistration.jsp">Register</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LoginPage.jsp">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="card shadow-lg">
            <div class="card-body text-center">
                <h2 class="mb-4">Student Registration Status</h2>
                <% 
                    String fullName = request.getParameter("full_name");
                    String email = request.getParameter("email");
                    String regNo = request.getParameter("reg_no");
                    String dob = request.getParameter("dob");
                    String nationality = request.getParameter("nationality");
                    String courseId = request.getParameter("course_id");
                    
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
                        
                        String sql = "INSERT INTO students (full_name, email, reg_no, dob, nationality, course_id) VALUES (?, ?, ?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, fullName);
                        pstmt.setString(2, email);
                        pstmt.setString(3, regNo);
                        pstmt.setString(4, dob);
                        pstmt.setString(5, nationality);
                        pstmt.setInt(6, Integer.parseInt(courseId));
                        
                        int rowsInserted = pstmt.executeUpdate();
                        if (rowsInserted > 0) {
                %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Registration Successful!
                </div>
                <% 
                        } else {
                %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Registration Failed. Please try again.
                </div>
                <% 
                        }
                    } catch (Exception e) {
                %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Error: <%= e.getMessage() %>
                </div>
                <% 
                    } finally {
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
                <a href="StudentRegistration.jsp" class="btn btn-primary mt-3">
                    <i class="fas fa-arrow-left"></i> Back to Registration
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2023 HomeMade University. All rights reserved.</p>
            <p><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
        </div>
    </footer>

    <!-- Bootstrap Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>