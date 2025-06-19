<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    int placementId = Integer.parseInt(request.getParameter("placement_id"));
    String message = null;
    String username = (String) session.getAttribute("username");
    int followupBy = -1;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM users WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            followupBy = rs.getInt("user_id");
        }
    } catch (Exception e) {
        message = "Error retrieving user: " + e.getMessage();
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String followupDate = request.getParameter("followup_date");
        String remark = request.getParameter("remark");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO placement_followups (placement_id, followup_date, remark, followup_by) VALUES (?, ?, ?, ?)");
            ps.setInt(1, placementId);
            ps.setDate(2, Date.valueOf(followupDate));
            ps.setString(3, remark);
            ps.setInt(4, followupBy);
            ps.executeUpdate();
            message = "✅ Placement follow-up successfully recorded.";
        } catch (Exception e) {
            message = "❌ Error adding follow-up: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Placement Follow-up - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f9fafa;
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            border-radius: 15px;
        }
        .timeline-item {
            margin-bottom: 1.2rem;
            border-left: 4px solid #0d6efd;
            padding-left: 1rem;
            background: #fff;
            padding: 1rem;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
        }
        .timeline-date {
            font-weight: 600;
            color: #0d6efd;
        }
        .timeline-meta {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card p-4 shadow-sm">
        <h3 class="mb-3">📌 Placement Follow-up - ID: <%= placementId %></h3>

        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <form method="post" class="mb-4">
            <div class="mb-3">
                <label class="form-label">Follow-up Date</label>
                <input type="date" name="followup_date" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Remark</label>
                <textarea name="remark" class="form-control" rows="3" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">💾 Save Follow-up</button>
        </form>

        <hr>

        <h4 class="mb-3">📚 Follow-up Timeline</h4>

        <div class="timeline">
        <%
            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT f.*, u.name AS followup_name FROM placement_followups f JOIN users u ON f.followup_by = u.user_id WHERE f.placement_id = ? ORDER BY followup_date DESC");
                ps.setInt(1, placementId);
                ResultSet rs = ps.executeQuery();

                boolean hasFollowups = false;
                while (rs.next()) {
                    hasFollowups = true;
        %>
            <div class="timeline-item">
                <div class="timeline-date"><%= rs.getDate("followup_date") %></div>
                <div class="timeline-meta">By: <%= rs.getString("followup_name") %></div>
                <p class="mt-2 mb-1"><strong>Remark:</strong> <%= rs.getString("remark") %></p>
            </div>
        <%
                }
                if (!hasFollowups) {
        %>
            <div class="alert alert-secondary">No follow-up entries found yet.</div>
        <%
                }
            } catch (Exception e) {
        %>
            <div class="alert alert-danger">❌ Error loading timeline: <%= e.getMessage() %></div>
        <%
            }
        %>
        </div>
    </div>
</div>
<script src="../bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
