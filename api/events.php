<?php
/**
 * api/events.php — Full CRUD for community_event.
 * GET enriches with community name, organizer name, and registration counts.
 * POST also handles event_registration (create + read) via ?resource=registrations.
 */

require_once __DIR__ . '/db.php';

$resource = $_GET['resource'] ?? null;

// ── Event Registrations sub-resource ────────────────────────────────────
if ($resource === 'registrations') {
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $eventId = $_GET['event_id'] ?? null;
        try {
            if ($eventId) {
                $stmt = $pdo->prepare("
                    SELECT er.*, ua.full_name, ua.email
                      FROM event_registration er
                      JOIN user_account ua ON er.user_id = ua.user_id
                     WHERE er.event_id = :eid
                     ORDER BY er.registered_at
                ");
                $stmt->execute([':eid' => $eventId]);
            } else {
                $stmt = $pdo->query("
                    SELECT er.*, ua.full_name, ua.email, ce.title AS event_title
                      FROM event_registration er
                      JOIN user_account ua ON er.user_id = ua.user_id
                      JOIN community_event ce ON er.event_id = ce.event_id
                     ORDER BY er.registered_at DESC
                ");
            }
            json_success($stmt->fetchAll());
        } catch (PDOException $e) {
            json_error(translate_mysql_error($e), 422);
        }
    }

    if ($method === 'POST') {
        $body = json_decode(file_get_contents('php://input'), true);
        if (!$body) {
            json_error('Request body must be valid JSON.');
        }

        $eventId = $body['event_id']   ?? null;
        $userId  = $body['user_id']    ?? null;
        $status  = $body['registration_status'] ?? 'Confirmed';
        $regAt   = $body['registered_at'] ?? date('Y-m-d H:i:s');

        if (!$eventId || !$userId) {
            json_error('event_id and user_id are required.');
        }

        try {
            // If confirming, check capacity
            if ($status === 'Confirmed') {
                $capStmt = $pdo->prepare("SELECT capacity FROM community_event WHERE event_id = :eid");
                $capStmt->execute([':eid' => $eventId]);
                $event = $capStmt->fetch();
                if (!$event) {
                    json_error('Event not found.', 404);
                }
                if ($event['capacity'] !== null) {
                    $countStmt = $pdo->prepare("
                        SELECT COUNT(*) AS cnt FROM event_registration
                         WHERE event_id = :eid AND registration_status = 'Confirmed'
                    ");
                    $countStmt->execute([':eid' => $eventId]);
                    $count = $countStmt->fetch()['cnt'];
                    if ($count >= (int)$event['capacity']) {
                        json_error('Event is at full capacity. Registration set to Waitlisted.', 422);
                    }
                }
            }

            $stmt = $pdo->prepare("
                INSERT INTO event_registration (event_id, user_id, registration_status, registered_at)
                VALUES (:eid, :uid, :status, :rat)
            ");
            $stmt->execute([
                ':eid'    => $eventId,
                ':uid'    => $userId,
                ':status' => $status,
                ':rat'    => $regAt,
            ]);

            $fetch = $pdo->prepare("
                SELECT er.*, ua.full_name, ua.email
                  FROM event_registration er
                  JOIN user_account ua ON er.user_id = ua.user_id
                 WHERE er.event_id = :eid AND er.user_id = :uid
            ");
            $fetch->execute([':eid' => $eventId, ':uid' => $userId]);
            json_success($fetch->fetch(), 201);
        } catch (PDOException $e) {
            json_error(translate_mysql_error($e), 422);
        }
    }

    json_error('Method not allowed.', 405);
}

// ── Community Events CRUD ───────────────────────────────────────────────

$listQuery = "
    SELECT ce.*,
           com.name          AS community_name,
           ua.full_name      AS organizer_name,
           (SELECT COUNT(*) FROM event_registration er
             WHERE er.event_id = ce.event_id
               AND er.registration_status IN ('Confirmed','Attended')) AS confirmed_count
      FROM community_event ce
      JOIN community com    ON ce.community_id = com.community_id
      JOIN user_account ua  ON ce.organizer_user_id = ua.user_id
     ORDER BY ce.start_at DESC
";

$itemQuery = "
    SELECT ce.*,
           com.name          AS community_name,
           ua.full_name      AS organizer_name,
           (SELECT COUNT(*) FROM event_registration er
             WHERE er.event_id = ce.event_id
               AND er.registration_status IN ('Confirmed','Attended')) AS confirmed_count
      FROM community_event ce
      JOIN community com    ON ce.community_id = com.community_id
      JOIN user_account ua  ON ce.organizer_user_id = ua.user_id
     WHERE ce.event_id = :id
";

crud($pdo, 'community_event', 'event_id', [
    'community_id',
    'organizer_user_id',
    'title',
    'description',
    'event_mode',
    'start_at',
    'end_at',
    'venue',
    'meeting_url',
    'capacity',
    'event_status',
], [
    'list_query' => $listQuery,
    'item_query' => $itemQuery,
]);
