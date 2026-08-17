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
