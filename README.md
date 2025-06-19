
# Aristan CRM

Aristan CRM is a lightweight, web-based Customer Relationship Management (CRM) system built with JSP, JDBC, and Bootstrap. It helps manage student enquiries, follow-ups, and user roles (Admin and Employee) with a clean, responsive UI.

## 🚀 Features

- 🔐 **Authentication & Authorization**
  - Login with role-based access (Admin / Employee)
  - Session management with secure redirection
  - Proper logout and session invalidation

- 📝 **Enquiry Management**
  - Submit new enquiries
  - View and manage a list of student enquiries

- 🔁 **Follow-up Reminders**
  - Log follow-ups with scheduled dates, remarks, and next actions
  - View pending or overdue follow-ups with visual indicators

- 📊 **Dashboard**
  - Role-specific dashboard cards (e.g. Enquiries, Reports, Users)
  - Clean Bootstrap-styled interface with hover animations

- 👤 **User Management (Admin Only)**
  - Create, update, and view users

## 🛠️ Technologies Used

- Java (JSP/Servlets)
- JDBC (MySQL)
- HTML/CSS (Bootstrap 5)
- Apache Tomcat (suggested)
- MySQL Database

## 📁 Project Structure

```

/web
│
├── login.jsp
├── logout.jsp
├── dashboard.jsp
├── enquiryForm.jsp
├── enquiryList.jsp
├── followup\_reminders.jsp
├── followup.jsp
├── users.jsp
│
├── bootstrap/           # Bootstrap CSS/JS
└── util/
└── DBConnection.java

````

## 🧑‍💻 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aristan-crm.git
   cd aristan-crm


2. **Configure the database**

   * Create a MySQL database (e.g. `aristan_crm`)
   * Run the SQL schema file to create the tables (`users`, `enquiries`, `followups`, etc.)

3. **Update DB credentials**

   In `DBConnection.java`, set your DB connection details:

   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/aristan_crm";
   private static final String USER = "root";
   private static final String PASSWORD = "yourpassword";
   ```

4. **Deploy on Apache Tomcat**

   * Package the project as a `.war` or use it directly in the `webapps/` folder.
   * Start Tomcat and access the app via `http://localhost:8080/aristan-crm/`

5. **Default Admin Credentials**

   If not seeded, insert a default admin:

   ```sql
   INSERT INTO users (username, password, role, name) VALUES ('admin', 'admin123', 'Admin', 'Admin User');
   ```

