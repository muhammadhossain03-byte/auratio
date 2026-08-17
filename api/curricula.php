<?php
/**
 * api/curricula.php — Full CRUD for curriculum.
 * GET list includes modules (read-only) beneath each curriculum.
 */

require_once __DIR__ . '/db.php';

$method = $_SERVER['REQUEST_METHOD'];
$id     = $_GET['id'] ?? null;

// For GET, return enriched data with modules
if ($method === 'GET') {
    try {
        if ($id !== null) {
            $stmt = $pdo->prepare("SELECT * FROM curriculum WHERE curriculum_id = :id");
            $stmt->execute([':id' => $id]);
            $cur = $stmt->fetch();
            if (!$cur) {
                json_error('Record not found.', 404);
            }

            $modStmt = $pdo->prepare("
                SELECT cm.*, sf.format_name
                  FROM curriculum_module cm
                  JOIN speech_format sf ON cm.format_id = sf.format_id
                 WHERE cm.curriculum_id = :id
                 ORDER BY cm.sequence_no
            ");
            $modStmt->execute([':id' => $id]);
            $cur['modules'] = $modStmt->fetchAll();

            json_success($cur);
        }

        // List all curricula with their modules
        $stmt = $pdo->query("SELECT * FROM curriculum ORDER BY curriculum_id");
        $curricula = $stmt->fetchAll();

        $modStmt = $pdo->prepare("
            SELECT cm.*, sf.format_name
              FROM curriculum_module cm
              JOIN speech_format sf ON cm.format_id = sf.format_id
             WHERE cm.curriculum_id = :cid
             ORDER BY cm.sequence_no
        ");

        foreach ($curricula as &$cur) {
            $modStmt->execute([':cid' => $cur['curriculum_id']]);
            $cur['modules'] = $modStmt->fetchAll();
        }
        unset($cur);

        json_success($curricula);
    } catch (PDOException $e) {
        json_error(translate_mysql_error($e), 422);
    }
}

// POST / PUT / DELETE use the shared crud()
crud($pdo, 'curriculum', 'curriculum_id', [
    'curriculum_code',
    'title',
    'description',
    'difficulty_level',
    'is_active',
]);
