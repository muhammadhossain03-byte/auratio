<?php
/**
 * api/db.php — PDO connection, JSON helpers, error translator, shared CRUD.
 *
 * Every endpoint includes this file and calls crud() with a table name
 * and a hardcoded allowed-column list. Column names never come from
 * request data.
 */

// ── CORS & Headers ──────────────────────────────────────────────────────
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// ── PDO Connection ──────────────────────────────────────────────────────
try {
    $pdo = new PDO(
        'mysql:host=127.0.0.1;port=3307;dbname=auratio_db;charset=utf8mb4',
        'root',
        '',
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'ok'    => false,
        'error' => ['message' => 'Database connection failed.'],
    ]);
    exit;
}

// ── JSON Response Helpers ───────────────────────────────────────────────

function json_success($data, int $code = 200): void {
    http_response_code($code);
    echo json_encode(['ok' => true, 'data' => $data], JSON_UNESCAPED_UNICODE);
    exit;
}

function json_error(string $message, int $code = 400): void {
    http_response_code($code);
    echo json_encode([
        'ok'    => false,
        'error' => ['message' => $message],
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// ── MySQL Error Translation ─────────────────────────────────────────────

function translate_mysql_error(PDOException $e): string {
    $code = (int) $e->errorInfo[1];
    $msg  = $e->errorInfo[2] ?? $e->getMessage();

    switch ($code) {
        case 1062:
            // Extract the key name for a friendlier message
            if (preg_match("/for key '([^']+)'/", $msg, $m)) {
                $key = $m[1];
                if (stripos($key, 'email') !== false) {
                    return 'That email is already registered.';
                }
                if (stripos($key, 'curriculum_code') !== false) {
                    return 'That curriculum code is already in use.';
                }
                if (stripos($key, 'uq_attempt') !== false) {
                    return 'That attempt number already exists for this module progress.';
                }
                if (stripos($key, 'uq_eval_no') !== false) {
                    return 'That evaluation number already exists for this submission.';
                }
                if (stripos($key, 'uq_enrollment') !== false) {
                    return 'This learner is already enrolled in that curriculum.';
                }
                return "A record with that value already exists (constraint: $key).";
            }
            return 'Duplicate entry — a record with that value already exists.';

        case 1451:
            return 'Cannot delete — other records reference this row.';

        case 1452:
            return 'Invalid reference — the referenced record does not exist.';

        case 3819:
            // CHECK constraint violation
            if (preg_match("/Constraint '([^']+)'/i", $msg, $m)) {
                return translate_check_constraint($m[1]);
            }
            if (preg_match("/Check constraint '([^']+)'/i", $msg, $m)) {
                return translate_check_constraint($m[1]);
            }
            return 'A data validation rule was violated.';

        case 4025:
            // MariaDB CHECK constraint violation
            if (preg_match("/CONSTRAINT `([^`]+)`/i", $msg, $m)) {
                return translate_check_constraint($m[1]);
            }
            return 'A data validation rule was violated.';

        default:
            return "Database error ($code): $msg";
    }
}

function translate_check_constraint(string $name): string {
    $map = [
        'chk_ev_source'    => 'Evaluation source is invalid: AI evaluations require an agent_id and no human_evaluator_id; HUMAN evaluations require a human_evaluator_id and no agent_id.',
        'chk_ev_score'     => 'Overall score must be between 0 and 100.',
        'chk_ev_no'        => 'Evaluation number must be greater than 0.',
        'chk_rc_weight'    => 'Weight percent must be between 0 and 100.',
        'chk_rc_max'       => 'Max score must be greater than 0.',
        'chk_cm_seq'       => 'Sequence number must be greater than 0.',
        'chk_cm_pass'      => 'Passing score must be between 0 and 100.',
        'chk_ce_completed' => 'Completed enrollments must have a completed_at date.',
        'chk_mp_completed' => 'Completed module progress must have a completed_at date.',
        'chk_ss_attempt'   => 'Attempt number must be greater than 0.',
        'chk_ss_duration'  => 'Duration must be greater than 0 if provided.',
        'chk_ss_mime'      => "Only 'video/mp4' MIME type is allowed.",
        'chk_cev_dates'    => 'Event end time must be after start time.',
        'chk_cev_capacity' => 'Capacity must be greater than 0 if provided.',
    ];
    return $map[$name] ?? "Constraint '$name' was violated.";
}

// ── Shared CRUD Function ────────────────────────────────────────────────

/**
 * Generic CRUD handler.
 *
 * @param PDO    $pdo          Database connection
 * @param string $table        Table name (hardcoded by caller)
 * @param string $pk           Primary-key column name
 * @param array  $columns      Allowed writable columns (hardcoded list)
 * @param array  $options      Optional overrides:
 *   - 'list_query'  => custom SQL for GET list (replaces SELECT * FROM $table)
 *   - 'item_query'  => custom SQL for GET single (must have :id placeholder)
 *   - 'before_create' => callable($body, $pdo) — returns modified $body
 *   - 'before_update' => callable($body, $id, $pdo) — returns modified $body
 *   - 'allowed_methods' => array of allowed methods, e.g. ['GET','POST']
 */
function crud(PDO $pdo, string $table, string $pk, array $columns, array $options = []): void {
    $method = $_SERVER['REQUEST_METHOD'];
    $allowed = $options['allowed_methods'] ?? ['GET', 'POST', 'PUT', 'DELETE'];

    if (!in_array($method, $allowed, true)) {
        json_error('Method not allowed.', 405);
    }

    try {
        switch ($method) {
            case 'GET':
                crud_read($pdo, $table, $pk, $options);
                break;
            case 'POST':
                crud_create($pdo, $table, $pk, $columns, $options);
                break;
            case 'PUT':
                crud_update($pdo, $table, $pk, $columns, $options);
                break;
            case 'DELETE':
                crud_delete($pdo, $table, $pk);
                break;
        }
    } catch (PDOException $e) {
        json_error(translate_mysql_error($e), 422);
    }
}

// ── CRUD internals ──────────────────────────────────────────────────────

function crud_read(PDO $pdo, string $table, string $pk, array $options): void {
    $id = $_GET['id'] ?? null;

    if ($id !== null) {
        $sql  = $options['item_query'] ?? "SELECT * FROM `$table` WHERE `$pk` = :id";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        if (!$row) {
            json_error('Record not found.', 404);
        }
        json_success($row);
    }

    $sql  = $options['list_query'] ?? "SELECT * FROM `$table`";
    $stmt = $pdo->query($sql);
    json_success($stmt->fetchAll());
}

function crud_create(PDO $pdo, string $table, string $pk, array $columns, array $options): void {
    $body = json_decode(file_get_contents('php://input'), true);
    if (!$body) {
        json_error('Request body must be valid JSON.');
    }

    if (isset($options['before_create'])) {
        $body = ($options['before_create'])($body, $pdo);
    }

    // Only allow columns from the hardcoded list
    $cols = [];
    $vals = [];
    $params = [];
    foreach ($columns as $col) {
        if (array_key_exists($col, $body)) {
            $cols[]   = "`$col`";
            $vals[]   = ":$col";
            $params[":$col"] = $body[$col];
        }
    }

    if (empty($cols)) {
        json_error('No valid fields provided.');
    }

    $colList = implode(', ', $cols);
    $valList = implode(', ', $vals);
    $sql = "INSERT INTO `$table` ($colList) VALUES ($valList)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    $newId = $pdo->lastInsertId();

    // Fetch and return the created row
    $fetch = $pdo->prepare("SELECT * FROM `$table` WHERE `$pk` = :id");
    $fetch->execute([':id' => $newId]);
    json_success($fetch->fetch(), 201);
}

function crud_update(PDO $pdo, string $table, string $pk, array $columns, array $options): void {
    $id = $_GET['id'] ?? null;
    if (!$id) {
        json_error('Missing id parameter.');
    }

    $body = json_decode(file_get_contents('php://input'), true);
    if (!$body) {
        json_error('Request body must be valid JSON.');
    }

    if (isset($options['before_update'])) {
        $body = ($options['before_update'])($body, $id, $pdo);
    }

    // Only allow columns from the hardcoded list
    $sets = [];
    $params = [':id' => $id];
    foreach ($columns as $col) {
        if (array_key_exists($col, $body)) {
            $sets[] = "`$col` = :$col";
            $params[":$col"] = $body[$col];
        }
    }

    if (empty($sets)) {
        json_error('No valid fields provided.');
    }

    $setClause = implode(', ', $sets);
    $sql = "UPDATE `$table` SET $setClause WHERE `$pk` = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    if ($stmt->rowCount() === 0) {
        // Check if the row exists
        $check = $pdo->prepare("SELECT 1 FROM `$table` WHERE `$pk` = :id");
        $check->execute([':id' => $id]);
        if (!$check->fetch()) {
            json_error('Record not found.', 404);
        }
    }

    // Fetch and return the updated row
    $fetch = $pdo->prepare("SELECT * FROM `$table` WHERE `$pk` = :id");
    $fetch->execute([':id' => $id]);
    json_success($fetch->fetch());
}

function crud_delete(PDO $pdo, string $table, string $pk): void {
    $id = $_GET['id'] ?? null;
    if (!$id) {
        json_error('Missing id parameter.');
    }

    // Check existence first
    $check = $pdo->prepare("SELECT 1 FROM `$table` WHERE `$pk` = :id");
    $check->execute([':id' => $id]);
    if (!$check->fetch()) {
        json_error('Record not found.', 404);
    }

    $stmt = $pdo->prepare("DELETE FROM `$table` WHERE `$pk` = :id");
    $stmt->execute([':id' => $id]);
    json_success(['deleted' => true, 'id' => (int) $id]);
}
