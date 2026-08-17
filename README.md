# Auratio — Public Speaking & Presentation Skill Development Platform

> **Course:** CSE311L Database Systems Lab · Section 3 · Group 9  
> **Institution:** North South University (NSU)  
> **Live Production (Full Live CRUD):** [https://auratio.space](https://auratio.space)  
> **Static Demo (GitHub Pages):** [https://muhammadhossain03-byte.github.io/auratio/](https://muhammadhossain03-byte.github.io/auratio/)

---

## 🎙️ About the Project

**Auratio** is a comprehensive, database-driven platform engineered to facilitate structured public speaking and presentation skill development. The system models speech curricula across multiple speaking formats (Informative, Persuasive, Impromptu, Demonstrative), tracks practice speech submissions with multiple attempts, supports multi-criteria rubric evaluation from both AI specialist agents and human evaluators, computes real-time skill analytics, and manages speaking community events with participant registrations.

The application is built strictly according to a normalized relational database schema (22 tables, 29 foreign keys, 14 CHECK constraints) mirroring the submitted Entity-Relationship Diagram (ERD).

---

## 👥 Team Members (Group 9)

| Name | Student ID | Role |
|---|---|---|
| **Muhammad Rafid Hossain** | `2231895642` | Project Lead / Database Architect |
| **Masuma Khan Trisha** | `2121336642` | Backend Developer |
| **Ushrika Mostafa Mou** | `2222587042` | Frontend Developer |
| **Ahnaf Akif** | `2122286042` | Quality Assurance & Documentation |

---

## 🛠️ Technology Stack

- **Database:** MySQL 8.0+ / MariaDB via XAMPP & Hostinger (InnoDB storage engine, strict FK and relational constraints)
- **Backend API:** PHP 8 with PDO (PHP Data Objects), prepared statements, standardized JSON response helpers
- **Frontend:** Single-page architecture (`index.html`) using Vanilla ES Modules, HTML5, Google Fonts (*Hanken Grotesk* & *Inter*), Material Symbols Outlined
- **Styling:** Vanilla CSS & Tailwind CSS CDN configured with the *Academic Precision* design system tokens
- **Architecture:** Zero-build-step deployment. No Node.js, npm, bundlers, Composer, or Docker required.

---

## 🚀 Live Links & Run Modes

```
+-----------------------------------------------------------------------------------+
| 🚀 Live Production (Hostinger) — https://auratio.space                            |
|    - Runs full live CRUD against real MySQL database via PHP backend              |
|    - Real-time Create, Read, Update, and Delete operations with constraint checks |
+-----------------------------------------------------------------------------------+
| 🌐 GitHub Pages Demo — https://muhammadhossain03-byte.github.io/auratio/          |
|    - Static client-side demonstration reading data/demo-data.json                 |
|    - Read-only interface with visible amber demo banner                           |
+-----------------------------------------------------------------------------------+
| 💻 Local XAMPP Mode                                                               |
|    - Runs locally with Apache + MySQL on port 3307/3306                           |
+-----------------------------------------------------------------------------------+
```

> [!NOTE]
> **Live Production vs Static Demo:** [https://auratio.space](https://auratio.space) runs against a live MySQL database and PHP backend supporting all real-time Create, Read, Update, and Delete operations. The GitHub Pages link is a static demo environment that serves pre-generated seed data from `data/demo-data.json` with write operations disabled.

---

## 💻 Local Setup Instructions

### Prerequisites
- [XAMPP](https://www.apachefriends.org/) with Apache and MySQL (PHP 8.0+).

### Step-by-Step Installation

1. **Clone the Repository into XAMPP `htdocs`:**
   ```bash
   cd C:\xampp\htdocs
   git clone https://github.com/muhammadhossain03-byte/auratio.git auratio
   ```

2. **Start Services in XAMPP Control Panel:**
   - Start **Apache**
   - Start **MySQL**

3. **Configure Database Connection (if needed):**
   - Default connection parameters are configured in [`api/db.php`](api/db.php).
   - If MySQL runs on a custom port (e.g., `3307` or `3306`), verify the PDO connection settings:
     ```php
     $host = '127.0.0.1';
     $port = 3307; // Change to 3306 if using default port
     $db   = 'auratio_db';
     $user = 'root';
     $pass = '';
     ```

4. **Initialize Database Schema & Seed Data:**
   Open a terminal and run the SQL scripts in order:
   ```powershell
   # Create tables and constraints (22 tables)
   C:\xampp\mysql\bin\mysql -u root -P 3307 -e "SOURCE C:/xampp/htdocs/auratio/database/schema.sql;"

   # Seed sample data
   C:\xampp\mysql\bin\mysql -u root -P 3307 auratio_db -e "SOURCE C:/xampp/htdocs/auratio/database/seed.sql;"
   ```

5. **Verify Database Integrity:**
   Run the verification query suite:
   ```powershell
   C:\xampp\mysql\bin\mysql -u root -P 3307 auratio_db -e "SOURCE C:/xampp/htdocs/auratio/database/verify.sql;"
   ```

6. **Launch the Web Application:**
   Open your browser and navigate to:
   ```
   http://localhost/auratio/
   ```

---

## 🌐 Deploying to Hostinger (Shared Hosting)

For production deployment on Hostinger or any cPanel/shared hosting provider:

1. **Create Database in hPanel:**
   - Go to **Hostinger hPanel → Databases → Management**.
   - Create a new MySQL database and database user (note down the generated database name, username, and password).

2. **Import Schema & Seed Data:**
   - Open **phpMyAdmin** from hPanel for the newly created database.
   - Select your database and click **Import**.
   - Import [`database/schema-hosting.sql`](database/schema-hosting.sql) (contains all 22 tables and 29 foreign keys with `CREATE DATABASE`, `USE`, and `CHECK` constraints removed for shared hosting compatibility).
   - Then import [`database/seed-hosting.sql`](database/seed-hosting.sql) to populate initial seed records (with `USE` statement removed).

3. **Upload Files:**
   - Upload the project repository files to your website root directory (e.g. `public_html/` or a subfolder).

4. **Configure Database Credentials:**
   - In the `api/` directory, copy [`api/config.sample.php`](api/config.sample.php) to `api/config.php`:
     ```bash
     cp api/config.sample.php api/config.php
     ```
   - Edit `api/config.php` with your Hostinger credentials:
     ```php
     return [
         'host'     => 'localhost',
         'port'     => 3306, // Standard hosting port
         'database' => 'u123456789_auratio',
         'username' => 'u123456789_user',
         'password' => 'YourHostingPassword',
     ];
     ```

5. **Access Application:**
   - Visit your domain (e.g., `https://yourdomain.com/`). Full live CRUD will run against the Hostinger MySQL database.

---

## 📑 Feature & Tab Traceability

| Proposal Feature | Implemented UI Tab | Primary Database Tables |
|---|---|---|
| **1. Structured Curricula** | `Curricula` | `curriculum`, `curriculum_module`, `speech_format` |
| **2. Practice Submissions** | `Submissions` | `speech_submission`, `module_progress`, `curriculum_enrollment` |
| **3. AI or Human Evaluator** | `Submissions` (Add Evaluation) | `evaluation`, `ai_specialist_agent`, `user_account` |
| **4. Progress Visualisation** | `Dashboard` | `evaluation`, `evaluation_skill_score`, `module_progress`, `curriculum_enrollment` |
| **5. Community Events & Registrations** | `Community` | `community`, `community_event`, `event_registration` |
| **6. Role-Based Users** | `Users` | `user_account`, `access_role`, `user_role_assignment` |

---

## 🔒 Database & Foreign Key Guarantees

- **22 Tables** created strictly in dependency order.
- **29 Foreign Keys** enforcing relational integrity across all entities.
- **14 CHECK Constraints** enforcing business logic (XOR evaluator constraint, score bounds, sequence numbers, positive attempts).
- **RESTRICT & CASCADE rules:** Delete operations preserve audit trails where necessary (e.g. users with evaluation history cannot be deleted, demonstrating foreign key constraint protection).
