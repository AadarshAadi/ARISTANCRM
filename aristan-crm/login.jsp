<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String error = null;

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); // ❗ Recommend hashing before saving/comparing in production

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role"));
                response.sendRedirect("dashboard.jsp");
                return;
            } else {
                error = "Invalid username or password";
            }
        } catch (Exception e) {
            error = "Database error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Aristan CRM</title>
    <link rel="stylesheet" href="bootstrap/bootstrap.min.css">
    <style>
        body {
            background: #f2f4f8;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-card {
            border-radius: 16px;
            padding: 30px;
            background-color: #fff;
            box-shadow: 0 8px 16px rgba(0,0,0,0.05);
        }
        .form-control {
            border-radius: 10px;
        }
        .btn-primary {
            border-radius: 10px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<div class="container d-flex align-items-center justify-content-center min-vh-100">
    <div class="col-md-5">
        <div class="login-card">
            <h3 class="text-center mb-4">🔐 Aristan CRM Login</h3>

            <% if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <form method="post" action="login.jsp">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" name="username" id="username" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Login</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
