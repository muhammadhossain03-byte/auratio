-- database/verify.sql
-- Seven verification queries from BUILD_PLAN §4.5.
-- Run after schema.sql + seed.sql to confirm database integrity.

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

-- F. At least one user holds multiple roles (must return >= 2 rows)
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
