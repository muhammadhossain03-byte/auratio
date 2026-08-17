# Auratio — CSE311L Build Plan (Agent Instructions)

**Course:** CSE311L Database Systems Lab · Section 3 · Group 9
**Faculty:** Dr. Nabil Bin Hannan [NLH] · **Lab Instructor:** Md. Amanullah Shah
**Project:** Auratio — A Database-Driven Platform for Public Speaking & Presentation Skill Development

This plan supersedes any earlier plan. It is built directly on the proposal and ERD the team already submitted. Do not invent a new project.

---

## 0. Read this first

The team has already submitted a proposal and a 22-entity ERD. The instructor's rules are explicit on two points:

> "Your ERD must be consistent with the project scope described in your proposal. Designs that do not match the submitted proposal will be penalized."
> "Your implementation must be consistent with your previously submitted ERD & Schema. Any major deviations must be discussed with me beforehand."

So the governing principle here is **schema fidelity, UI restraint**:

- **All 22 tables get built.** Every entity, every attribute, every one of the 29 foreign keys from the submitted ERD. This is just DDL — it costs an hour and it makes the ERD-to-implementation check pass perfectly.
- **CRUD UI is built for 8 tables.** The rubric asks for "all 4 CRUD operations," not "CRUD on 22 tables." Nothing in any guideline requires an edit form per entity.
- **The AI inference is dropped, the AI schema is kept.** This is the important insight, explained in §2.

**Agent rules of engagement:**

1. §4 is the contract. Do not rename a column, drop a constraint, or "improve" the schema. It must match what was submitted.
2. Do not add features. Six proposal features, no more.
3. Everything must run on a Windows laptop with XAMPP and nothing else installed. No npm, no Composer, no bundler, no Docker.
4. When a section says "produce file X", produce the file. Do not describe it.

---

## 1. Requirement coverage matrix

Every instructor requirement, and where this plan satisfies it. Check this before submitting anything.

| # | Requirement | Source | Where satisfied | Status |
|---|---|---|---|---|
| 1 | Template used, cover page filled | Proposal | Already submitted | ✅ Done |
| 2 | One-sentence description | Proposal | Already submitted | ✅ Done |
| 3 | Problem statement 3–5 sentences | Proposal | Already submitted — **verify, it reads as 5** | ⚠️ Check |
| 4 | Exactly 4–6 core features | Proposal | 6 features submitted | ✅ Done |
| 5 | **Every member has a documented role** | Proposal | **Proposal lists 4; ERD cover lists 5** | 🔴 Fix — §3.1 |
| 6 | XAMPP hosts the server | Proposal §2 | Apache from XAMPP serves frontend + API | Plan §5 |
| 7 | MySQL via XAMPP | Proposal §2 | `auratio_db`, MariaDB/MySQL under XAMPP | Plan §4 |
| 8 | Original, non-generic idea | Proposal §3 | Already accepted | ✅ Done |
| 9 | Converted to PDF, one submission | Proposal §3 | Already submitted | ✅ Done |
| 10 | ERD, labelled, crow's foot | ERD | Already submitted, 4 panels | ✅ Done |
| 11 | Entity + attribute list with PKs | ERD | Already submitted §3 | ✅ Done |
| 12 | Relationships + cardinality | ERD | Already submitted §4 | ✅ Done |
| 13 | Foreign keys identified | ERD | Already submitted §5 — 29 FKs | ✅ Done |
| 14 | Logical schema in required notation | ERD | Already submitted §6 | ✅ Done |
| 15 | ERD consistent with proposal | ERD | Already submitted §8 traceability table | ✅ Done |
| 16 | **All tables implemented in MySQL** | DB Impl | 22 tables, §4.2 DDL | Plan §4 |
| 17 | **All PK/FK/other constraints defined** | DB Impl | 22 PKs, 29 FKs, UNIQUE + CHECK, §4.2 | Plan §4 |
| 18 | **Meaningful sample data in all tables** | DB Impl | §4.4, ~280 rows, all 22 tables non-empty | Plan §4 |
| 19 | **`.sql` pushed to public GitHub repo** | DB Impl | `database/schema.sql` + `database/seed.sql` | Plan §8 |
| 20 | **Repo is public** | DB Impl / CRUD | §8 | Plan §8 |
| 21 | Team walks through tables live | DB Impl | Demo script §9 | Plan §9 |
| 22 | **Functional, clean web interface** | Web UI | 6 pages, §6 | Plan §6 |
| 23 | **Source pushed to GitHub** | Web UI | §8 | Plan §8 |
| 24 | **Deployed to GitHub Pages, live link** | Web UI | §5, demo-mode build | Plan §5 |
| 25 | UI reflects approved proposal scope | Web UI | §3.2 feature-to-page map | Plan §3 |
| 26 | **All 4 CRUD ops connected to MySQL** | CRUD | 8 tables full CRUD, §6.2 | Plan §6 |
| 27 | **No hardcoded / fake data in CRUD demo** | CRUD | Local XAMPP demo, verified in phpMyAdmin | Plan §9 |
| 28 | Frontend + backend pushed | CRUD | §8 | Plan §8 |
| 29 | Demo Option A or B chosen | CRUD | **Option B — local demo** | Plan §5 |
| 30 | Every member explains their part | CRUD | §9 role-to-question map | Plan §9 |
| 31 | Deviations discussed beforehand | DB Impl | **Email draft in §3.3** | 🔴 Send |

Items 5 and 31 need human action before anything else. Everything else is build work.

---

## 2. The scope simplification, honestly framed

The team wants to drop the AI integration and build plain CRUD. Here is the precise reading of what that costs.

**It is not a schema deviation.** Look at what the AI actually touches in the submitted design:

- `ai_specialist_agent` — a table of versioned agents. Rows of text.
- `evaluation.agent_id` — a nullable FK saying which agent produced an evaluation.
- `evaluation.evaluator_type` — an ENUM of `AI` or `HUMAN`.

None of that requires a model to exist. An evaluation is a **row**: a score, some feedback text, a timestamp, and a pointer to whoever produced it. The database's job is to store and relate those rows correctly, and it does that identically whether the score came from a language model, a volunteer, or a person typing into a form. The submitted ERD document already says as much — it treats the video as a URI in object storage, not as something the database processes.

**So the correct framing is:** the model inference layer is out of scope for a database lab; the evaluation subsystem is implemented as a fully normalised, constraint-enforced record of evaluations from either source. The XOR CHECK constraint on `evaluation` (§4.2, table 16) enforces the exact rule the ERD document specifies — an evaluation has exactly one source, never both. That constraint is worth pointing at during the review; it is more interesting database work than an API call would have been.

**What actually gets simplified:**

| Submitted design said | Implementation does | Deviation? |
|---|---|---|
| AI agents evaluate MP4 videos | Evaluations are entered through a form; `evaluator_type` and `agent_id` record the attributed source | Feature-level, not schema-level |
| MP4 video submissions | `video_uri` stores a link (Drive/YouTube/local path); no upload pipeline | None — the ERD doc already specified URI-only storage |
| Rubric weights total 100, "enforced by a trigger" | Enforced in seed data and validated in the API, not by a trigger | None — the ERD doc offered application validation as an alternative |
| Role eligibility rules (learner must have Learner role, etc.) | Validated in the API layer, not by triggers | Documented as application-level |
| Frontend built in Flutter | Plain HTML/CSS/JS | Role-description mismatch only; instructor permits any framework |

Everything else is implemented as designed.

---

## 3. Human actions required before building

### 3.1 🔴 Reconcile the team roster

The proposal cover page and roles table list **four** members:

| Name | ID |
|---|---|
| Muhammad Rafid Hossain | 2231895642 |
| Masuma Khan Trisha | 2121336642 |
| Ushrika Mostafa Mou | 2222587042 |
| Ahnaf Akif | 2122286042 |

The ERD cover page lists **five** — the same four plus **Md Ahsanuzzaman Khan (2111942642)**, who has no role in the proposal's Team Roles table.

This matters twice over. The proposal guidelines say every single member must have a clearly defined role in the table. The CRUD and implementation guidelines say all team members must be present at the review and that absence affects marks. Decide which roster is correct, then either add a fifth row to the roles table or drop him from the ERD cover, and say which in the email below. Suggested fifth role if he is on the team: **Frontend Developer (Community & Events module)**, splitting the UI work with Ushrika.

### 3.2 Feature-to-page traceability (paste into the addendum doc)

| # | Proposal feature | Implemented as | Page |
|---|---|---|---|
| 1 | Structured curricula across speaking formats | `curriculum`, `curriculum_module` ordered by `sequence_no`, each tied to one `speech_format` | Curricula |
| 2 | Video submissions with format-specific evaluation | `speech_submission` (URI + metadata) linked through `module_progress` to a format-specific module and rubric | Submissions |
| 3 | Choice of AI or human evaluator | `speech_submission.requested_evaluator_type` and `evaluation.evaluator_type` with the XOR source constraint | Submissions |
| 4 | Progress visualisation dashboard | Derived from `module_progress`, `evaluation`, `evaluation_skill_score`, `user_milestone` — no stored totals | Dashboard |
| 5 | Community event hosting and registration | `community`, `community_membership`, `community_event`, `event_registration` | Community |
| 6 | Role-based user management | `access_role`, `access_permission`, `user_role_assignment`, `role_permission` | Users + Reference |

All six features are visible in the UI. That satisfies "your UI must reflect the scope and features described in your approved project proposal."

### 3.3 🔴 Email the instructor before submitting

Every deadline has passed. Deviations are supposed to be discussed beforehand. Send this before uploading, not after — a late submission with a clear explanation reads very differently from a silent one.

> Subject: CSE311L Section 3 — Group 9 (Auratio) — implementation scope note and late submission
>
> Dear Sir,
>
> This is Group 9 (Auratio), Section 3. We are submitting our database implementation, web UI, and CRUD components together, later than the posted deadlines, and we wanted to be upfront about that rather than upload without explanation.
>
> We also want to flag one scope decision. Our implemented MySQL database contains all 22 entities and all 29 foreign-key constraints exactly as in our approved ERD, including the AI evaluation tables. What we have not built is the AI model inference itself — evaluations are entered and stored through the application, with `evaluator_type` and the agent or human evaluator reference recorded as designed, and a CHECK constraint enforcing that each evaluation has exactly one source. No table, attribute, relationship, or key differs from our submitted schema. We judged that the model layer sits outside the database scope of the course, but if you would prefer us to handle it differently, please let us know.
>
> One correction: our ERD cover page lists five members while our proposal roles table lists four. The correct roster is [X], and the updated roles table is included in the addendum document in our repository.
>
> Repository: [link]
> Live UI: [Pages link]
>
> Thank you for your patience.
>
> Group 9 — Auratio

---

## 4. Database

### 4.1 Environment notes

- **XAMPP ships MariaDB, not Oracle MySQL.** The DDL below targets the intersection of both. Do not use MySQL-8-only syntax.
- `ENGINE=InnoDB` on every table. MyISAM silently ignores foreign keys, and FKs are a graded criterion.
- `utf8mb4` charset so Bangla names are safe.
- `CHECK` constraints are enforced by MariaDB 10.2+ and MySQL 8.0.16+. Both are satisfied by current XAMPP.
- Table names are lowercase snake_case; the ERD uses PascalCase entity names. This is a naming convention, not a schema change — state the mapping in the addendum (`UserAccount` → `user_account`, and so on).

### 4.2 `database/schema.sql`

Produce this file exactly. Create order is dependency-ordered — do not reorder.

```sql
DROP DATABASE IF EXISTS auratio_db;
CREATE DATABASE auratio_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE auratio_db;

-- ─── 1. IDENTITY AND ACCESS CONTROL ────────────────────────────────────

-- [1] UserAccount
CREATE TABLE user_account (
  user_id        INT AUTO_INCREMENT PRIMARY KEY,
  full_name      VARCHAR(120) NOT NULL,
  email          VARCHAR(160) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  bio            VARCHAR(400),
  account_status ENUM('Active','Suspended','Deactivated') NOT NULL DEFAULT 'Active',
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- [2] AccessRole
CREATE TABLE access_role (
  role_id     INT AUTO_INCREMENT PRIMARY KEY,
  role_name   VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(200)
) ENGINE=InnoDB;

-- [3] AccessPermission
CREATE TABLE access_permission (
  permission_id   INT AUTO_INCREMENT PRIMARY KEY,
  permission_code VARCHAR(60) NOT NULL UNIQUE,
  description     VARCHAR(200)
) ENGINE=InnoDB;

-- [4] RolePermission  (bridge)
CREATE TABLE role_permission (
  role_id       INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  CONSTRAINT fk_rp_role FOREIGN KEY (role_id)       REFERENCES access_role(role_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES access_permission(permission_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- [5] UserRoleAssignment  (bridge)
CREATE TABLE user_role_assignment (
  user_id     INT NOT NULL,
  role_id     INT NOT NULL,
  assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_ura_user FOREIGN KEY (user_id) REFERENCES user_account(user_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ura_role FOREIGN KEY (role_id) REFERENCES access_role(role_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ─── 2. FORMATS, SKILLS, RUBRICS, AGENTS ───────────────────────────────

-- [6] SpeechFormat
CREATE TABLE speech_format (
  format_id   INT AUTO_INCREMENT PRIMARY KEY,
  format_name VARCHAR(60) NOT NULL UNIQUE,
  description VARCHAR(300)
) ENGINE=InnoDB;

-- [7] SpeakingSkill
CREATE TABLE speaking_skill (
  skill_id    INT AUTO_INCREMENT PRIMARY KEY,
  skill_name  VARCHAR(60) NOT NULL UNIQUE,
  description VARCHAR(300)
) ENGINE=InnoDB;

-- [8] RubricCriterion
CREATE TABLE rubric_criterion (
  criterion_id   INT AUTO_INCREMENT PRIMARY KEY,
  format_id      INT NOT NULL,
  skill_id       INT NOT NULL,
  weight_percent DECIMAL(5,2) NOT NULL,
  max_score      INT NOT NULL DEFAULT 100,
  guidance_text  VARCHAR(300),
  UNIQUE KEY uq_criterion (format_id, skill_id),
  CONSTRAINT fk_rc_format FOREIGN KEY (format_id) REFERENCES speech_format(format_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_rc_skill  FOREIGN KEY (skill_id)  REFERENCES speaking_skill(skill_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_rc_weight CHECK (weight_percent > 0 AND weight_percent <= 100),
  CONSTRAINT chk_rc_max    CHECK (max_score > 0)
) ENGINE=InnoDB;

-- [9] AISpecialistAgent
CREATE TABLE ai_specialist_agent (
  agent_id      INT AUTO_INCREMENT PRIMARY KEY,
  format_id     INT NOT NULL,
  agent_name    VARCHAR(80) NOT NULL,
  model_version VARCHAR(40) NOT NULL,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE KEY uq_agent (format_id, agent_name, model_version),
  CONSTRAINT fk_agent_format FOREIGN KEY (format_id) REFERENCES speech_format(format_id)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ─── 3. CURRICULA, PROGRESS, SUBMISSIONS ───────────────────────────────

-- [10] Curriculum
CREATE TABLE curriculum (
  curriculum_id    INT AUTO_INCREMENT PRIMARY KEY,
  curriculum_code  VARCHAR(30) NOT NULL UNIQUE,
  title            VARCHAR(150) NOT NULL,
  description      VARCHAR(500),
  difficulty_level ENUM('Beginner','Intermediate','Advanced') NOT NULL DEFAULT 'Beginner',
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- [11] CurriculumModule
CREATE TABLE curriculum_module (
  module_id          INT AUTO_INCREMENT PRIMARY KEY,
  curriculum_id      INT NOT NULL,
  format_id          INT NOT NULL,
  sequence_no        INT NOT NULL,
  title              VARCHAR(150) NOT NULL,
  learning_objective VARCHAR(400),
  passing_score      INT NOT NULL DEFAULT 60,
  UNIQUE KEY uq_module_seq (curriculum_id, sequence_no),
  CONSTRAINT fk_cm_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_cm_format     FOREIGN KEY (format_id)     REFERENCES speech_format(format_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_cm_seq  CHECK (sequence_no > 0),
  CONSTRAINT chk_cm_pass CHECK (passing_score BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- [12] Milestone
CREATE TABLE milestone (
  milestone_id     INT AUTO_INCREMENT PRIMARY KEY,
  curriculum_id    INT NOT NULL,
  milestone_code   VARCHAR(40) NOT NULL UNIQUE,
  title            VARCHAR(150) NOT NULL,
  description      VARCHAR(400),
  rule_description VARCHAR(400),
  CONSTRAINT fk_ms_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- [13] CurriculumEnrollment
CREATE TABLE curriculum_enrollment (
  enrollment_id     INT AUTO_INCREMENT PRIMARY KEY,
  learner_id        INT NOT NULL,
  curriculum_id     INT NOT NULL,
  enrollment_status ENUM('Active','Completed','Withdrawn') NOT NULL DEFAULT 'Active',
  enrolled_at       DATETIME NOT NULL,
  completed_at      DATETIME NULL,
  UNIQUE KEY uq_enrollment (learner_id, curriculum_id),
  CONSTRAINT fk_ce_learner    FOREIGN KEY (learner_id)    REFERENCES user_account(user_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_ce_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_ce_completed CHECK (enrollment_status <> 'Completed' OR completed_at IS NOT NULL)
) ENGINE=InnoDB;

-- [14] ModuleProgress
CREATE TABLE module_progress (
  module_progress_id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_id      INT NOT NULL,
  module_id          INT NOT NULL,
  progress_status    ENUM('Not Started','In Progress','Completed') NOT NULL DEFAULT 'Not Started',
  started_at         DATETIME NULL,
  completed_at       DATETIME NULL,
  UNIQUE KEY uq_progress (enrollment_id, module_id),
  CONSTRAINT fk_mp_enrollment FOREIGN KEY (enrollment_id) REFERENCES curriculum_enrollment(enrollment_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_mp_module     FOREIGN KEY (module_id)     REFERENCES curriculum_module(module_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_mp_completed CHECK (progress_status <> 'Completed' OR completed_at IS NOT NULL)
) ENGINE=InnoDB;

-- [15] SpeechSubmission
CREATE TABLE speech_submission (
  submission_id            INT AUTO_INCREMENT PRIMARY KEY,
  module_progress_id       INT NOT NULL,
  attempt_no               INT NOT NULL,
  video_uri                VARCHAR(500) NOT NULL,
  mime_type                VARCHAR(60) NOT NULL DEFAULT 'video/mp4',
  duration_seconds         INT,
  requested_evaluator_type ENUM('AI','HUMAN') NOT NULL,
  submission_status        ENUM('Submitted','Under Review','Evaluated') NOT NULL DEFAULT 'Submitted',
  submitted_at             DATETIME NOT NULL,
  UNIQUE KEY uq_attempt (module_progress_id, attempt_no),
  CONSTRAINT fk_ss_progress FOREIGN KEY (module_progress_id) REFERENCES module_progress(module_progress_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_ss_attempt  CHECK (attempt_no > 0),
  CONSTRAINT chk_ss_duration CHECK (duration_seconds IS NULL OR duration_seconds > 0),
  CONSTRAINT chk_ss_mime     CHECK (mime_type = 'video/mp4')
) ENGINE=InnoDB;

-- ─── 4. EVALUATION ─────────────────────────────────────────────────────

-- [16] Evaluation  ── note the XOR source constraint
CREATE TABLE evaluation (
  evaluation_id      INT AUTO_INCREMENT PRIMARY KEY,
  submission_id      INT NOT NULL,
  evaluation_no      INT NOT NULL,
  evaluator_type     ENUM('AI','HUMAN') NOT NULL,
  human_evaluator_id INT NULL,
  agent_id           INT NULL,
  overall_score      DECIMAL(5,2) NOT NULL,
  summary_feedback   TEXT,
  evaluated_at       DATETIME NOT NULL,
  UNIQUE KEY uq_eval_no (submission_id, evaluation_no),
  CONSTRAINT fk_ev_submission FOREIGN KEY (submission_id)      REFERENCES speech_submission(submission_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_ev_human      FOREIGN KEY (human_evaluator_id) REFERENCES user_account(user_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ev_agent      FOREIGN KEY (agent_id)           REFERENCES ai_specialist_agent(agent_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_ev_score  CHECK (overall_score BETWEEN 0 AND 100),
  CONSTRAINT chk_ev_no     CHECK (evaluation_no > 0),
  CONSTRAINT chk_ev_source CHECK (
      (evaluator_type = 'AI'    AND agent_id IS NOT NULL AND human_evaluator_id IS NULL) OR
      (evaluator_type = 'HUMAN' AND human_evaluator_id IS NOT NULL AND agent_id IS NULL))
) ENGINE=InnoDB;

-- [17] EvaluationSkillScore
CREATE TABLE evaluation_skill_score (
  evaluation_id INT NOT NULL,
  criterion_id  INT NOT NULL,
  score         DECIMAL(5,2) NOT NULL,
  feedback      VARCHAR(400),
  PRIMARY KEY (evaluation_id, criterion_id),
  CONSTRAINT fk_ess_eval      FOREIGN KEY (evaluation_id) REFERENCES evaluation(evaluation_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_ess_criterion FOREIGN KEY (criterion_id)  REFERENCES rubric_criterion(criterion_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_ess_score CHECK (score >= 0)
) ENGINE=InnoDB;

-- [18] UserMilestone  (bridge)
CREATE TABLE user_milestone (
  user_id      INT NOT NULL,
  milestone_id INT NOT NULL,
  achieved_at  DATETIME NOT NULL,
  PRIMARY KEY (user_id, milestone_id),
  CONSTRAINT fk_um_user      FOREIGN KEY (user_id)      REFERENCES user_account(user_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_um_milestone FOREIGN KEY (milestone_id) REFERENCES milestone(milestone_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ─── 5. COMMUNITIES AND EVENTS ─────────────────────────────────────────

-- [19] Community
CREATE TABLE community (
  community_id       INT AUTO_INCREMENT PRIMARY KEY,
  created_by_user_id INT NOT NULL,
  name               VARCHAR(120) NOT NULL UNIQUE,
  description        VARCHAR(500),
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_com_creator FOREIGN KEY (created_by_user_id) REFERENCES user_account(user_id)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- [20] CommunityMembership  (bridge)
CREATE TABLE community_membership (
  community_id      INT NOT NULL,
  user_id           INT NOT NULL,
  membership_status ENUM('Active','Pending','Left') NOT NULL DEFAULT 'Active',
  joined_at         DATETIME NOT NULL,
  PRIMARY KEY (community_id, user_id),
  CONSTRAINT fk_cmem_community FOREIGN KEY (community_id) REFERENCES community(community_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cmem_user      FOREIGN KEY (user_id)      REFERENCES user_account(user_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- [21] CommunityEvent
CREATE TABLE community_event (
  event_id          INT AUTO_INCREMENT PRIMARY KEY,
  community_id      INT NOT NULL,
  organizer_user_id INT NOT NULL,
  title             VARCHAR(150) NOT NULL,
  description       VARCHAR(500),
  event_mode        ENUM('In-Person','Online','Hybrid') NOT NULL,
  start_at          DATETIME NOT NULL,
  end_at            DATETIME NOT NULL,
  venue             VARCHAR(200) NULL,
  meeting_url       VARCHAR(400) NULL,
  capacity          INT NULL,
  event_status      ENUM('Scheduled','Ongoing','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cev_community FOREIGN KEY (community_id)      REFERENCES community(community_id)
      ON DELETE CASCADE  ON UPDATE CASCADE,
  CONSTRAINT fk_cev_organizer FOREIGN KEY (organizer_user_id) REFERENCES user_account(user_id)
      ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_cev_dates    CHECK (start_at < end_at),
  CONSTRAINT chk_cev_capacity CHECK (capacity IS NULL OR capacity > 0)
) ENGINE=InnoDB;

-- [22] EventRegistration  (bridge)
CREATE TABLE event_registration (
  event_id            INT NOT NULL,
  user_id             INT NOT NULL,
  registration_status ENUM('Confirmed','Waitlisted','Cancelled','Attended') NOT NULL DEFAULT 'Confirmed',
  registered_at       DATETIME NOT NULL,
  PRIMARY KEY (event_id, user_id),
  CONSTRAINT fk_er_event FOREIGN KEY (event_id) REFERENCES community_event(event_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_er_user  FOREIGN KEY (user_id)  REFERENCES user_account(user_id)
      ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
```

**Totals to quote in the review: 22 tables, 22 primary keys, 29 foreign keys, 9 composite-key bridge tables and unique constraints, 14 CHECK constraints.** The 29 matches the submitted ERD document's own count exactly — say so.

### 4.3 What each `ON DELETE` rule means (be ready to explain this)

- `CASCADE` where the child cannot exist without the parent: modules under a curriculum, progress under an enrollment, submissions under progress, evaluations under a submission, all bridge rows.
- `RESTRICT` where history must survive: you cannot delete a user who evaluated a speech, organised an event, or created a community; you cannot delete a speech format, skill, or agent that historical records point at. This mirrors the "retain longitudinal evidence" rule in the submitted ERD document §7.2.

Blocking a delete is a **feature**, not a bug. Demonstrate it in §9.

### 4.4 `database/seed.sql`

Insert in exactly the create order above. Reversing it produces FK errors.

| Order | Table | Rows | Notes |
|---|---|---|---|
| 1 | user_account | 12 | Include the 4–5 real team members plus learners, evaluators, an admin |
| 2 | access_role | 4 | Learner, Evaluator, Administrator, Organizer — exactly the four named in the proposal |
| 3 | access_permission | 8 | `curriculum.manage`, `submission.create`, `evaluation.create`, `event.host`, `user.manage`, `community.create`, `report.view`, `role.assign` |
| 4 | role_permission | 14 | Admin gets all 8; others get 2–3 each |
| 5 | user_role_assignment | 16 | **At least two users must hold two roles** — this is the many-to-many the proposal promised |
| 6 | speech_format | 4 | Persuasive, Informative, Impromptu, Demonstrative — exactly as in the proposal |
| 7 | speaking_skill | 5 | Structure, Delivery, Clarity, Persuasion, Body Language |
| 8 | rubric_criterion | 16 | 4 per format; **weights per format must total 100.00** |
| 9 | ai_specialist_agent | 5 | One per format plus one older version of one agent, `is_active = FALSE`, to show versioning |
| 10 | curriculum | 3 | Beginner / Intermediate / Advanced |
| 11 | curriculum_module | 12 | 4 per curriculum, `sequence_no` 1–4, mixing formats |
| 12 | milestone | 6 | 2 per curriculum |
| 13 | curriculum_enrollment | 10 | Mix of Active, Completed (with `completed_at` set), Withdrawn |
| 14 | module_progress | 26 | Mix of all three statuses |
| 15 | speech_submission | 18 | Include one module with `attempt_no` 1, 2, and 3 to show repeat attempts |
| 16 | evaluation | 20 | **~11 AI, ~9 HUMAN.** One submission must have two evaluation rounds (`evaluation_no` 1 and 2) |
| 17 | evaluation_skill_score | 72 | 4 criterion scores per evaluation, using the criteria of that submission's format |
| 18 | user_milestone | 8 | |
| 19 | community | 3 | e.g. Dhaka Speakers Circle, NSU Communication Society, Corporate Presenters BD |
| 20 | community_membership | 18 | Mix of Active / Pending |
| 21 | community_event | 6 | Mix of In-Person, Online, Hybrid; venue set only for in-person/hybrid, meeting_url only for online/hybrid; one Cancelled |
| 22 | event_registration | 20 | Mix of Confirmed, Waitlisted, Attended |

≈ 280 rows. Realism requirements: Bangla-appropriate names, Dhaka venues, plausible `video_uri` values (Google Drive or YouTube links are fine — a fake but well-formed URL is acceptable and honest, since the schema stores a URI by design), durations 180–420 seconds, scores in a believable 55–95 spread with visible improvement across a learner's repeat attempts. That last detail makes the progress dashboard show something real.

### 4.5 Verification — run before declaring the DB done

```sql
-- A. All 22 tables populated (expect 22 rows, none with count 0)
SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'auratio_db' ORDER BY TABLE_NAME;

-- B. All 29 foreign keys present (expect 29 rows)
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'auratio_db' AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- C. Every table is InnoDB (no MyISAM rows)
SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'auratio_db';

-- D. Rubric weights total 100 per format (must return zero rows)
SELECT format_id, SUM(weight_percent) t FROM rubric_criterion
GROUP BY format_id HAVING ABS(t - 100) > 0.01;

-- E. Evaluation XOR rule holds (must return zero rows)
SELECT evaluation_id FROM evaluation
WHERE (evaluator_type='AI'    AND (agent_id IS NULL OR human_evaluator_id IS NOT NULL))
   OR (evaluator_type='HUMAN' AND (human_evaluator_id IS NULL OR agent_id IS NOT NULL));

-- F. At least one user holds multiple roles (must return ≥ 2 rows)
SELECT user_id, COUNT(*) c FROM user_role_assignment GROUP BY user_id HAVING c > 1;

-- G. Scored criteria match the submission's format (must return zero rows)
SELECT ess.evaluation_id, ess.criterion_id
FROM evaluation_skill_score ess
JOIN evaluation e   ON e.evaluation_id = ess.evaluation_id
JOIN speech_submission s ON s.submission_id = e.submission_id
JOIN module_progress mp  ON mp.module_progress_id = s.module_progress_id
JOIN curriculum_module cm ON cm.module_id = mp.module_id
JOIN rubric_criterion rc ON rc.criterion_id = ess.criterion_id
WHERE rc.format_id <> cm.format_id;
```

Also produce `database/reset.sql` (drop + re-source) and `database/queries.sql` holding the demo queries from §9.

---

## 5. Architecture — and the trap to avoid

### The conflict nobody flags until it breaks

The Web UI deliverable requires a live GitHub Pages deployment. The CRUD deliverable requires live MySQL. **These cannot coexist on one host.** Pages serves static files only — no PHP, no database. Worse, a page served from `https://username.github.io` is blocked by every modern browser from calling `http://localhost` (mixed content). Teams discover this at 11 PM.

### The resolution: one codebase, two modes, switched by hostname

```
MODE A — LOCAL (the graded CRUD demo)
  XAMPP Apache serves everything from C:\xampp\htdocs\auratio\
    http://localhost/auratio/          → frontend
    http://localhost/auratio/api/*.php → PHP REST API
  Same origin: no CORS, no mixed content. Real MySQL reads and writes.

MODE B — GITHUB PAGES (the public link)
  https://<user>.github.io/<repo>/
  config.js detects *.github.io → DEMO_MODE = true
  api.js reads from data/demo-data.json, writes mutate an in-memory copy.
  A visible amber banner says "Demo data — run locally with XAMPP for live DB."
```

This satisfies both deliverables honestly. **Take Option B (local demo) for the CRUD review** — the instructor calls it "completely acceptable," and Render/Railway free tiers cold-start and will fail you at 8:05 AM.

Generate `data/demo-data.json` by dumping the seeded database. Never hand-write it; it must not drift from `seed.sql`.

### Stack

| Layer | Choice | Why |
|---|---|---|
| Database | MySQL/MariaDB via XAMPP | Mandated |
| Backend | PHP 8 + PDO, plain files, no framework | Ships inside XAMPP. Zero install. Named in the proposal's backend role. |
| Frontend | Vanilla HTML + CSS + ES modules | No build step means Pages deploy is a `git push`. See §3.2 note on the Flutter role description. |
| Hosting | XAMPP local + GitHub Pages | Mandated |

---

## 6. Application

### 6.1 Repository layout

```
auratio/
├── README.md
├── .nojekyll
├── docs/
│   ├── 01_PROPOSAL.pdf                  (already submitted)
│   ├── 02_ERD_AND_SCHEMA.pdf            (already submitted)
│   ├── erd_panel_a..d.png               (already submitted)
│   └── 03_IMPLEMENTATION_ADDENDUM.md    ← NEW, see §7
├── database/
│   ├── schema.sql   ├── seed.sql
│   ├── queries.sql  └── reset.sql
├── api/
│   ├── config.php   ├── db.php
│   ├── users.php            ├── curricula.php
│   ├── modules.php          ├── enrollments.php
│   ├── progress.php         ├── submissions.php
│   ├── evaluations.php      ├── communities.php
│   ├── events.php           ├── registrations.php
│   ├── memberships.php      ├── roles.php
│   ├── lookups.php   └── stats.php
├── assets/
│   ├── css/style.css
│   └── js/ config.js · api.js · ui.js · dashboard.js · users.js ·
│           curricula.js · submissions.js · community.js · lookups.js
├── data/demo-data.json
├── index.html · users.html · curricula.html ·
   submissions.html · community.html · reference.html
```

**Path rule:** every `href` and `src` must be relative (`./assets/css/style.css`), never root-absolute (`/assets/...`). Pages serves project sites from `/<repo>/`, and root-absolute paths 404 there. This breaks more Pages deployments than anything else.

### 6.2 CRUD tiering — this is what keeps the project simple

All 22 tables exist in MySQL. The UI exposes them at three levels of depth.

**Tier 1 — full Create, Read, Update, Delete (8 tables)**

| Table | Page | Notes |
|---|---|---|
| `user_account` | Users | Email uniqueness enforced and surfaced as a readable error |
| `curriculum` | Curricula | |
| `curriculum_module` | Curricula (nested) | `sequence_no` unique within curriculum |
| `curriculum_enrollment` | Users (nested) | API must set `completed_at` when status → Completed, or the CHECK fires |
| `speech_submission` | Submissions | `attempt_no` unique within progress row |
| `evaluation` | Submissions (nested) | Form switches evaluator fields on `evaluator_type`; sends exactly one of the two IDs |
| `community_event` | Community | Venue/meeting_url shown per `event_mode` |
| `event_registration` | Community (nested) | Capacity check in API before Confirmed |

**Tier 2 — Create, status Update, Delete (4 tables)**
`module_progress`, `user_role_assignment`, `community_membership`, `user_milestone`. Bridge tables with composite keys; there is nothing meaningful to "edit" beyond status, so the forms are add/remove plus a status dropdown.

**Tier 3 — seeded, read-only in the UI (10 tables)**
`speech_format`, `speaking_skill`, `rubric_criterion`, `ai_specialist_agent`, `access_role`, `access_permission`, `role_permission`, `milestone`, `community`, `evaluation_skill_score` *(created as a child of the evaluation form, not standalone)*. All rendered on `reference.html` so an examiner can see every table has real data.

Rationale to state in the review if asked: reference tables are administrative configuration, not day-to-day user actions. Exposing delete on `speech_format` would be a design error, not a missing feature.

### 6.3 Pages

| Page | Contents |
|---|---|
| `index.html` — **Dashboard** | KPI cards (active learners, enrollments, submissions, evaluations, upcoming events), completion rate by curriculum, average score by speaking skill, recent evaluations. All derived by SQL, none stored. **Covers feature 4.** |
| `users.html` — **Users & Access** | User table with CRUD. Row expand shows role assignments (add/remove) and enrollments (CRUD). **Covers features 6 and 1.** |
| `curricula.html` — **Curricula** | Curriculum table with CRUD; select one to manage its ordered modules and view its milestones. **Covers feature 1.** |
| `submissions.html` — **Practice & Evaluation** | Submission table with CRUD, filterable by learner, format, and status. Select one to view/add evaluation rounds with per-criterion skill scores. Evaluator-type toggle drives which evaluator field appears. **Covers features 2 and 3.** |
| `community.html` — **Communities & Events** | Community list, event CRUD, membership and registration management with capacity handling. **Covers feature 5.** |
| `reference.html` — **Reference Data** | Read-only tables for all Tier 3 entities plus a live table-and-row-count summary pulled from `information_schema`. **Proves all 22 tables exist and are populated — put this on screen during the DB walkthrough.** |

### 6.4 API rules

- Base path `<origin>/auratio/api/`. Responses are always `{"ok":true,"data":...}` or `{"ok":false,"error":{"code":"...","message":"..."}}`.
- `GET` list/read, `POST` create, `PUT` update, `DELETE` delete; id via `?id=`, composite keys via `?a=&b=`.
- **PDO prepared statements only. Never interpolate a variable into SQL.** This is a database course; an injectable submission is self-inflicted.
- Translate MySQL errors into human messages: `1062` → "That email is already registered." `1451` → "Cannot delete this user because they have evaluated submissions." `4025`/`3819` (CHECK failed) → name the rule that failed.
- Server-side validation, not just browser validation. Return `400` with a field name.
- Special handling: setting an enrollment or progress row to `Completed` must set `completed_at`; creating an evaluation must null out the unused evaluator column; confirming a registration must count existing Confirmed rows against `capacity`.

### 6.5 UI quality bar

Graded on "cleanliness and functionality," so: one accent colour and one font; real empty states; loading and error states on every fetch; inline field errors rather than `alert()`; a confirmation dialog naming the record before every delete; responsive to 360px; real `<label>` elements. Nothing decorative. Consistency reads as competence.

---

## 7. `docs/03_IMPLEMENTATION_ADDENDUM.md`

Produce this file. It is what protects the marks on "consistent with your previously submitted ERD & Schema."

Contents:

1. **Entity-to-table name map** — all 22, PascalCase → snake_case.
2. **Constraint inventory** — 22 PKs, 29 FKs (list them), 9 UNIQUE constraints, 14 CHECKs, with a one-line purpose each.
3. **Scope note** — the §2 table verbatim, stating that no table, attribute, relationship, or key differs from the submitted ERD, and that only the model inference layer and the two optional triggers were replaced with application-level validation.
4. **Feature-to-page traceability** — §3.2 table.
5. **CRUD tiering rationale** — §6.2, with the sentence about reference tables being administrative configuration.
6. **Corrected team roles table** — all members, including the roster fix from §3.1.
7. **Verification output** — paste the results of the seven queries in §4.5.

---

## 8. Build order and acceptance checks

Do not start a phase until the previous phase's check passes.

**Phase 0 — Human actions.** Fix the roster (§3.1). Send the email (§3.3). Create the public GitHub repo.
✅ Repo exists, is public, email sent.

**Phase 1 — Database.** Write `schema.sql`, `seed.sql`, `reset.sql`, `queries.sql`.
✅ Both files run clean in phpMyAdmin on a fresh DB with zero errors and zero warnings. All seven checks in §4.5 return expected results. Query B returns exactly 29 rows.

**Phase 2 — API.** `config.php`, `db.php`, 13 endpoint files.
✅ Every endpoint returns valid JSON on happy and failure paths. Duplicate email returns a readable 400, not a 500. Deleting a user who authored an evaluation returns a clean constraint message. Creating an evaluation with both `agent_id` and `human_evaluator_id` is rejected.

**Phase 3 — Frontend.** Six pages, CSS, JS modules.
✅ All pages render and navigate. Every Tier 1 and Tier 2 write round-trips to MySQL — **verify each one by refreshing phpMyAdmin, not by trusting the UI toast.** Stop Apache mid-session and confirm the UI shows an error state rather than hanging.

**Phase 4 — Addendum + demo mode + deploy.** Write §7 doc, dump `demo-data.json`, push, enable Pages.
✅ Open the `github.io` URL in a private window on a phone: every page loads, no console 404s, demo banner visible, no root-absolute asset paths.

**Phase 5 — README and rehearsal.**
✅ A teammate who has never seen the repo goes from clone to working local app using only the README, in under ten minutes.

---

## 9. Review demo script

Fifteen minutes. Rehearse once on the actual laptop.

| Time | Action | Proves |
|---|---|---|
| 0:00 | phpMyAdmin: show 22 tables. Run §4.5 query B — 29 foreign keys on screen. Point at `evaluation`'s XOR CHECK. | Req. 16, 17 |
| 2:00 | Open `reference.html` — every table with a live row count. | Req. 18 |
| 3:30 | **READ** — Submissions page. Filter by learner and format. Open one submission, show its two evaluation rounds and per-criterion skill scores. | Req. 26 |
| 5:30 | **CREATE** — Add a new speech submission for an existing module progress row. Save. Switch to phpMyAdmin, refresh, show the row. | Req. 26, 27 |
| 7:30 | **CREATE (nested)** — Add an evaluation to it. Toggle evaluator type from AI to Human and show the form swap the evaluator field. Save with skill scores. | Feature 3 |
| 9:30 | **UPDATE** — Change an enrollment to Completed; show `completed_at` populated automatically in phpMyAdmin. | Req. 26 |
| 11:00 | **DELETE** — Delete an event registration; show it gone. Then try to delete a user who has evaluated a submission and show the RESTRICT constraint blocking it with a clean message. **This is the moment that proves the FKs are real.** | Req. 17, 26 |
| 13:00 | Dashboard: completion rates and average skill scores, then open `api/stats.php` raw in a tab to prove it is SQL, not hardcoded. | Feature 4, Req. 27 |
| 14:00 | Show the GitHub repo and the live Pages link. | Req. 19, 23, 24 |

**Every member must be able to answer their own question** (Req. 30):

- *Database Architect:* Why is `evaluation` the only table with three foreign keys, and what does the XOR CHECK do?
- *Backend Developer:* Trace one request from the browser to MySQL and back. Answer: `fetch` → PHP endpoint under Apache → PDO prepared statement → MySQL → JSON. Point at the code doing each step.
- *Frontend Developer:* Why does the evaluation form change fields when evaluator type changes?
- *QA & Documentation:* Which constraints did you test, and what happens when one fails?
- *(Fifth member, if applicable):* Walk through the community-to-event-to-registration chain and its cardinality.

---

## 10. Guardrails — do not do these

- Do not change the schema. No renamed columns, no dropped tables, no added entities. The ERD is already submitted.
- Do not use PostgreSQL, SQLite, Supabase-as-primary, or MongoDB. MySQL via XAMPP is mandated.
- Do not use MyISAM — it ignores foreign keys silently and FKs are graded.
- Do not build video upload, transcoding, authentication flows, payments, certificates, notifications, or a social graph. The submitted ERD explicitly places the last several out of scope.
- Do not call any AI API. Evaluations are records.
- Do not add a bundler, package manager, or ORM.
- Do not concatenate user input into SQL. PDO prepared statements, without exception.
- Do not use root-absolute asset paths — they break GitHub Pages project sites.
- Do not present demo-mode data as live database operations.
- Do not exceed roughly 30 rows in any single table. The rubric asks for meaningful data, not volume.
- Do not backdate commits or documents.

---

## 11. Timing note

Every deadline has passed: database implementation was due 24 July, web UI 1 August, CRUD 11 August. Build all remaining phases in one pass and submit together. Send the §3.3 email **before** uploading, not after. A late submission with a clear, specific explanation and a complete, working artifact recovers far more marks than a silent upload, and considerably more than a rushed partial one.
