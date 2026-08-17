-- database/seed.sql
-- Seed data for auratio_db. Insert order matches table creation order.
-- Run AFTER schema.sql:  mysql -u root auratio_db < database/seed.sql

USE auratio_db;

-- ─── 1. user_account (12 rows) ─────────────────────────────────────────

INSERT INTO user_account (user_id, full_name, email, password_hash, bio, account_status) VALUES
(1,  'Muhammad Rafid Hossain',   'rafid.hossain@auratio.app',   '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012', 'Database architect and evaluator. NSU CSE.',                          'Active'),
(2,  'Masuma Khan Trisha',       'trisha.khan@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ013', 'Speech evaluator and community organizer from Dhaka.',                'Active'),
(3,  'Ushrika Mostafa Mou',      'ushrika.mostafa@auratio.app', '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ014', 'Learner and event organizer. Passionate about public speaking.',      'Active'),
(4,  'Ahnaf Akif',               'ahnaf.akif@auratio.app',      '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ015', 'Learner and peer evaluator at NSU.',                                  'Active'),
(5,  'Md Ahsanuzzaman Khan',     'ahsanuzzaman@auratio.app',    '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ016', 'Dedicated learner focused on persuasive speaking.',                   'Active'),
(6,  'Farhan Ahmed',             'farhan.ahmed@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ017', 'Completed the beginner curriculum. Aspiring debater.',                'Active'),
(7,  'Nusrat Jahan',             'nusrat.jahan@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ018', 'Intermediate learner interested in data-driven presentations.',       'Active'),
(8,  'Tanvir Hasan',             'tanvir.hasan@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ019', 'Professional speech evaluator with 5 years of coaching experience.',  'Active'),
(9,  'Sadia Rahman',             'sadia.rahman@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ020', 'Learner exploring impromptu and persuasive formats.',                 'Active'),
(10, 'Rashed Kabir',             'rashed.kabir@auratio.app',     '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ021', 'Community organizer running the Dhaka Speakers Circle.',              'Active'),
(11, 'Farhana Akter',            'farhana.akter@auratio.app',    '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ022', 'Advanced learner preparing for national speech competitions.',        'Active'),
(12, 'Imran Chowdhury',          'imran.chowdhury@auratio.app',  '$2y$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ023', 'Evaluator specialising in demonstrative and informative speeches.',   'Active');

-- ─── 2. access_role (4 rows) ───────────────────────────────────────────

INSERT INTO access_role (role_id, role_name, description) VALUES
(1, 'Learner',       'Enrolls in curricula and submits practice speeches'),
(2, 'Evaluator',     'Reviews and scores speech submissions'),
(3, 'Administrator', 'Manages users, roles, and platform configuration'),
(4, 'Organizer',     'Creates communities and hosts events');

-- ─── 3. access_permission (8 rows) ─────────────────────────────────────

INSERT INTO access_permission (permission_id, permission_code, description) VALUES
(1, 'curriculum.manage',  'Create, update, and delete curricula and modules'),
(2, 'submission.create',  'Submit speech recordings for evaluation'),
(3, 'evaluation.create',  'Evaluate speech submissions and assign scores'),
(4, 'event.host',         'Create and manage community events'),
(5, 'user.manage',        'Create, update, and deactivate user accounts'),
(6, 'community.create',   'Create and manage speaking communities'),
(7, 'report.view',        'View dashboard analytics and progress reports'),
(8, 'role.assign',        'Assign and revoke roles for users');

-- ─── 4. role_permission (14 rows) ──────────────────────────────────────
-- Administrator gets all 8; others get 2 each.

INSERT INTO role_permission (role_id, permission_id) VALUES
-- Learner: submission.create, report.view
(1, 2), (1, 7),
-- Evaluator: evaluation.create, report.view
(2, 3), (2, 7),
-- Administrator: all 8
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8),
-- Organizer: event.host, community.create
(4, 4), (4, 6);

-- ─── 5. user_role_assignment (16 rows) ─────────────────────────────────
-- Users 1–4 each hold two roles (exceeds the "at least two" requirement).

INSERT INTO user_role_assignment (user_id, role_id) VALUES
-- Dual-role users
(1, 3), (1, 2),   -- Rafid: Administrator + Evaluator
(2, 2), (2, 4),   -- Trisha: Evaluator + Organizer
(3, 1), (3, 4),   -- Ushrika: Learner + Organizer
(4, 1), (4, 2),   -- Ahnaf: Learner + Evaluator
-- Single-role users
(5,  1),           -- Ahsanuzzaman: Learner
(6,  1),           -- Farhan: Learner
(7,  1),           -- Nusrat: Learner
(8,  2),           -- Tanvir: Evaluator
(9,  1),           -- Sadia: Learner
(10, 4),           -- Rashed: Organizer
(11, 1),           -- Farhana: Learner
(12, 2);           -- Imran: Evaluator

-- ─── 6. speech_format (4 rows) ─────────────────────────────────────────

INSERT INTO speech_format (format_id, format_name, description) VALUES
(1, 'Persuasive',     'Speeches designed to convince the audience to adopt a viewpoint or take action'),
(2, 'Informative',    'Speeches that educate the audience on a topic with facts and structure'),
(3, 'Impromptu',      'Unrehearsed speeches delivered with minimal preparation time'),
(4, 'Demonstrative',  'Speeches that teach the audience how to do something through live demonstration');

-- ─── 7. speaking_skill (5 rows) ────────────────────────────────────────

INSERT INTO speaking_skill (skill_id, skill_name, description) VALUES
(1, 'Structure',      'Logical organisation of ideas including introduction, body, and conclusion'),
(2, 'Delivery',       'Vocal variety, pacing, tone, and overall presentation confidence'),
(3, 'Clarity',        'Clear articulation of ideas, concise language, and audience comprehension'),
(4, 'Persuasion',     'Ability to influence the audience through evidence, emotion, and reasoning'),
(5, 'Body Language',  'Effective use of gestures, eye contact, posture, and movement');

-- ─── 8. rubric_criterion (16 rows) ─────────────────────────────────────
-- 4 criteria per format. Weights per format sum to exactly 100.00.

INSERT INTO rubric_criterion (criterion_id, format_id, skill_id, weight_percent, max_score, guidance_text) VALUES
-- Persuasive (format 1): Structure 20 + Delivery 20 + Clarity 25 + Persuasion 35 = 100
( 1, 1, 1, 20.00, 100, 'Clear thesis, logical flow of arguments, strong conclusion'),
( 2, 1, 2, 20.00, 100, 'Confident delivery with vocal variety and appropriate pacing'),
( 3, 1, 3, 25.00, 100, 'Ideas expressed concisely and understood by the audience'),
( 4, 1, 4, 35.00, 100, 'Effective use of evidence, emotional appeal, and call to action'),
-- Informative (format 2): Structure 30 + Delivery 20 + Clarity 30 + Body Language 20 = 100
( 5, 2, 1, 30.00, 100, 'Well-organised sections with clear transitions between topics'),
( 6, 2, 2, 20.00, 100, 'Engaging delivery that maintains audience attention'),
( 7, 2, 3, 30.00, 100, 'Complex information simplified without losing accuracy'),
( 8, 2, 5, 20.00, 100, 'Purposeful gestures and visual aids support the content'),
-- Impromptu (format 3): Delivery 30 + Clarity 30 + Persuasion 20 + Body Language 20 = 100
( 9, 3, 2, 30.00, 100, 'Composed delivery despite limited preparation time'),
(10, 3, 3, 30.00, 100, 'Coherent ideas communicated under time pressure'),
(11, 3, 4, 20.00, 100, 'Quick formation of a convincing position on the topic'),
(12, 3, 5, 20.00, 100, 'Confident posture and natural gestures under pressure'),
-- Demonstrative (format 4): Structure 25 + Delivery 25 + Clarity 25 + Body Language 25 = 100
(13, 4, 1, 25.00, 100, 'Step-by-step organisation that the audience can follow'),
(14, 4, 2, 25.00, 100, 'Enthusiasm and clarity in demonstrating each step'),
(15, 4, 3, 25.00, 100, 'Instructions are precise and easy to replicate'),
(16, 4, 5, 25.00, 100, 'Effective physical demonstration and spatial awareness');

-- ─── 9. ai_specialist_agent (5 rows) ───────────────────────────────────

INSERT INTO ai_specialist_agent (agent_id, format_id, agent_name, model_version, is_active) VALUES
(1, 1, 'PersuasionPro',   'v2.1', TRUE),
(2, 2, 'InformBot',       'v1.5', TRUE),
(3, 3, 'ImpromptuCoach',  'v1.0', TRUE),
(4, 4, 'DemoAnalyzer',    'v1.2', TRUE),
(5, 1, 'PersuasionPro',   'v1.0', FALSE);  -- older version, inactive

-- ─── 10. curriculum (3 rows) ───────────────────────────────────────────

INSERT INTO curriculum (curriculum_id, curriculum_code, title, description, difficulty_level, is_active) VALUES
(1, 'CUR-BEG-001', 'Foundations of Public Speaking',
    'A beginner curriculum covering the basics of all four speech formats with guided practice.',
    'Beginner', TRUE),
(2, 'CUR-INT-001', 'Intermediate Presentation Mastery',
    'Builds on foundational skills with data-driven and persuasive speaking techniques.',
    'Intermediate', TRUE),
(3, 'CUR-ADV-001', 'Advanced Oratory and Debate',
    'Intensive modules for competitive speakers refining advanced persuasion and impromptu skills.',
    'Advanced', TRUE);

-- ─── 11. curriculum_module (12 rows) ───────────────────────────────────
-- 4 modules per curriculum, sequence_no 1–4, mixing formats.

INSERT INTO curriculum_module (module_id, curriculum_id, format_id, sequence_no, title, learning_objective, passing_score) VALUES
-- Beginner (curriculum 1)
( 1, 1, 2, 1, 'Introduction to Informative Speaking',  'Deliver a 3-minute informative speech with clear structure',  60),
( 2, 1, 4, 2, 'Basic Demonstration Techniques',        'Perform a step-by-step demonstration with audience engagement', 60),
( 3, 1, 1, 3, 'Fundamentals of Persuasion',            'Construct a basic persuasive argument with supporting evidence', 60),
( 4, 1, 3, 4, 'Impromptu Speaking Basics',             'Deliver a coherent 2-minute impromptu speech on a given topic',  55),
-- Intermediate (curriculum 2)
( 5, 2, 1, 1, 'Crafting Persuasive Arguments',         'Build multi-layered arguments with emotional and logical appeals', 65),
( 6, 2, 2, 2, 'Data-Driven Presentations',             'Present complex data clearly using visual aids and transitions',   65),
( 7, 2, 3, 3, 'Quick Thinking and Response',           'Handle unexpected topics with structured impromptu frameworks',    60),
( 8, 2, 4, 4, 'Product Demo Excellence',               'Deliver a polished product demonstration with audience Q&A',       65),
-- Advanced (curriculum 3)
( 9, 3, 1, 1, 'Advanced Persuasion Strategies',        'Employ advanced rhetorical techniques in competitive settings',    75),
(10, 3, 3, 2, 'Competitive Impromptu Speaking',        'Excel under strict time constraints with minimal preparation',     70),
(11, 3, 2, 3, 'Expert-Level Informative Talks',        'Deliver a TED-style informative talk with narrative structure',    75),
(12, 3, 4, 4, 'Master Class Demonstrations',           'Lead a professional-level demonstration with live troubleshooting', 70);

-- ─── 12. milestone (6 rows) ───────────────────────────────────────────

INSERT INTO milestone (milestone_id, curriculum_id, milestone_code, title, description, rule_description) VALUES
(1, 1, 'MS-BEG-HALF', 'Beginner Halfway',       'Reached the halfway point of the beginner curriculum',       'Complete at least 2 of 4 beginner modules with a passing score'),
(2, 1, 'MS-BEG-DONE', 'Beginner Complete',       'Completed the entire beginner curriculum',                   'Complete all 4 beginner modules with a passing score'),
(3, 2, 'MS-INT-HALF', 'Intermediate Halfway',    'Reached the halfway point of the intermediate curriculum',   'Complete at least 2 of 4 intermediate modules with a passing score'),
(4, 2, 'MS-INT-DONE', 'Intermediate Complete',   'Completed the entire intermediate curriculum',               'Complete all 4 intermediate modules with a passing score'),
(5, 3, 'MS-ADV-HALF', 'Advanced Halfway',        'Reached the halfway point of the advanced curriculum',       'Complete at least 2 of 4 advanced modules with a passing score'),
(6, 3, 'MS-ADV-DONE', 'Advanced Complete',       'Completed the entire advanced curriculum',                   'Complete all 4 advanced modules with a passing score');

-- ─── 13. curriculum_enrollment (10 rows) ───────────────────────────────
-- Mix of Active, Completed (with completed_at), and Withdrawn.

INSERT INTO curriculum_enrollment (enrollment_id, learner_id, curriculum_id, enrollment_status, enrolled_at, completed_at) VALUES
( 1, 4,  1, 'Active',    '2026-01-15 09:00:00', NULL),
( 2, 5,  1, 'Completed', '2026-01-20 10:30:00', '2026-04-15 16:00:00'),
( 3, 6,  1, 'Completed', '2026-02-01 08:00:00', '2026-05-10 14:30:00'),
( 4, 7,  2, 'Active',    '2026-03-01 11:00:00', NULL),
( 5, 9,  2, 'Active',    '2026-03-15 09:30:00', NULL),
( 6, 3,  1, 'Withdrawn', '2026-01-25 14:00:00', NULL),
( 7, 11, 3, 'Active',    '2026-04-01 10:00:00', NULL),
( 8, 6,  2, 'Active',    '2026-05-15 08:30:00', NULL),
( 9, 4,  2, 'Active',    '2026-04-10 09:00:00', NULL),
(10, 5,  3, 'Active',    '2026-05-01 11:00:00', NULL);

-- ─── 14. module_progress (20 rows) ─────────────────────────────────────
-- Mix of Not Started, In Progress, and Completed.

INSERT INTO module_progress (module_progress_id, enrollment_id, module_id, progress_status, started_at, completed_at) VALUES
-- Enrollment 1 (user 4, curriculum 1)
( 1,  1,  1, 'Completed',   '2026-01-16 10:00:00', '2026-02-10 15:00:00'),
( 2,  1,  2, 'Completed',   '2026-02-12 10:00:00', '2026-03-05 14:00:00'),
( 3,  1,  3, 'In Progress',  '2026-03-10 09:00:00', NULL),
( 4,  1,  4, 'Not Started',  NULL,                   NULL),
-- Enrollment 2 (user 5, curriculum 1 — Completed)
( 5,  2,  1, 'Completed',   '2026-01-22 10:00:00', '2026-02-15 16:00:00'),
( 6,  2,  2, 'Completed',   '2026-02-18 10:00:00', '2026-03-10 15:00:00'),
( 7,  2,  3, 'Completed',   '2026-03-12 09:00:00', '2026-04-01 14:00:00'),
( 8,  2,  4, 'Completed',   '2026-04-03 10:00:00', '2026-04-15 16:00:00'),
-- Enrollment 3 (user 6, curriculum 1 — Completed)
( 9,  3,  1, 'Completed',   '2026-02-03 09:00:00', '2026-02-25 15:00:00'),
(10,  3,  2, 'Completed',   '2026-02-27 10:00:00', '2026-03-20 14:00:00'),
(11,  3,  3, 'Completed',   '2026-03-22 09:00:00', '2026-04-15 15:00:00'),
(12,  3,  4, 'Completed',   '2026-04-17 10:00:00', '2026-05-10 14:00:00'),
-- Enrollment 4 (user 7, curriculum 2)
(13,  4,  5, 'Completed',   '2026-03-05 10:00:00', '2026-04-01 16:00:00'),
(14,  4,  6, 'In Progress',  '2026-04-05 09:00:00', NULL),
-- Enrollment 5 (user 9, curriculum 2)
(15,  5,  5, 'In Progress',  '2026-03-20 10:00:00', NULL),
-- Enrollment 9 (user 4, curriculum 2)
(16,  9,  5, 'Completed',   '2026-04-15 10:00:00', '2026-05-10 15:00:00'),
(17,  9,  6, 'In Progress',  '2026-05-15 09:00:00', NULL),
-- Enrollment 10 (user 5, curriculum 3)
(18, 10,  9, 'In Progress',  '2026-05-05 10:00:00', NULL),
-- Enrollment 7 (user 11, curriculum 3)
(19,  7,  9, 'Completed',   '2026-04-05 10:00:00', '2026-05-01 14:00:00'),
(20,  7, 10, 'Not Started',  NULL,                   NULL);

-- ─── 15. speech_submission (18 rows) ───────────────────────────────────
-- MP 13 has attempts 1, 2, 3 with improving evaluation scores.

INSERT INTO speech_submission (submission_id, module_progress_id, attempt_no, video_uri, mime_type, duration_seconds, requested_evaluator_type, submission_status, submitted_at) VALUES
( 1,  1, 1, 'https://drive.google.com/file/d/1aB2cD3eF4gH5iJ6kL/view', 'video/mp4', 195, 'AI',    'Evaluated',    '2026-02-05 14:00:00'),
( 2,  2, 1, 'https://drive.google.com/file/d/2bC3dE4fG5hI6jK7lM/view', 'video/mp4', 240, 'HUMAN', 'Evaluated',    '2026-02-28 11:00:00'),
( 3,  3, 1, 'https://drive.google.com/file/d/3cD4eF5gH6iJ7kL8mN/view', 'video/mp4', 210, 'AI',    'Evaluated',    '2026-03-18 10:00:00'),
( 4,  5, 1, 'https://drive.google.com/file/d/4dE5fG6hI7jK8lM9nO/view', 'video/mp4', 200, 'HUMAN', 'Evaluated',    '2026-02-10 15:00:00'),
( 5,  6, 1, 'https://drive.google.com/file/d/5eF6gH7iJ8kL9mN0oP/view', 'video/mp4', 255, 'AI',    'Evaluated',    '2026-03-02 09:30:00'),
( 6,  7, 1, 'https://drive.google.com/file/d/6fG7hI8jK9lM0nO1pQ/view', 'video/mp4', 230, 'HUMAN', 'Evaluated',    '2026-03-25 14:00:00'),
( 7,  8, 1, 'https://drive.google.com/file/d/7gH8iJ9kL0mN1oP2qR/view', 'video/mp4', 180, 'AI',    'Evaluated',    '2026-04-10 11:00:00'),
( 8,  9, 1, 'https://drive.google.com/file/d/8hI9jK0lM1nO2pQ3rS/view', 'video/mp4', 205, 'AI',    'Evaluated',    '2026-02-18 10:00:00'),
( 9, 10, 1, 'https://drive.google.com/file/d/9iJ0kL1mN2oP3qR4sT/view', 'video/mp4', 260, 'HUMAN', 'Evaluated',    '2026-03-12 15:30:00'),
(10, 11, 1, 'https://drive.google.com/file/d/0jK1lM2nO3pQ4rS5tU/view', 'video/mp4', 220, 'AI',    'Evaluated',    '2026-04-05 09:00:00'),
(11, 12, 1, 'https://drive.google.com/file/d/1kL2mN3oP4qR5sT6uV/view', 'video/mp4', 185, 'HUMAN', 'Evaluated',    '2026-04-28 14:00:00'),
-- MP 13 (user 7, module 5, Persuasive): 3 attempts with improving scores
(12, 13, 1, 'https://drive.google.com/file/d/2lM3nO4pQ5rS6tU7vW/view', 'video/mp4', 245, 'AI',    'Evaluated',    '2026-03-15 10:00:00'),
(13, 13, 2, 'https://drive.google.com/file/d/3mN4oP5qR6sT7uV8wX/view', 'video/mp4', 250, 'AI',    'Evaluated',    '2026-03-22 10:00:00'),
(14, 13, 3, 'https://drive.google.com/file/d/4nO5pQ6rS7tU8vW9xY/view', 'video/mp4', 238, 'AI',    'Evaluated',    '2026-03-29 10:00:00'),
(15, 14, 1, 'https://drive.google.com/file/d/5oP6qR7sT8uV9wX0yZ/view', 'video/mp4', 215, 'HUMAN', 'Evaluated',    '2026-04-12 11:00:00'),
(16, 15, 1, 'https://drive.google.com/file/d/6pQ7rS8tU9vW0xY1zA/view', 'video/mp4', 225, 'AI',    'Under Review', '2026-04-01 14:30:00'),
(17, 16, 1, 'https://drive.google.com/file/d/7qR8sT9uV0wX1yZ2aB/view', 'video/mp4', 235, 'HUMAN', 'Evaluated',    '2026-05-02 09:00:00'),
(18, 19, 1, 'https://drive.google.com/file/d/8rS9tU0vW1xY2zA3bC/view', 'video/mp4', 270, 'AI',    'Submitted',    '2026-04-25 15:00:00');

-- ─── 16. evaluation (18 rows) ──────────────────────────────────────────
-- ~10 AI, ~8 HUMAN.  Submission 12 has two evaluation rounds (eval_no 1 & 2).
-- Attempts on MP 13 show improving scores: 62 → 74.50 → 88.

INSERT INTO evaluation (evaluation_id, submission_id, evaluation_no, evaluator_type, human_evaluator_id, agent_id, overall_score, summary_feedback, evaluated_at) VALUES
( 1,  1, 1, 'AI',    NULL, 2, 72.50, 'Solid informative structure with room for deeper analysis.',                     '2026-02-06 10:00:00'),
( 2,  2, 1, 'HUMAN', 1,  NULL, 68.00, 'Good demonstration technique; needs smoother transitions between steps.',        '2026-03-01 14:00:00'),
( 3,  3, 1, 'AI',    NULL, 1, 61.50, 'Basic persuasive structure present but thesis needs strengthening.',              '2026-03-19 09:00:00'),
( 4,  4, 1, 'HUMAN', 2,  NULL, 78.00, 'Clear informative content with effective use of examples.',                      '2026-02-12 11:00:00'),
( 5,  5, 1, 'AI',    NULL, 4, 75.25, 'Well-organised demonstration with good audience engagement.',                    '2026-03-03 10:00:00'),
( 6,  6, 1, 'HUMAN', 8,  NULL, 82.00, 'Strong persuasive delivery with compelling evidence throughout.',                '2026-03-26 15:00:00'),
( 7,  7, 1, 'AI',    NULL, 3, 69.00, 'Acceptable impromptu response; structure could be tighter.',                     '2026-04-11 09:00:00'),
( 8,  8, 1, 'AI',    NULL, 2, 85.50, 'Excellent informative speech with strong data presentation.',                    '2026-02-19 10:00:00'),
( 9,  9, 1, 'HUMAN', 12, NULL, 71.00, 'Adequate demonstration; pacing was too fast in the middle section.',             '2026-03-14 11:00:00'),
(10, 10, 1, 'AI',    NULL, 1, 88.00, 'Outstanding persuasive technique with masterful emotional appeal.',              '2026-04-06 10:00:00'),
(11, 11, 1, 'HUMAN', 1,  NULL, 77.50, 'Good impromptu delivery; conclusion could be more impactful.',                   '2026-04-29 14:00:00'),
-- Submission 12: TWO evaluation rounds (eval_no 1 and 2)
(12, 12, 1, 'AI',    NULL, 1, 62.00, 'First attempt shows potential; argument needs more supporting evidence.',         '2026-03-16 10:00:00'),
(13, 12, 2, 'HUMAN', 2,  NULL, 65.00, 'Agrees with AI assessment; recommends focusing on call-to-action clarity.',      '2026-03-17 14:00:00'),
-- Improving scores across attempts on MP 13: 62 → 74.50 → 88
(14, 13, 1, 'AI',    NULL, 1, 74.50, 'Marked improvement in argument structure over previous attempt.',                '2026-03-23 10:00:00'),
(15, 14, 1, 'AI',    NULL, 1, 88.00, 'Excellent final attempt; persuasive technique now well above passing threshold.', '2026-03-30 10:00:00'),
(16, 15, 1, 'HUMAN', 8,  NULL, 70.00, 'Informative content is solid; needs better transitions.',                        '2026-04-13 15:00:00'),
(17, 17, 1, 'HUMAN', 4,  NULL, 79.00, 'Strong persuasive delivery with clear thesis and supporting points.',            '2026-05-03 11:00:00'),
(18, 16, 1, 'AI',    NULL, 1, 66.50, 'Persuasive structure present but evidence is generic. Cite specific sources.',   '2026-04-02 10:00:00');

-- ─── 17. evaluation_skill_score (72 rows) ──────────────────────────────
-- 4 criterion scores per evaluation, using the criteria of that submission's format.
-- Format → criteria mapping:
--   Persuasive (1): criterion_ids 1, 2, 3, 4
--   Informative (2): criterion_ids 5, 6, 7, 8
--   Impromptu (3): criterion_ids 9, 10, 11, 12
--   Demonstrative (4): criterion_ids 13, 14, 15, 16

INSERT INTO evaluation_skill_score (evaluation_id, criterion_id, score, feedback) VALUES
-- Eval 1 (sub 1, Informative, overall 72.50)
(1, 5, 75.00, 'Good topic organisation with clear sections'),
(1, 6, 70.00, 'Adequate delivery; could use more vocal variety'),
(1, 7, 74.00, 'Information was mostly clear and accessible'),
(1, 8, 68.00, 'Minimal gestures; consider using visual aids'),
-- Eval 2 (sub 2, Demonstrative, overall 68.00)
(2, 13, 70.00, 'Steps were in logical order'),
(2, 14, 65.00, 'Enthusiasm dipped during the middle steps'),
(2, 15, 72.00, 'Instructions were understandable'),
(2, 16, 62.00, 'Physical demonstration was hesitant at times'),
-- Eval 3 (sub 3, Persuasive, overall 61.50)
(3, 1, 60.00, 'Thesis was stated but not clearly positioned'),
(3, 2, 63.00, 'Delivery was steady but lacked conviction'),
(3, 3, 65.00, 'Language was clear but arguments were surface-level'),
(3, 4, 58.00, 'Persuasive appeal was weak; needs stronger evidence'),
-- Eval 4 (sub 4, Informative, overall 78.00)
(4, 5, 80.00, 'Well-structured with smooth transitions'),
(4, 6, 76.00, 'Engaging tone that held audience attention'),
(4, 7, 79.00, 'Complex ideas explained effectively'),
(4, 8, 75.00, 'Good posture and purposeful hand movements'),
-- Eval 5 (sub 5, Demonstrative, overall 75.25)
(5, 13, 78.00, 'Clear step-by-step progression'),
(5, 14, 74.00, 'Good energy throughout the demonstration'),
(5, 15, 76.00, 'Audience could follow and replicate the process'),
(5, 16, 72.00, 'Spatial awareness was adequate'),
-- Eval 6 (sub 6, Persuasive, overall 82.00)
(6, 1, 80.00, 'Strong introduction and well-organised arguments'),
(6, 2, 84.00, 'Excellent vocal variety and confident delivery'),
(6, 3, 81.00, 'Ideas expressed with precision'),
(6, 4, 83.00, 'Compelling emotional and logical appeals'),
-- Eval 7 (sub 7, Impromptu, overall 69.00)
(7,  9, 72.00, 'Maintained composure despite limited prep time'),
(7, 10, 68.00, 'Some ideas lacked coherence'),
(7, 11, 66.00, 'Position was stated but not strongly defended'),
(7, 12, 70.00, 'Body language was natural and relaxed'),
-- Eval 8 (sub 8, Informative, overall 85.50)
(8, 5, 88.00, 'Excellent structure with compelling narrative arc'),
(8, 6, 84.00, 'Dynamic delivery with effective pauses'),
(8, 7, 86.00, 'Data presented with exceptional clarity'),
(8, 8, 82.00, 'Good use of gestures to emphasise key points'),
-- Eval 9 (sub 9, Demonstrative, overall 71.00)
(9, 13, 73.00, 'Logical order but some steps were rushed'),
(9, 14, 69.00, 'Pacing was too fast in the middle section'),
(9, 15, 74.00, 'Mostly clear instructions with minor ambiguity'),
(9, 16, 66.00, 'Limited movement; stayed behind the podium'),
-- Eval 10 (sub 10, Persuasive, overall 88.00)
(10, 1, 86.00, 'Masterful organisation with a powerful conclusion'),
(10, 2, 90.00, 'Outstanding delivery with commanding presence'),
(10, 3, 87.00, 'Every point was crystal clear'),
(10, 4, 89.00, 'Persuasive technique was highly effective'),
-- Eval 11 (sub 11, Impromptu, overall 77.50)
(11,  9, 79.00, 'Confident and composed under time pressure'),
(11, 10, 78.00, 'Ideas were well-articulated and coherent'),
(11, 11, 74.00, 'Good but could strengthen the closing argument'),
(11, 12, 76.00, 'Natural gestures and good eye contact'),
-- Eval 12 (sub 12, Persuasive, overall 62.00 — first attempt)
(12, 1, 63.00, 'Basic structure present but needs clearer thesis'),
(12, 2, 60.00, 'Delivery lacked confidence and vocal variety'),
(12, 3, 64.00, 'Ideas were understandable but not compelling'),
(12, 4, 58.00, 'Call to action was vague and unconvincing'),
-- Eval 13 (sub 12 round 2, Persuasive, overall 65.00)
(13, 1, 66.00, 'Agrees thesis needs more precision'),
(13, 2, 63.00, 'Delivery was earnest but still tentative'),
(13, 3, 67.00, 'Clarity improved over AI assessment reading'),
(13, 4, 62.00, 'Evidence is there but not woven into narrative'),
-- Eval 14 (sub 13, Persuasive, overall 74.50 — second attempt, improving)
(14, 1, 75.00, 'Structure has improved significantly'),
(14, 2, 73.00, 'More confident delivery with better pacing'),
(14, 3, 76.00, 'Arguments are clearer and better supported'),
(14, 4, 72.00, 'Persuasive appeal is stronger; keep refining'),
-- Eval 15 (sub 14, Persuasive, overall 88.00 — third attempt, best)
(15, 1, 87.00, 'Excellent structure with a powerful opening'),
(15, 2, 89.00, 'Confident, dynamic delivery throughout'),
(15, 3, 88.00, 'Every argument was precise and well-supported'),
(15, 4, 90.00, 'Masterful persuasion; outstanding improvement'),
-- Eval 16 (sub 15, Informative, overall 70.00)
(16, 5, 72.00, 'Adequate structure with minor gaps'),
(16, 6, 68.00, 'Delivery could be more engaging'),
(16, 7, 71.00, 'Information was clear but lacked depth'),
(16, 8, 67.00, 'Minimal body language variation'),
-- Eval 17 (sub 17, Persuasive, overall 79.00)
(17, 1, 78.00, 'Clear thesis with well-organised arguments'),
(17, 2, 80.00, 'Confident delivery with good vocal range'),
(17, 3, 79.00, 'Ideas communicated effectively'),
(17, 4, 77.00, 'Good persuasive technique with room to grow'),
-- Eval 18 (sub 16, Persuasive, overall 66.50)
(18, 1, 68.00, 'Structure is acceptable but predictable'),
(18, 2, 65.00, 'Delivery was flat; needs more energy'),
(18, 3, 67.00, 'Arguments were clear but lacked specificity'),
(18, 4, 64.00, 'Persuasive elements were generic');

-- ─── 18. user_milestone (8 rows) ───────────────────────────────────────

INSERT INTO user_milestone (user_id, milestone_id, achieved_at) VALUES
(5,  1, '2026-03-10 14:00:00'),  -- Ahsanuzzaman: Beginner Halfway
(5,  2, '2026-04-15 16:00:00'),  -- Ahsanuzzaman: Beginner Complete
(6,  1, '2026-03-20 14:00:00'),  -- Farhan: Beginner Halfway
(6,  2, '2026-05-10 14:30:00'),  -- Farhan: Beginner Complete
(4,  1, '2026-03-05 15:00:00'),  -- Ahnaf: Beginner Halfway
(7,  3, '2026-04-01 16:00:00'),  -- Nusrat: Intermediate Halfway
(11, 5, '2026-05-01 14:00:00'),  -- Farhana: Advanced Halfway
(4,  3, '2026-05-10 15:00:00');  -- Ahnaf: Intermediate Halfway

-- ─── 19. community (3 rows) ───────────────────────────────────────────

INSERT INTO community (community_id, created_by_user_id, name, description) VALUES
(1, 10, 'Dhaka Speakers Circle',        'A community of public speaking enthusiasts in Dhaka practising weekly.'),
(2,  3, 'NSU Communication Society',    'North South University student group focused on communication skills.'),
(3,  2, 'Corporate Presenters BD',      'Professionals improving business presentation and pitching skills.');

-- ─── 20. community_membership (18 rows) ───────────────────────────────

INSERT INTO community_membership (community_id, user_id, membership_status, joined_at) VALUES
-- Dhaka Speakers Circle (7 members)
(1,  1, 'Active',  '2026-01-10 09:00:00'),
(1,  2, 'Active',  '2026-01-12 10:00:00'),
(1,  3, 'Active',  '2026-01-15 11:00:00'),
(1,  4, 'Active',  '2026-01-18 14:00:00'),
(1,  5, 'Active',  '2026-02-01 09:30:00'),
(1,  6, 'Pending', '2026-03-05 10:00:00'),
(1, 10, 'Active',  '2026-01-05 08:00:00'),
-- NSU Communication Society (6 members)
(2,  3, 'Active',  '2026-02-01 10:00:00'),
(2,  4, 'Active',  '2026-02-05 11:00:00'),
(2,  5, 'Active',  '2026-02-10 09:00:00'),
(2,  7, 'Active',  '2026-02-15 14:00:00'),
(2,  9, 'Pending', '2026-03-20 10:00:00'),
(2, 11, 'Active',  '2026-02-20 11:00:00'),
-- Corporate Presenters BD (5 members)
(3,  1, 'Active',  '2026-03-01 09:00:00'),
(3,  2, 'Active',  '2026-03-01 09:00:00'),
(3,  8, 'Active',  '2026-03-10 10:00:00'),
(3, 10, 'Pending', '2026-04-01 14:00:00'),
(3, 12, 'Active',  '2026-03-15 11:00:00');

-- ─── 21. community_event (6 rows) ─────────────────────────────────────
-- Mix of In-Person, Online, Hybrid. One Cancelled event.

INSERT INTO community_event (event_id, community_id, organizer_user_id, title, description, event_mode, start_at, end_at, venue, meeting_url, capacity, event_status) VALUES
(1, 1, 10, 'Annual Speech Competition 2026',
    'The flagship annual competition featuring all four speech formats.',
    'In-Person', '2026-09-15 09:00:00', '2026-09-15 17:00:00',
    'Dhaka University TSC Auditorium, Dhaka', NULL, 100, 'Scheduled'),
(2, 1, 10, 'Monthly Practice Meetup — September',
    'Informal practice session for members to rehearse upcoming speeches.',
    'Hybrid', '2026-09-05 18:00:00', '2026-09-05 20:00:00',
    'Dhanmondi Community Center, Dhaka', 'https://meet.google.com/abc-defg-hij', 30, 'Scheduled'),
(3, 2,  3, 'Debate Workshop for Beginners',
    'Hands-on workshop covering basic debate formats and argumentation.',
    'Online', '2026-06-10 15:00:00', '2026-06-10 17:30:00',
    NULL, 'https://zoom.us/j/9876543210', 50, 'Completed'),
(4, 2,  3, 'Impromptu Speaking Challenge',
    'Timed impromptu rounds with peer feedback and scoring.',
    'In-Person', '2026-07-20 14:00:00', '2026-07-20 16:00:00',
    'NSU Auditorium, Bashundhara, Dhaka', NULL, 40, 'Cancelled'),
(5, 3,  2, 'Corporate Pitch Night',
    'Members pitch business ideas in 5-minute presentations to a panel.',
    'In-Person', '2026-10-01 18:30:00', '2026-10-01 21:00:00',
    'Radisson Blu Water Garden, Dhaka', NULL, 60, 'Scheduled'),
(6, 3,  2, 'Virtual Storytelling Workshop',
    'Learn the art of storytelling for corporate presentations.',
    'Online', '2026-08-25 19:00:00', '2026-08-25 21:00:00',
    NULL, 'https://meet.google.com/xyz-abcd-efg', 25, 'Scheduled');

-- ─── 22. event_registration (20 rows) ─────────────────────────────────
-- Mix of Confirmed, Waitlisted, Cancelled, Attended.

INSERT INTO event_registration (event_id, user_id, registration_status, registered_at) VALUES
-- Event 1: Annual Speech Competition (6 registrations)
(1,  1, 'Confirmed',  '2026-08-20 09:00:00'),
(1,  2, 'Confirmed',  '2026-08-20 10:00:00'),
(1,  3, 'Confirmed',  '2026-08-21 11:00:00'),
(1,  4, 'Confirmed',  '2026-08-22 09:30:00'),
(1,  5, 'Waitlisted', '2026-08-25 14:00:00'),
(1,  6, 'Confirmed',  '2026-08-23 10:00:00'),
-- Event 2: Monthly Practice Meetup (3 registrations)
(2,  1, 'Confirmed',  '2026-08-28 09:00:00'),
(2,  3, 'Confirmed',  '2026-08-28 11:00:00'),
(2, 10, 'Confirmed',  '2026-08-27 08:00:00'),
-- Event 3: Debate Workshop — Completed (5 registrations)
(3,  4, 'Attended',   '2026-06-01 10:00:00'),
(3,  5, 'Attended',   '2026-06-02 09:00:00'),
(3,  7, 'Attended',   '2026-06-03 14:00:00'),
(3,  9, 'Attended',   '2026-06-05 11:00:00'),
(3, 11, 'Attended',   '2026-06-04 10:00:00'),
-- Event 4: Impromptu Challenge — Cancelled (2 registrations)
(4,  3, 'Cancelled',  '2026-07-10 09:00:00'),
(4,  7, 'Cancelled',  '2026-07-12 14:00:00'),
-- Event 5: Corporate Pitch Night (3 registrations)
(5,  1, 'Confirmed',  '2026-09-15 09:00:00'),
(5,  2, 'Confirmed',  '2026-09-15 10:00:00'),
(5,  8, 'Waitlisted', '2026-09-18 11:00:00'),
-- Event 6: Virtual Storytelling Workshop (1 registration)
(6, 10, 'Confirmed',  '2026-08-18 14:00:00');
