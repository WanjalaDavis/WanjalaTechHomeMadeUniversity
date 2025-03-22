<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession, jakarta.servlet.http.HttpServletRequest, jakarta.servlet.http.HttpServletResponse" %>


<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("studentId") == null) {
        response.sendRedirect("LoginPage.jsp");
        return;
    }

    int studentId = (int) sessionUser.getAttribute("studentId");
    int examTimetableId = Integer.parseInt(request.getParameter("exam_timetable_id"));
    int seatNumber = Integer.parseInt(request.getParameter("seat_number"));

    Connection con = null;
    PreparedStatement checkPst = null, insertPst = null;
    ResultSet checkRs = null;

    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "root", "");

        // Check if the seat is already booked
        String checkQuery = "SELECT * FROM booked_seats WHERE exam_timetable_id = ? AND seat_number = ?";
        checkPst = con.prepareStatement(checkQuery);
        checkPst.setInt(1, examTimetableId);
        checkPst.setInt(2, seatNumber);
        checkRs = checkPst.executeQuery();

        if (checkRs.next()) {
            out.println("<script>alert('Seat already booked. Please choose another.'); window.location='BookExamSeat.jsp';</script>");
        } else {
            // Insert booking
            String insertQuery = "INSERT INTO booked_seats (student_id, exam_timetable_id, seat_number) VALUES (?, ?, ?)";
            insertPst = con.prepareStatement(insertQuery);
            insertPst.setInt(1, studentId);
            insertPst.setInt(2, examTimetableId);
            insertPst.setInt(3, seatNumber);
            insertPst.executeUpdate();

            out.println("<script>alert('Seat booked successfully!'); window.location='BookExamSeat.jsp';</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (checkRs != null) checkRs.close();
        if (checkPst != null) checkPst.close();
        if (insertPst != null) insertPst.close();
        if (con != null) con.close();
    }
%>
