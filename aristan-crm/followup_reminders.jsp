<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page import="java.sql.*, util.DBConnection, java.text.SimpleDateFormat, java.util.Date" %>
<%
    java.util.Date today = new java.util.Date();
    java.sql.Date current = new java.sql.Date(today.getTime());

    String message = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Follow-up Reminders - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            margin-top: 60px;
        }

        .card-box {
            background-color: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            padding: 30px;
        }

        .table th {
            background-color: #0d6efd;
            color: white;
            text-align: center;
        }

        .table td {
            vertical-align: middle;
            text-align: center;
        }

        .table-danger {
            background-color: #f8d7da !important;
        }

        .table-warning {
            background-color: #fff3cd !important;
        }

        .alert {
            border-radius: 12px;
        }

        a {
            text-decoration: none;
            color: #0d6efd;
            font-weight: 500;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card-box">
        <h3 class="text-center mb-4">📌 Follow-up Reminders</h3>

        <% if (message != null) { %>
            <div class="alert alert-info text-center"><%= message %></div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Enquiry</th>
                        <th>Scheduled Date</th>
                        <th>Remark</th>
                        <th>Next Action</th>
                        <th>Counselor</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            PreparedStatement stmt = conn.prepareStatement(
                                "SELECT f.*, u.name AS counselor_name, e.name AS student_name " + 
                                "FROM followups f " + 
                                "JOIN users u ON f.created_by = u.user_id " + 
                                "JOIN enquiries e ON f.enquiry_id = e.enquiry_id " + 
                                "WHERE f.followup_date <= ? " + 
                                "ORDER BY f.followup_date ASC"
                            );

                            stmt.setDate(1, current);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                                String rowClass = "";
                                if (rs.getDate("followup_date").compareTo(current) < 0) {
                                    rowClass = "table-danger";  // overdue
                                } else {
                                    rowClass = "table-warning"; // due today
                                }
                    %>
                        <tr class="<%= rowClass %>">
                            <td>
                                <a href="followup.jsp?enquiry_id=<%= rs.getInt("enquiry_id") %>">
                                    <%= rs.getString("student_name") %>
                                </a>
                            </td>
                            <td><%= rs.getDate("followup_date") %></td>
                            <td><%= rs.getString("remark") %></td>
                            <td><%= rs.getString("next_action") %></td>
                            <td><%= rs.getString("counselor_name") %></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            message = "Error retrieving follow-ups: " + e.getMessage();
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
