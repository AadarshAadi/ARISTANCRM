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

    if (request.getParameter("update") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        String newStatus = request.getParameter("status");
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE enquiries SET status=? WHERE enquiry_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, id);
            stmt.executeUpdate();
            message = "Status updated!";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enquiry List - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f9fafb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            margin-top: 60px;
        }
        .table-card {
            border-radius: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            background-color: white;
            padding: 30px;
        }
        .btn-soft {
            border-radius: 30px;
            padding: 6px 14px;
            font-size: 14px;
            border: none;
        }
        .status-select {
            border-radius: 20px;
        }
        .btn-update {
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 13px;
        }
        .alert {
            border-radius: 12px;
        }
        table {
            font-size: 15px;
        }
        th {
            background-color: #0d6efd;
            color: white;
            text-align: center;
        }
        td {
            vertical-align: middle;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="table-card">
        <h3 class="mb-4 text-center">Student Enquiry List</h3>

        <% if (message != null) { %>
            <div class="alert alert-info text-center"><%= message %></div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact</th>
                        <th>Course</th>
                        <th>Source</th>
                        <th>Assigned To</th>
                        <th>Status</th>
                        <th>Update Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT e.*, u.name AS assigned_name FROM enquiries e JOIN users u ON e.assigned_to = u.user_id";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("enquiry_id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("contact") %></td>
                        <td><%= rs.getString("course_interest") %></td>
                        <td><%= rs.getString("source") %></td>
                        <td><%= rs.getString("assigned_name") %></td>
                        <td><%= rs.getString("status") %></td>
                        <td>
                            <form method="get" action="">
                                <input type="hidden" name="id" value="<%= rs.getInt("enquiry_id") %>" />
                                <select name="status" class="form-control form-control-sm status-select mb-1">
                                    <option<%= rs.getString("status").equals("New") ? " selected" : "" %>>New</option>
                                    <option<%= rs.getString("status").equals("Contacted") ? " selected" : "" %>>Contacted</option>
                                    <option<%= rs.getString("status").equals("Follow-up") ? " selected" : "" %>>Follow-up</option>
                                    <option<%= rs.getString("status").equals("Converted") ? " selected" : "" %>>Converted</option>
                                    <option<%= rs.getString("status").equals("Lost") ? " selected" : "" %>>Lost</option>
                                </select>
                                <button type="submit" name="update" value="true" class="btn btn-primary btn-update">Update</button>
                            </form>
                        </td>
                        <td>
                            <a class="btn btn-info btn-sm btn-soft mb-1" href="payments.jsp?enquiry_id=<%= rs.getInt("enquiry_id") %>">Payments</a><br>
                            <a class="btn btn-warning btn-sm btn-soft mb-1" href="placements.jsp?enquiry_id=<%= rs.getInt("enquiry_id") %>">Placement</a><br>
                            <a class="btn btn-secondary btn-sm btn-soft" href="followup.jsp?enquiry_id=<%= rs.getInt("enquiry_id") %>">Follow-up</a>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='9'>Error loading enquiries: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="../bootstrap/bootstrap.min.js"></script>
</body>
</html>
