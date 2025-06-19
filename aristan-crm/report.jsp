<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"Admin".equals(role)) {
        response.sendRedirect("dashboard.jsp"); // Deny access
        return;
    }

    int totalEnquiries = 0, newCount = 0, contacted = 0, followup = 0, converted = 0, lost = 0;
    int totalPayments = 0;
    double totalAmount = 0.0;
    int placed = 0, notPlaced = 0, interviews = 0;
    double avgSalary = 0.0;

    try (Connection conn = DBConnection.getConnection()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM enquiries");
        if (rs.next()) totalEnquiries = rs.getInt(1);

        rs = stmt.executeQuery("SELECT status, COUNT(*) FROM enquiries GROUP BY status");
        while (rs.next()) {
            String status = rs.getString(1);
            int count = rs.getInt(2);
            switch (status) {
                case "New": newCount = count; break;
                case "Contacted": contacted = count; break;
                case "Follow-up": followup = count; break;
                case "Converted": converted = count; break;
                case "Lost": lost = count; break;
            }
        }

        rs = stmt.executeQuery("SELECT COUNT(*), SUM(amount) FROM payments WHERE status='Paid'");
        if (rs.next()) {
            totalPayments = rs.getInt(1);
            totalAmount = rs.getDouble(2);
        }

        rs = stmt.executeQuery("SELECT placement_status, COUNT(*) FROM placements GROUP BY placement_status");
        while (rs.next()) {
            String status = rs.getString(1);
            int count = rs.getInt(2);
            switch (status) {
                case "Placed": placed = count; break;
                case "Not Placed": notPlaced = count; break;
                case "Interview Scheduled": interviews = count; break;
            }
        }

        rs = stmt.executeQuery("SELECT AVG(salary_offered) FROM placements WHERE placement_status = 'Placed'");
        if (rs.next()) {
            avgSalary = rs.getDouble(1);
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reports - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
        }
        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center">📊 Admin Report Dashboard</h2>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card border-primary">
                <div class="card-body">
                    <h5 class="card-title text-primary">Enquiry Summary</h5>
                    <p>Total Enquiries: <span class="stat-value"><%= totalEnquiries %></span></p>
                    <p>New: <%= newCount %> | Contacted: <%= contacted %></p>
                    <p>Follow-up: <%= followup %> | Converted: <%= converted %> | Lost: <%= lost %></p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-success">
                <div class="card-body">
                    <h5 class="card-title text-success">Payment Summary</h5>
                    <p>Total Payments (Paid): <span class="stat-value"><%= totalPayments %></span></p>
                    <p>Total Collected: ₹ <%= String.format("%.2f", totalAmount) %></p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-info">
                <div class="card-body">
                    <h5 class="card-title text-info">Placement Summary</h5>
                    <p>Placed: <%= placed %> | Not Placed: <%= notPlaced %></p>
                    <p>Interviews Scheduled: <%= interviews %></p>
                    <p>Average Salary: ₹ <%= String.format("%.2f", avgSalary) %></p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="../bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
