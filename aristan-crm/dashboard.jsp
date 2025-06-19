<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Aristan CRM</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../bootstrap/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f1f4f8;
            font-family: 'Segoe UI', sans-serif;
        }
        .navbar {
            background-color: #0d6efd;
        }
        .navbar .navbar-brand, .navbar .nav-link {
            color: white;
        }
        .dashboard-heading {
            margin-top: 70px;
            margin-bottom: 40px;
            font-weight: 600;
        }
        .card-custom {
            border: none;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease-in-out;
            min-height: 200px;
            color: white;
        }
        .card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
        }
        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .card-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        .btn-soft {
            border-radius: 50px;
            padding: 8px 20px;
            margin: 5px;
            font-weight: 500;
            border: none;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
        }
        .btn-soft:hover {
            background-color: white;
            color: #000;
        }
        .bg-enquiry { background: linear-gradient(to right, #0d6efd, #5b9df9); color: #000; }
        .bg-followup { background: linear-gradient(to right, #ffc107, #fdd76a); color: #000; }
        .bg-account { background: linear-gradient(to right, #198754, #45c092); color: #000; }
        .bg-user { background: linear-gradient(to right, #0dcaf0, #5ee6ff); color: #000; }
        footer {
            margin-top: 50px;
            text-align: center;
            font-size: 14px;
            color: #888;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg fixed-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">Aristan CRM</a>
        <div class="d-flex">
            <span class="navbar-text me-3">👋 <%= username %> (<%= role %>)</span>
            <a href="logout.jsp" class="btn btn-outline-light btn-sm rounded-pill">Logout</a>
        </div>
    </div>
</nav>

<div class="container dashboard-container">
    <h3 class="text-center dashboard-heading">Dashboard</h3>
    <div class="row g-4 justify-content-center">
        <% if ("Admin".equals(role)) { %>
            <div class="col-md-3">
                <div class="card card-custom bg-enquiry text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-clipboard-data"></i></div>
                        <h5 class="card-title">Enquiries</h5>
                        <a href="enquiryForm.jsp" class="btn btn-soft">Submit</a>
                        <a href="enquiryList.jsp" class="btn btn-soft">View</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom bg-followup text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-bell"></i></div>
                        <h5 class="card-title">Follow-ups</h5>
                        <a href="followup_reminders.jsp" class="btn btn-soft">Reminders</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom bg-account text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-graph-up"></i></div>
                        <h5 class="card-title">Account</h5>
                        <a href="report.jsp" class="btn btn-soft">View Report</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom bg-user text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-people"></i></div>
                        <h5 class="card-title">Users</h5>
                        <a href="users.jsp" class="btn btn-soft">Manage</a>
                    </div>
                </div>
            </div>
        <% } else if ("Employee".equals(role)) { %>
            <div class="col-md-4">
                <div class="card card-custom bg-enquiry text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-ui-checks"></i></div>
                        <h5 class="card-title">Enquiries</h5>
                        <a href="enquiryForm.jsp" class="btn btn-soft">Submit</a>
                        <a href="enquiryList.jsp" class="btn btn-soft">View</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom bg-followup text-center">
                    <div class="card-body">
                        <div class="card-icon"><i class="bi bi-clock-history"></i></div>
                        <h5 class="card-title">Follow-ups</h5>
                        <a href="followup_reminders.jsp" class="btn btn-soft">Reminders</a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</div>

<footer class="mt-5">
    &copy; <%= new java.util.Date().getYear() + 1900 %> Aristan CRM. All rights reserved.
</footer>

<script src="../bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
