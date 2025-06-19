<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    String message = null;
    int enquiryId = Integer.parseInt(request.getParameter("enquiry_id"));

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String company = request.getParameter("company_name");
        String job = request.getParameter("job_role");
        String salary = request.getParameter("salary_offered");
        String status = request.getParameter("placement_status");
        String grade = request.getParameter("academic_performance");

        try (Connection conn = DBConnection.getConnection()) {
            String sqlCheck = "SELECT * FROM placements WHERE enquiry_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(sqlCheck);
            checkStmt.setInt(1, enquiryId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE placements SET company_name=?, job_role=?, salary_offered=?, placement_status=?, academic_performance=? WHERE enquiry_id=?";
                PreparedStatement stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, company);
                stmt.setString(2, job);
                stmt.setBigDecimal(3, new java.math.BigDecimal(salary));
                stmt.setString(4, status);
                stmt.setString(5, grade);
                stmt.setInt(6, enquiryId);
                stmt.executeUpdate();
                message = "✅ Placement updated!";
            } else {
                String insertSql = "INSERT INTO placements (enquiry_id, company_name, job_role, salary_offered, placement_status, academic_performance) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(insertSql);
                stmt.setInt(1, enquiryId);
                stmt.setString(2, company);
                stmt.setString(3, job);
                stmt.setBigDecimal(4, new java.math.BigDecimal(salary));
                stmt.setString(5, status);
                stmt.setString(6, grade);
                stmt.executeUpdate();
                message = "✅ Placement recorded!";
            }
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Placement Management - Aristan CRM</title>
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css">
    <style>
        .form-section {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.05);
        }
        h3, h4 {
            font-weight: 600;
        }
        .btn-success {
            border-radius: 8px;
        }
        .table th {
            width: 200px;
            background-color: #f8f9fa;
        }
        .btn-info {
            border-radius: 8px;
        }
    </style>
</head>
<body>
<div class="container my-5">
    <h3 class="mb-4">📋 Placement Info for Enquiry ID: <%= enquiryId %></h3>

    <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <div class="form-section mb-5">
        <form method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Company Name</label>
                    <input type="text" name="company_name" class="form-control" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Job Role</label>
                    <input type="text" name="job_role" class="form-control" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Salary Offered (₹)</label>
                    <input type="number" name="salary_offered" step="0.01" class="form-control" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Placement Status</label>
                    <select name="placement_status" class="form-select" required>
                        <option value="" disabled selected>Choose status</option>
                        <option>Placed</option>
                        <option>Not Placed</option>
                        <option>Interview Scheduled</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Academic Performance</label>
                    <select name="academic_performance" class="form-select" required>
                        <option value="" disabled selected>Select grade</option>
                        <option>Grade A</option>
                        <option>Grade B</option>
                        <option>Grade C</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 text-end">
                <button type="submit" class="btn btn-success px-4">💾 Save Placement</button>
            </div>
        </form>
    </div>

    <h4>📑 Saved Placement Info</h4>
    <%
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM placements WHERE enquiry_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, enquiryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
    %>
    <table class="table table-bordered mt-3">
        <tr><th>Company</th><td><%= rs.getString("company_name") %></td></tr>
        <tr><th>Job Role</th><td><%= rs.getString("job_role") %></td></tr>
        <tr><th>Salary</th><td>₹ <%= rs.getBigDecimal("salary_offered") %></td></tr>
        <tr><th>Status</th><td><%= rs.getString("placement_status") %></td></tr>
        <tr><th>Academic Performance</th><td><%= rs.getString("academic_performance") %></td></tr>
        <tr><th>Placement Follow-up</th>
            <td>
                <a href='placement_followup.jsp?placement_id=<%= rs.getInt("placement_id") %>' class='btn btn-info'>
                    📞 Placement Follow-up
                </a>
            </td>
        </tr>
    </table>
    <%
            } else {
    %>
        <p class="text-muted">No placement info available yet.</p>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error loading placement info: " + e.getMessage() + "</div>");
        }
    %>
</div>
</body>
</html>
