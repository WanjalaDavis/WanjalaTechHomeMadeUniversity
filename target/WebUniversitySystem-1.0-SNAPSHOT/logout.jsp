<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate the session
    session.invalidate();

    // Redirect to login page with a logout message
    response.sendRedirect("LoginPage.jsp?message=You have been logged out successfully.");
%>
