<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<style>
    /* Custom Styles */
    body {
        background-color: lightgray;
        font-family: 'Arial', sans-serif;
        color: #333;
        margin: 0;
        padding: 0;
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

    .login-container {
        min-height: 80vh; /* Reduced height to reduce space */
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px 0; /* Reduced padding */
    }

    .login-card {
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        width: 100%; /* Full width */
    }

    .login-image {
        background: url('WhatsApp Image 2025-02-05 at 9.54.26 AM.jpeg') no-repeat center center;
        background-size: cover;
        height: 100%; /* Full height */
    }

    .form-container {
        padding: 30px; /* Reduced padding */
    }

    .btn-primary {
        background-color: #007bff;
        border: none;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }
</style>

<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">HomeMade University</a>
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
                <form class="d-flex">
                    <input class="form-control me-2 search-bar" type="search" placeholder="Search courses..." aria-label="Search">
                    <button class="btn btn-light" type="submit">Search</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container login-container">
        <div class="row w-100">
            <div class="col-lg-7 d-none d-lg-block login-image"></div> <!-- Increased column width for image -->
            <div class="col-lg-5 col-md-8 mx-auto">
                <div class="card login-card">
                    <div class="card-body form-container">
                        <!-- Display error messages -->
                        <% 
                            String error = request.getParameter("error");
                            if (error != null) { 
                        %>
                            <div class="alert alert-danger text-center"><%= error %></div>
                        <% } %>

                        <h2 class="text-center mb-4">User Login</h2>                         
                        <form action="authenticate.jsp" method="post">
                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>             

    <!-- Bootstrap 5 Footer -->
    <footer class="bg-dark text-white pt-5 pb-4">
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
                            <input type="email" class="form-control" placeholder="Your Email">
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