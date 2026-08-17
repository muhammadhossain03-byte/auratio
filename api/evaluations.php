<?php
/**
 * api/evaluations.php — Create + Read only for evaluation.
 *
 * Creating an evaluation must null the unused evaluator column
 * so the chk_ev_source CHECK constraint passes:
 *   AI    → agent_id required, human_evaluator_id must be NULL
 *   HUMAN → human_evaluator_id required, agent_id must be NULL
 */

require_once __DIR__ . '/db.php';

crud($pdo, 'evaluation', 'evaluation_id', [
    'submission_id',
    'evaluation_no',
    'evaluator_type',
    'human_evaluator_id',
    'agent_id',
    'overall_score',
    'summary_feedback',
    'evaluated_at',
], [
    'allowed_methods' => ['GET', 'POST'],

    'list_query' => "
        SELECT ev.*,
               CASE WHEN ev.evaluator_type = 'HUMAN'
                    THEN ua.full_name
                    ELSE ai.agent_name END AS evaluator_name
          FROM evaluation ev
          LEFT JOIN user_account ua       ON ev.human_evaluator_id = ua.user_id
          LEFT JOIN ai_specialist_agent ai ON ev.agent_id = ai.agent_id
         ORDER BY ev.evaluated_at DESC
    ",

    'item_query' => "
        SELECT ev.*,
               CASE WHEN ev.evaluator_type = 'HUMAN'
                    THEN ua.full_name
                    ELSE ai.agent_name END AS evaluator_name
          FROM evaluation ev
          LEFT JOIN user_account ua       ON ev.human_evaluator_id = ua.user_id
          LEFT JOIN ai_specialist_agent ai ON ev.agent_id = ai.agent_id
         WHERE ev.evaluation_id = :id
    ",

    'before_create' => function (array $body, PDO $pdo): array {
        $type = $body['evaluator_type'] ?? null;

        if (!$type || !in_array($type, ['AI', 'HUMAN'], true)) {
            json_error('evaluator_type must be AI or HUMAN.');
        }

        // Enforce XOR: null out the unused column
        if ($type === 'AI') {
            if (empty($body['agent_id'])) {
                json_error('AI evaluations require an agent_id.');
            }
            // Both filled? Reject explicitly for a clear message.
            if (!empty($body['human_evaluator_id'])) {
                json_error('Cannot set both agent_id and human_evaluator_id. AI evaluations require only agent_id.');
            }
            $body['human_evaluator_id'] = null;
        } else {
            // HUMAN
            if (empty($body['human_evaluator_id'])) {
                json_error('HUMAN evaluations require a human_evaluator_id.');
            }
            if (!empty($body['agent_id'])) {
                json_error('Cannot set both agent_id and human_evaluator_id. HUMAN evaluations require only human_evaluator_id.');
            }
            $body['agent_id'] = null;
        }

        return $body;
    },
]);
