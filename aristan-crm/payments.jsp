<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = null;
    int enquiryId = Integer.parseInt(request.getParameter("enquiry_id"));

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String amount = request.getParameter("amount");
        String date = request.getParameter("payment_date");
        String status = request.getParameter("status");
        String invoice = request.getParameter("invoice_number");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO payments (enquiry_id, amount, payment_date, status, invoice_number) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, enquiryId);
            stmt.setBigDecimal(2, new java.math.BigDecimal(amount));
            stmt.setDate(3, Date.valueOf(date));
            stmt.setString(4, status);
            stmt.setString(5, invoice);

            int rows = stmt.executeUpdate();
            message = (rows > 0) ? "✅ Payment recorded!" : "❌ Failed to record payment.";
        } catch (Exception e) {
            message = "⚠️ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payments - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        body {
            background-color: #f9fbfd;
        }
        .card {
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.03);
        }
        .form-control, .btn {
            border-radius: 10px;
        }
        .badge-paid {
            background-color: #198754;
        }
        .badge-pending {
            background-color: #ffc107;
            color: #000;
        }
        .badge-overdue {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card p-4">
        <h3 class="mb-4">💳 Record Payment for Enquiry ID: <%= enquiryId %></h3>

        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <form method="post" class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Amount (₹)</label>
                <input type="number" step="0.01" name="amount" class="form-control" required />
            </div>
            <div class="col-md-4">
                <label class="form-label">Payment Date</label>
                <input type="date" name="payment_date" class="form-control" required />
            </div>
            <div class="col-md-4">
                <label class="form-label">Status</label>
                <select name="status" class="form-control" required>
                    <option value="Paid">Paid</option>
                    <option value="Pending">Pending</option>
                    <option value="Overdue">Overdue</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Invoice Number</label>
                <input type="text" name="invoice_number" class="form-control" />
            </div>
            <div class="col-md-6 d-flex align-items-end justify-content-end">
                <button type="submit" class="btn btn-success px-4">💾 Save Payment</button>
            </div>
        </form>
    </div>

    <div class="card mt-5 p-4">
        <h4 class="mb-3">📋 Payment History</h4>
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Amount (₹)</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Invoice</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM payments WHERE enquiry_id = ? ORDER BY payment_date DESC";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, enquiryId);
                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                            String payStatus = rs.getString("status");
                            String badgeClass = "badge bg-secondary";
                            if ("Paid".equalsIgnoreCase(payStatus)) badgeClass = "badge badge-paid";
                            else if ("Pending".equalsIgnoreCase(payStatus)) badgeClass = "badge badge-pending";
                            else if ("Overdue".equalsIgnoreCase(payStatus)) badgeClass = "badge badge-overdue";
                %>
                    <tr>
                        <td><%= rs.getInt("payment_id") %></td>
                        <td>₹ <%= rs.getBigDecimal("amount") %></td>
                        <td><%= rs.getDate("payment_date") %></td>
                        <td><span class="<%= badgeClass %>"><%= payStatus %></span></td>
                        <td><%= rs.getString("invoice_number") %></td>
                        <td>
                            <a href='payment_receipt.jsp?payment_id=<%= rs.getInt("payment_id") %>'
                               class='btn btn-sm btn-outline-primary'>
                                🧾 Print Invoice
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='text-danger'>Error loading payments: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="../bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
