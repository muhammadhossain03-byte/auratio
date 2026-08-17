# Auratio — Public Speaking & Presentation Skill Development Platform

> **Course:** CSE311L Database Systems Lab · Section 3 · Group 9  
> **Institution:** North South University (NSU)  
> **Live Demo:** [https://muhammadhossain03-byte.github.io/auratio/](https://muhammadhossain03-byte.github.io/auratio/)

---

## 🎙️ About the Project

**Auratio** is a comprehensive, database-driven platform engineered to facilitate structured public speaking and presentation skill development. The system models speech curricula across multiple speaking formats (Informative, Persuasive, Impromptu, Demonstrative), tracks practice speech submissions with multiple attempts, supports multi-criteria rubric evaluation from both AI specialist agents and human evaluators, computes real-time skill analytics, and manages speaking community events with participant registrations.

The application is built strictly according to a normalized relational database schema (22 tables, 29 foreign keys, 14 CHECK constraints) mirroring the submitted Entity-Relationship Diagram (ERD).

---

## 👥 Team Members (Group 9)

| Name | Student ID | Role |
|---|---|---|
| **Muhammad Rafid Hossain** | `2231895642` | Database Architect & Backend Lead |
| **Masuma Khan Trisha** | `2121336642` | Speech Evaluator & Community Lead |
| **Ushrika Mostafa Mou** | `2222587042` | Frontend UI & Design Lead |
| **Ahnaf Akif** | `2122286042` | Submissions & Assessment Flow Lead |

---

## 🛠️ Technology Stack

- **Database:** MySQL 8.0+ / MariaDB via XAMPP (InnoDB storage engine, strict FK and CHECK constraints)
- **Backend API:** PHP 8 with PDO (PHP Data Objects), prepared statements, standardized JSON response helpers
- **Frontend:** Single-page architecture (`index.html`) using Vanilla ES Modules, HTML5, Google Fonts (*Hanken Grotesk* & *Inter*), Material Symbols Outlined
- **Styling:** Vanilla CSS & Tailwind CSS CDN configured with the *Academic Precision* design system tokens
- **Architecture:** Zero-build-step deployment. No Node.js, npm, bundlers, Composer, or Docker required.

---

## 🚀 Two Run Modes

```
+-----------------------------------------------------------------------------------+
| 🌐 GitHub Pages Mode (Demo):                                                      |
|    - Reads data/demo-data.json                                                    |
|    - Read-only demonstration with visible amber banner                            |
+-----------------------------------------------------------------------------------+
| 💻 Local XAMPP Mode (Full Live CRUD):                                             |
|    - Communicates with live PHP backend & MySQL database                          |
|    - Real-time Create, Read, Update, and Delete operations                        |
+-----------------------------------------------------------------------------------+
```

> [!IMPORTANT]
> **Live CRUD Operations:** GitHub Pages is a static hosting environment and cannot execute PHP or connect to MySQL. Live CRUD operations (creating, updating, deleting records, constraint enforcement, and delete blocking) require running locally with XAMPP Apache and MySQL.

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
