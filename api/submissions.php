<?php
/**
 * api/submissions.php — Full CRUD for speech_submission.
 * GET enriches with learner info, module/curriculum context, and evaluation summaries.
 */

require_once __DIR__ . '/db.php';

$listQuery = "
    SELECT ss.*,
           mp.enrollment_id,
           mp.module_id,
           cm.title       AS module_title,
           cm.curriculum_id,
           c.title         AS curriculum_title,
           ua.full_name    AS learner_name,
           ce.learner_id
      FROM speech_submission ss
      JOIN module_progress mp      ON ss.module_progress_id = mp.module_progress_id
      JOIN curriculum_module cm    ON mp.module_id = cm.module_id
      JOIN curriculum c            ON cm.curriculum_id = c.curriculum_id
      JOIN curriculum_enrollment ce ON mp.enrollment_id = ce.enrollment_id
      JOIN user_account ua         ON ce.learner_id = ua.user_id
     ORDER BY ss.submitted_at DESC
";

$itemQuery = "
    SELECT ss.*,
           mp.enrollment_id,
           mp.module_id,
           cm.title       AS module_title,
           cm.curriculum_id,
           c.title         AS curriculum_title,
           ua.full_name    AS learner_name,
           ce.learner_id
      FROM speech_submission ss
      JOIN module_progress mp      ON ss.module_progress_id = mp.module_progress_id
      JOIN curriculum_module cm    ON mp.module_id = cm.module_id
      JOIN curriculum c            ON cm.curriculum_id = c.curriculum_id
      JOIN curriculum_enrollment ce ON mp.enrollment_id = ce.enrollment_id
      JOIN user_account ua         ON ce.learner_id = ua.user_id
     WHERE ss.submission_id = :id
";

crud($pdo, 'speech_submission', 'submission_id', [
    'module_progress_id',
    'attempt_no',
    'video_uri',
    'mime_type',
    'duration_seconds',
    'requested_evaluator_type',
    'submission_status',
    'submitted_at',
], [
    'list_query' => $listQuery,
    'item_query' => $itemQuery,
]);
