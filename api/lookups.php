<?php
/**
 * api/lookups.php — Single GET returning every read-only table plus dashboard stats.
 *
 * Dashboard stats (all computed by SQL, none stored):
 *   - Total counts: users, curricula, submissions, evaluations, events, communities
 *   - Completion rate per curriculum
 *   - Average score per speaking skill
 */

require_once __DIR__ . '/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    json_error('Method not allowed.', 405);
}

try {
    $data = [];

    // ── Read-only tables ────────────────────────────────────────────────

    $readOnlyTables = [
        'access_role',
        'access_permission',
        'role_permission',
        'user_role_assignment',
        'speech_format',
        'speaking_skill',
        'rubric_criterion',
        'ai_specialist_agent',
        'curriculum_module',
        'milestone',
        'curriculum_enrollment',
        'module_progress',
        'evaluation_skill_score',
        'user_milestone',
        'community',
        'community_membership',
        'event_registration',
    ];

    foreach ($readOnlyTables as $table) {
        $stmt = $pdo->query("SELECT * FROM `$table`");
        $data[$table] = $stmt->fetchAll();
    }

    // ── Dashboard stats ─────────────────────────────────────────────────

    $stats = [];

    // Total counts
    $countTables = [
        'total_users'       => 'user_account',
        'total_curricula'   => 'curriculum',
        'total_submissions' => 'speech_submission',
        'total_evaluations' => 'evaluation',
        'total_events'      => 'community_event',
        'total_communities' => 'community',
    ];

    foreach ($countTables as $key => $table) {
        $stmt = $pdo->query("SELECT COUNT(*) AS cnt FROM `$table`");
        $stats[$key] = (int) $stmt->fetch()['cnt'];
    }

    // Completion rate per curriculum
    // = (Completed enrollments / Total enrollments) * 100
    $stmt = $pdo->query("
        SELECT c.curriculum_id,
               c.curriculum_code,
               c.title,
               COUNT(ce.enrollment_id) AS total_enrollments,
               SUM(CASE WHEN ce.enrollment_status = 'Completed' THEN 1 ELSE 0 END) AS completed_enrollments,
               ROUND(
                   CASE WHEN COUNT(ce.enrollment_id) = 0 THEN 0
                        ELSE SUM(CASE WHEN ce.enrollment_status = 'Completed' THEN 1 ELSE 0 END)
                             * 100.0 / COUNT(ce.enrollment_id)
                   END, 2
               ) AS completion_rate
          FROM curriculum c
          LEFT JOIN curriculum_enrollment ce ON c.curriculum_id = ce.curriculum_id
         GROUP BY c.curriculum_id, c.curriculum_code, c.title
         ORDER BY c.curriculum_id
    ");
    $stats['completion_rate_per_curriculum'] = $stmt->fetchAll();

    // Average score per speaking skill
    // Joins evaluation_skill_score → rubric_criterion → speaking_skill
    $stmt = $pdo->query("
        SELECT sk.skill_id,
               sk.skill_name,
               ROUND(AVG(ess.score), 2) AS avg_score,
               COUNT(ess.score)          AS score_count
          FROM evaluation_skill_score ess
          JOIN rubric_criterion rc ON ess.criterion_id = rc.criterion_id
          JOIN speaking_skill sk   ON rc.skill_id = sk.skill_id
         GROUP BY sk.skill_id, sk.skill_name
         ORDER BY sk.skill_id
    ");
    $stats['avg_score_per_skill'] = $stmt->fetchAll();

    $data['dashboard_stats'] = $stats;

    json_success($data);

} catch (PDOException $e) {
    json_error(translate_mysql_error($e), 500);
}
