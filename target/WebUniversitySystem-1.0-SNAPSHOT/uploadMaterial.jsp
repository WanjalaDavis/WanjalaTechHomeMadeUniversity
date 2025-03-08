<%@ page import="java.io.*, java.sql.*" %>
<%
    String courseCode = request.getParameter("courseCode");
    Part filePart = request.getPart("file");
    String fileName = filePart.getSubmittedFileName();

    if (fileName != null && !fileName.isEmpty()) {
        String uploadPath = application.getRealPath("") + File.separator + "uploads";
        File fileUploadDir = new File(uploadPath);
        if (!fileUploadDir.exists()) {
            fileUploadDir.mkdir();
        }
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Managementdb", "root", "");
            PreparedStatement ps = con.prepareStatement("INSERT INTO CourseMaterials (courseCode, fileName, filePath) VALUES (?, ?, ?)");
            ps.setString(1, courseCode);
            ps.setString(2, fileName);
            ps.setString(3, filePath);
            ps.executeUpdate();
            out.println("File uploaded successfully!");
        } catch (SQLException e) {
            out.println("Upload failed.");
        }
    } else {
        out.println("Please select a file.");
    }
%>
