<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String course = request.getParameter("course_interest");
        String source = request.getParameter("source");
        int assignedTo = Integer.parseInt(request.getParameter("assigned_to"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO enquiries (name, contact, course_interest, source, assigned_to) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, contact);
            stmt.setString(3, course);
            stmt.setString(4, source);
            stmt.setInt(5, assignedTo);

            int rows = stmt.executeUpdate();
            message = (rows > 0) ? "Enquiry submitted successfully!" : "Failed to submit enquiry.";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>New Enquiry - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f9fafb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-container {
            max-width: 700px;
            margin: 80px auto;
        }
        .card-custom {
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            background-color: #ffffff;
        }
        .card-body {
            padding: 40px;
        }
        .form-group label {
            font-weight: 500;
        }
        .btn-soft {
            border-radius: 30px;
            padding: 10px 20px;
            transition: 0.3s;
            color: white;
            background-color: #0d6efd;
            border: none;
        }
        .btn-soft:hover {
            transform: scale(1.05);
            background-color: #0b5ed7;
        }
        .alert {
            border-radius: 10px;
        }
    </style>
</head>
<body>

<div class="container form-container">
    <div class="card card-custom">
        <div class="card-body">
            <h3 class="text-center mb-4">New Student Enquiry</h3>

            <% if (message != null) { %>
                <div class="alert alert-info text-center"><%= message %></div>
            <% } %>

            <form method="post" action="">
                <div class="form-group mb-3">
                    <label>Student Name</label>
                    <input type="text" name="name" class="form-control" required />
                </div>
                <div class="form-group mb-3">
                    <label>Contact Number</label>
                    <input type="text" name="contact" class="form-control" required />
                </div>
                <div class="form-group mb-3">
                    <label>Course Interest</label>
                    <input type="text" name="course_interest" class="form-control" required />
                </div>
                <div class="form-group mb-3">
                    <label>Source</label>
                    <select name="source" class="form-control" required>
                        <option>Website</option>
                        <option>Social Media</option>
                        <option>Walk-in</option>
                        <option>Referral</option>
                    </select>
                </div>
                <div class="form-group mb-4">
                    <label>Assign To</label>
                    <select name="assigned_to" class="form-control" required>
                        <%
                            try (Connection conn = DBConnection.getConnection()) {
                                String sql = "SELECT user_id, name FROM users WHERE role='Employee'";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                ResultSet rs = stmt.executeQuery();
                                while (rs.next()) {
                        %>
                            <option value="<%= rs.getInt("user_id") %>"><%= rs.getString("name") %></option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading users</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-soft">Submit Enquiry</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="../bootstrap/bootstrap.min.js"></script>
</body>
</html>
