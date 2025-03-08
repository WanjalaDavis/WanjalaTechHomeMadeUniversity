<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Create Student Course</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
     
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
   <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="adminDashboard.jsp">Admin Dashboard</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ViewExamTimetable.jsp">Exam Timetable</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="EnterMarksStudents.jsp">Enter Marks for Students</a>
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
            <div class="card-body">
                <h2 class="text-center mb-4">Create Student Course</h2>
                <form action="CourseServlet" method="post">
                    <div class="mb-3">
                        <label for="courseName" class="form-label">Course Name</label>
                        <input type="text" class="form-control" id="courseName" name="courseName" required>
                    </div>

                    <div id="units-container">
                        <div class="row mb-3 unit-group">
                            <div class="col-md-5">
                                <input type="text" class="form-control" name="unitNames[]" placeholder="Unit Name" required>
                            </div>
                            <div class="col-md-5">
                                <input type="text" class="form-control" name="unitCodes[]" placeholder="Unit Code" required>
                            </div>
                            <div class="col-md-2 text-center">
                                <button type="button" class="btn btn-danger remove-unit">Remove</button>
                            </div>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-primary" id="addUnit">Add Unit</button>
                    <button type="submit" class="btn btn-success">Save Course</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.getElementById("addUnit").addEventListener("click", function () {
            let unitContainer = document.getElementById("units-container");
            let newUnit = document.createElement("div");
            newUnit.classList.add("row", "mb-3", "unit-group");
            newUnit.innerHTML = `
                <div class="col-md-5">
                    <input type="text" class="form-control" name="unitNames[]" placeholder="Unit Name" required>
                </div>
                <div class="col-md-5">
                    <input type="text" class="form-control" name="unitCodes[]" placeholder="Unit Code" required>
                </div>
                <div class="col-md-2 text-center">
                    <button type="button" class="btn btn-danger remove-unit">Remove</button>
                </div>
            `;
            unitContainer.appendChild(newUnit);
            
            newUnit.querySelector(".remove-unit").addEventListener("click", function () {
                newUnit.remove();
            });
        });

        document.querySelectorAll(".remove-unit").forEach(button => {
            button.addEventListener("click", function () {
                button.parentElement.parentElement.remove();
            });
        });
    </script>
    
    
                         
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