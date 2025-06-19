<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>

<%
    String message = null;
    int enquiryId = Integer.parseInt(request.getParameter("enquiry_id"));
    String username = (String) session.getAttribute("username");

    int userId = -1;
    if (username != null) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT user_id FROM users WHERE username = ?");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("user_id");
            }
        } catch (Exception e) {
            message = "User fetch error: " + e.getMessage();
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String date = request.getParameter("followup_date");
        String remark = request.getParameter("remark");
        String nextAction = request.getParameter("next_action");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO followups (enquiry_id, followup_date, remark, next_action, created_by) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, enquiryId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setString(3, remark);
            stmt.setString(4, nextAction);
            stmt.setInt(5, userId);

            int rows = stmt.executeUpdate();
            message = (rows > 0) ? "✅ Follow-up logged successfully!" : "❌ Failed to log follow-up.";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Log Follow-Up - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            margin-top: 60px;
        }

        .card {
            border-radius: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            padding: 25px;
        }

        .form-label {
            font-weight: 500;
        }

        .btn-success {
            border-radius: 12px;
            font-weight: 500;
        }

        .list-group-item {
            background-color: #ffffff;
            border-radius: 12px;
            margin-bottom: 10px;
            border: 1px solid #e0e0e0;
        }

        .timeline-badge {
            font-size: 0.9rem;
            background-color: #0d6efd;
            color: #fff;
            padding: 4px 10px;
            border-radius: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <h4 class="mb-4">📄 Log Follow-Up for Enquiry ID: <span class="text-primary"><%= enquiryId %></span></h4>

        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <form method="post">
            <div class="mb-3">
                <label class="form-label">Follow-Up Date</label>
                <input type="date" name="followup_date" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Remark</label>
                <textarea name="remark" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Next Action</label>
                <input type="text" name="next_action" class="form-control" />
            </div>

            <button type="submit" class="btn btn-success">💾 Save Follow-Up</button>
        </form>

        <hr class="my-4">

        <h5>📅 Follow-Up Timeline</h5>
        <ul class="list-group">
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT f.*, u.name FROM followups f JOIN users u ON f.created_by = u.user_id WHERE enquiry_id = ? ORDER BY followup_date DESC";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, enquiryId);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
                <li class="list-group-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="timeline-badge"><%= rs.getDate("followup_date") %></span>
                        <span class="text-muted">By: <strong><%= rs.getString("name") %></strong></span>
                    </div>
                    <div class="mt-2">
                        <strong>Remark:</strong> <%= rs.getString("remark") %><br>
                        <strong>Next Action:</strong> <%= rs.getString("next_action") %>
                    </div>
                </li>
            <%
                    }
                } catch (Exception e) {
                    out.println("<li class='list-group-item text-danger'>Error loading timeline: " + e.getMessage() + "</li>");
                }
            %>
        </ul>
    </div>
</div>

<script src="../bootstrap/bootstrap.min.js"></script>
</body>
</html>
