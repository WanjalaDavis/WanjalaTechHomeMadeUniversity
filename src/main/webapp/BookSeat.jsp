<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
  
    String studentName = (String) session.getAttribute("fullName");
    String studentEmail = (String) session.getAttribute("email");

    String url = "jdbc:mysql://localhost:3306/Managementdb";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement stmt1 = null, stmt2 = null, stmt3 = null, checkStmt = null, bookedSeatsStmt = null, studentBookingCheckStmt = null;
    ResultSet rs1 = null, rs2 = null, duplicateResult = null, bookedSeatsResult = null, studentBookingResult = null;
    String courseName = "Not Assigned";
    String message = null;

    try {
       
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

       
        String sql1 = "SELECT c.course_name FROM students s JOIN course c ON s.course_id = c.id WHERE s.email = ?";
        stmt1 = conn.prepareStatement(sql1);
        stmt1.setString(1, studentEmail);
        rs1 = stmt1.executeQuery();

        if (rs1.next()) {
            courseName = rs1.getString("course_name");
        }

        String sql2 = "SELECT et.course_id, et.course_unit, et.exam_date, et.venue, et.room_capacity " +
                      "FROM exam_timetable et " +
                      "WHERE et.course_id = (SELECT course_id FROM students WHERE email = ?) " +
                      "AND et.exam_date >= CURDATE()";
        stmt2 = conn.prepareStatement(sql2);
        stmt2.setString(1, studentEmail);
        rs2 = stmt2.executeQuery();

        
        if (request.getParameter("bookSeat") != null) {
            String courseUnit = request.getParameter("course_unit");
            String venue = request.getParameter("venue");
            String examDate = request.getParameter("exam_date");
            int seatNumber = Integer.parseInt(request.getParameter("seat_number"));

            
            String studentBookingCheckSQL = "SELECT * FROM booked_seats WHERE email = ? AND course_unit = ?";
            studentBookingCheckStmt = conn.prepareStatement(studentBookingCheckSQL);
            studentBookingCheckStmt.setString(1, studentEmail);
            studentBookingCheckStmt.setString(2, courseUnit);
            studentBookingResult = studentBookingCheckStmt.executeQuery();

            if (studentBookingResult.next()) {
                message = "You have already booked a seat for this course unit. Only one booking per course unit is allowed.";
            } else {
                
                String seatCheckSQL = "SELECT * FROM booked_seats WHERE course_unit = ? AND exam_date = ? AND venue = ? AND seat_number = ?";
                checkStmt = conn.prepareStatement(seatCheckSQL);
                checkStmt.setString(1, courseUnit);
                checkStmt.setString(2, examDate);
                checkStmt.setString(3, venue);
                checkStmt.setInt(4, seatNumber);
                duplicateResult = checkStmt.executeQuery();

                if (duplicateResult.next()) {
                    message = "This seat has already been booked by another student. Please choose a different seat.";
                } else {
                    
                    String sql3 = "INSERT INTO booked_seats (email, course_unit, exam_date, venue, seat_number) VALUES (?, ?, ?, ?, ?)";
                    stmt3 = conn.prepareStatement(sql3);
                    stmt3.setString(1, studentEmail);
                    stmt3.setString(2, courseUnit);
                    stmt3.setString(3, examDate);
                    stmt3.setString(4, venue);
                    stmt3.setInt(5, seatNumber);

                    int result = stmt3.executeUpdate();
                    message = (result > 0) ? "Seat successfully booked!" : "Error booking seat. Please try again.";
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Book Exam Seat</title>
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
        .table-container {
            margin-top: 50px;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .alert {
            margin-top: 20px;
        }
        footer {
            margin-top: 50px;
        }
    </style>
</head>
<body>


<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
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
                    <a class="nav-link active" href="BookSeat.jsp">Book Seat</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="StudentViewExamTimetable.jsp">Exam Timetable</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ViewResults.jsp">Results</a>
                </li>
            </ul>
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>
</nav>


<div class="container table-container">
    <h2 class="text-center mb-4">Book Exam Seat</h2>
    <div class="text-center mb-4">
        <p><strong>Student Name:</strong> <%= (studentName != null) ? studentName : "Guest" %></p>
        <p><strong>Email:</strong> <%= (studentEmail != null) ? studentEmail : "Not Provided" %></p>
        <p><strong>Course:</strong> <%= courseName %></p>
    </div>

    <% if (message != null) { %>
        <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %>">
            <%= message %>
        </div>
    <% } %>

    <table class="table table-bordered table-striped mt-4">
        <thead class="table-dark">
            <tr>
                <th>Course Unit</th>
                <th>Exam Date</th>
                <th>Venue</th>
                <th>Room Capacity</th>
                <th>Booked Seats</th>
                <th>Book Seat</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (rs2 != null) {
                    boolean hasSeats = false;
                    while (rs2.next()) {
                        hasSeats = true;
                        String courseUnit = rs2.getString("course_unit");
                        Date examDate = rs2.getDate("exam_date");
                        String venue = rs2.getString("venue");
                        int roomCapacity = rs2.getInt("room_capacity");

                        // Query to fetch booked seat numbers
                        String bookedSeatsQuery = "SELECT seat_number FROM booked_seats WHERE course_unit = ? AND exam_date = ? AND venue = ?";
                        bookedSeatsStmt = conn.prepareStatement(bookedSeatsQuery);
                        bookedSeatsStmt.setString(1, courseUnit);
                        bookedSeatsStmt.setDate(2, examDate);
                        bookedSeatsStmt.setString(3, venue);
                        bookedSeatsResult = bookedSeatsStmt.executeQuery();

                        StringBuilder bookedSeatsList = new StringBuilder();
                        while (bookedSeatsResult.next()) {
                            bookedSeatsList.append(bookedSeatsResult.getInt("seat_number")).append(", ");
                        }
                        if (bookedSeatsList.length() > 0) {
                            bookedSeatsList.setLength(bookedSeatsList.length() - 2); // Remove trailing comma
                        }
            %>
            <tr>
                <td><%= courseUnit %></td>
                <td><%= examDate %></td>
                <td><%= venue %></td>
                <td><%= roomCapacity %></td>
                <td><%= bookedSeatsList.toString() %></td>
                <td>
                    <form method="post">
                        <input type="hidden" name="course_unit" value="<%= courseUnit %>">
                        <input type="hidden" name="venue" value="<%= venue %>">
                        <input type="hidden" name="exam_date" value="<%= examDate %>">
                        <div class="form-group">
                            <label for="seat_number">Seat Number (1 to <%= roomCapacity %>)</label>
                            <input type="number" id="seat_number" name="seat_number" class="form-control" min="1" max="<%= roomCapacity %>" required>
                        </div>
                        <button type="submit" name="bookSeat" class="btn btn-success mt-2">Book</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    if (!hasSeats) {
            %>
            <tr>
                <td colspan="6" class="text-center">No available exam seats for your course.</td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
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


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

<%
    
    try {
        if (rs1 != null) rs1.close();
        if (rs2 != null) rs2.close();
        if (bookedSeatsResult != null) bookedSeatsResult.close();
        if (bookedSeatsStmt != null) bookedSeatsStmt.close();
        if (stmt1 != null) stmt1.close();
        if (stmt2 != null) stmt2.close();
        if (stmt3 != null) stmt3.close();
        if (checkStmt != null) checkStmt.close();
        if (studentBookingCheckStmt != null) studentBookingCheckStmt.close();
        if (studentBookingResult != null) studentBookingResult.close();
        if (conn != null) conn.close();
    } catch (SQLException ignored) {}
%>