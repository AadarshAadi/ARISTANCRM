<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"Admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String message = null;
    if ("delete".equals(request.getParameter("action"))) {
        int userId = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE user_id = ?");
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            message = "User deleted.";
        } catch (Exception e) {
            message = "Delete failed: " + e.getMessage();
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try (Connection conn = DBConnection.getConnection()) {
            String employeeId = request.getParameter("employee_id");
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String job = request.getParameter("job_title");
            String dept = request.getParameter("department");
            String newRole = request.getParameter("role");

            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO users (employee_id, name, username, password, job_title, department, role) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setInt(1, Integer.parseInt(employeeId));
            stmt.setString(2, name);
            stmt.setString(3, username);
            stmt.setString(4, password); // ❗ You should hash this in production
            stmt.setString(5, job);
            stmt.setString(6, dept);
            stmt.setString(7, newRole);

            stmt.executeUpdate();
            message = "User added successfully!";
        } catch (Exception e) {
            message = "Add failed: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Management - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        .card-header {
            background-color: #343a40;
            color: white;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card shadow-lg mb-4">
        <div class="card-header">
            <h4 class="mb-0">👥 User Management</h4>
        </div>
        <div class="card-body">

            <% if (message != null) { %>
                <div class="alert alert-info"><%= message %></div>
            <% } %>

            <form method="post" class="mb-4">
                <h5 class="mb-3">➕ Add New User</h5>
                <div class="row g-3">
                    <div class="col-md-2">
                        <input type="text" name="employee_id" class="form-control" placeholder="Employee ID" required>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="name" class="form-control" placeholder="Name" required>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="username" class="form-control" placeholder="Username" required>
                    </div>
                    <div class="col-md-2">
                        <input type="password" name="password" class="form-control" placeholder="Password" required>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="job_title" class="form-control" placeholder="Job Title" required>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="department" class="form-control" placeholder="Department" required>
                    </div>
                    <div class="col-md-2">
                        <select name="role" class="form-select" required>
                            <option value="Employee">Employee</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Add User</button>
                    </div>
                </div>
            </form>

            <h5 class="mt-4">📋 Existing Users</h5>
            <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover mt-3">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Job Title</th>
                            <th>Department</th>
                            <th>Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DBConnection.getConnection()) {
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM users");

                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("employee_id") %></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("job_title") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getString("role") %></td>
                            <td>
                                <% if (!rs.getString("username").equals(session.getAttribute("username"))) { %>
                                    <a href="users.jsp?action=delete&id=<%= rs.getInt("user_id") %>" 
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Are you sure you want to delete this user?');">
                                        Delete
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">Self</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='7'>Error loading users: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="../bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
