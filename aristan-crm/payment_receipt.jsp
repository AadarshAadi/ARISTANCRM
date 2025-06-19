<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int paymentId = Integer.parseInt(request.getParameter("payment_id"));
    String message = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement(
            "SELECT p.*, e.name AS student_name " +
            "FROM payments p JOIN enquiries e ON p.enquiry_id = e.enquiry_id " +
            "WHERE p.payment_id = ?");
        ps.setInt(1, paymentId);
        rs = ps.executeQuery();

        if (rs.next()) {
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
        }
        .invoice-box {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.05);
        }
        .invoice-header {
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .invoice-footer {
            margin-top: 30px;
            text-align: center;
            font-size: 0.9rem;
            color: #666;
        }
        @media print {
            .no-print {
                display: none;
            }
            body {
                background: #fff;
            }
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="invoice-box">
        <div class="invoice-header d-flex justify-content-between align-items-center">
            <h3>🧾 Aristan CRM</h3>
            <span><strong>Date:</strong> <%= rs.getDate("payment_date") %></span>
        </div>

        <h5>Invoice Details</h5>
        <table class="table table-borderless">
            <tr>
                <th>Invoice Number:</th>
                <td><%= rs.getString("invoice_number") %></td>
            </tr>
            <tr>
                <th>Student Name:</th>
                <td><%= rs.getString("student_name") %></td>
            </tr>
            <tr>
                <th>Amount Paid:</th>
                <td>₹ <%= rs.getBigDecimal("amount") %></td>
            </tr>
            <tr>
                <th>Status:</th>
                <td><span class="badge bg-<%= rs.getString("status").equalsIgnoreCase("Paid") ? "success" : "warning" %>">
                    <%= rs.getString("status") %>
                </span></td>
            </tr>
        </table>

        <div class="invoice-footer">
            Thank you for your payment. For any queries, contact support@aristancrm.in
        </div>
    </div>

    <div class="text-center mt-4 no-print">
        <button class="btn btn-outline-primary" onclick="window.print()">🖨️ Print Invoice</button>
        <a href="payments.jsp" class="btn btn-secondary">⬅ Back to Payments</a>
    </div>
</div>
</body>
</html>

<%
        } else {
            message = "Invoice not found.";
        }
    } catch (Exception e) {
        message = "Error retrieving invoice: " + e.getMessage();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<% if (message != null) { %>
    <div class="container mt-4">
        <div class="alert alert-warning"><%= message %></div>
    </div>
<% } %>
