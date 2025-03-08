<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HomeMade University</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Custom Styles */
        body {
            background-color: lightgray;
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

        /* Hero Section */
        .hero-section {
            background: linear-gradient(to right, #3498db, #1abc9c); /* Blue to Teal */
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 3rem;
            font-weight: bold;
        }
        .hero-section .btn {
            background-color: #e74c3c; /* Red */
            border: none;
            padding: 10px 30px;
            font-size: 1.2rem;
            transition: background-color 0.3s ease;
        }
        .hero-section .btn:hover {
            background-color: #c0392b; /* Darker Red */
        }

        /* Course Cards */
        .course-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            background-color: #ffffff;
        }
        .course-card:hover {
            transform: translateY(-5px);
        }
        .course-card .btn {
            background-color: #3498db; /* Blue */
            border: none;
            transition: background-color 0.3s ease;
        }
        .course-card .btn:hover {
            background-color: #2980b9; /* Darker Blue */
        }

        /* Testimonials */
        .testimonial-card {
            background-color: #ecf0f1; /* Light Gray */
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .testimonial-card h6 {
            color: #2c3e50; /* Dark Blue */
            font-weight: bold;
        }

        /* FAQ Section */
        .accordion-button {
            background-color: #3498db; /* Blue */
            color: white;
            font-weight: bold;
        }
        .accordion-button:not(.collapsed) {
            background-color: #2980b9; /* Darker Blue */
        }
        .accordion-body {
            background-color: #ecf0f1; /* Light Gray */
        }

        /* Upcoming Events */
        .list-group-item {
            background-color: #ffffff;
            border: 1px solid #ddd;
            margin-bottom: 10px;
            border-radius: 5px;
        }
        .badge {
            background-color: #e74c3c; /* Red */
        }

        /* Footer */
        .footer {
            background-color: #2c3e50; /* Dark Blue */
            color: white;
            padding: 40px 0;
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
        .footer .input-group .btn {
            background-color: #e74c3c; /* Red */
            border: none;
        }
        .footer .input-group .btn:hover {
            background-color: #c0392b; /* Darker Red */
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">HomeMade University</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">  
                     <li class="nav-item">
                        <a class="nav-link" href="">About Us</a>
                    </li>
                     <li class="nav-item">
                        <a class="nav-link" href="">Contacts</a>
                    </li>
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

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <h1 class="display-4">Welcome to HomeMade University</h1>
            <p class="lead">Select and register for your desired courses with ease.</p>
            <a href="StudentRegistration.jsp" class="btn btn-light btn-lg">Get Started</a>
        </div>
    </div>

    <!-- Trending Courses Section -->
    <div class="container mt-5">
        <h2 class="text-center mb-4">Trending Courses</h2>
        <div id="trendingCoursesCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="card course-card text-center">
                        <div class="card-body">
                            <h5 class="card-title">Full Stack Web Development</h5>
                            <p class="card-text">Master React, Node.js, and MongoDB.</p>
                            <a href="#" class="btn btn-primary">Learn More</a>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="card course-card text-center">
                        <div class="card-body">
                            <h5 class="card-title">AI & Machine Learning</h5>
                            <p class="card-text">Dive into neural networks and deep learning.</p>
                            <a href="#" class="btn btn-primary">Learn More</a>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="card course-card text-center">
                        <div class="card-body">
                            <h5 class="card-title">Cybersecurity Fundamentals</h5>
                            <p class="card-text">Learn ethical hacking and security measures.</p>
                            <a href="#" class="btn btn-primary">Learn More</a>
                        </div>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#trendingCoursesCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#trendingCoursesCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </div>

    <!-- Course Listing Section -->
    <div class="container mt-5">
        <h2 class="text-center mb-4">Featured Courses</h2>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card course-card">
                    <div class="card-body">
                        <h5 class="card-title">Introduction to Computer Science</h5>
                        <p class="card-text">Learn the basics of programming, algorithms, and data structures.</p>
                        <a href="#" class="btn btn-primary">Enroll Now</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card course-card">
                    <div class="card-body">
                        <h5 class="card-title">Web Development Fundamentals</h5>
                        <p class="card-text">Master HTML, CSS, and JavaScript to build modern websites.</p>
                        <a href="#" class="btn btn-primary">Enroll Now</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card course-card">
                    <div class="card-body">
                        <h5 class="card-title">Data Science Essentials</h5>
                        <p class="card-text">Explore data analysis, machine learning, and visualization techniques.</p>
                        <a href="#" class="btn btn-primary">Enroll Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="container mt-5">
        <h2 class="text-center mb-4">Frequently Asked Questions</h2>
        <div class="accordion" id="faqAccordion">
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                        How do I enroll in a course?
                    </button>
                </h2>
                <div id="faq1" class="accordion-collapse collapse show">
                    <div class="accordion-body">
                        Simply click the "Enroll Now" button on your preferred course.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                        Are the courses free?
                    </button>
                </h2>
                <div id="faq2" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        Some courses are free, while others require a small fee.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                        Will I get a certificate after completion?
                    </button>
                </h2>
                <div id="faq3" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        Yes! A certificate is awarded upon successful course completion.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Student Testimonials Section -->
    <div class="container mt-5">
        <h2 class="text-center mb-4">What Our Students Say</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="card testimonial-card">
                    <div class="card-body">
                        <p>"This platform made learning so easy! The courses are well-structured and insightful."</p>
                        <h6>- Alex Mutuku</h6>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card testimonial-card">
                    <div class="card-body">
                        <p>"I landed my first job in tech thanks to these amazing courses!"</p>
                        <h6>- Linda Kamau</h6>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card testimonial-card">
                    <div class="card-body">
                        <p>"Interactive, engaging, and career-transforming. Highly recommended!"</p>
                        <h6>- Brian Otieno</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Upcoming Events Section -->
    <div class="container mt-5">
        <h2 class="text-center mb-4">Upcoming Events & Webinars</h2>
        <ul class="list-group">
            <li class="list-group-item">
                <strong>Live Coding Bootcamp</strong> - March 15, 2025
                <span class="badge bg-primary float-end">Register</span>
            </li>
            <li class="list-group-item">
                <strong>Data Science Workshop</strong> - March 22, 2025
                <span class="badge bg-primary float-end">Register</span>
            </li>
            <li class="list-group-item">
                <strong>Career Growth in Tech</strong> - March 30, 2025
                <span class="badge bg-primary float-end">Register</span>
            </li>
        </ul>
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

    <!-- Bootstrap Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>