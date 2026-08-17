<?php
/**
 * api/users.php — Full CRUD for user_account.
 * GET list includes role chips via user_role_assignment + access_role.
 */

require_once __DIR__ . '/db.php';

crud($pdo, 'user_account', 'user_id', [
    'full_name',
    'email',
    'password_hash',
    'bio',
    'account_status',
], [
    'list_query' => "
        SELECT u.*,
               GROUP_CONCAT(ar.role_name ORDER BY ar.role_name SEPARATOR ', ') AS roles
          FROM user_account u
          LEFT JOIN user_role_assignment ura ON u.user_id = ura.user_id
          LEFT JOIN access_role ar           ON ura.role_id = ar.role_id
         GROUP BY u.user_id
         ORDER BY u.user_id
    ",
    'item_query' => "
        SELECT u.*,
               GROUP_CONCAT(ar.role_name ORDER BY ar.role_name SEPARATOR ', ') AS roles
          FROM user_account u
          LEFT JOIN user_role_assignment ura ON u.user_id = ura.user_id
          LEFT JOIN access_role ar           ON ura.role_id = ar.role_id
         WHERE u.user_id = :id
         GROUP BY u.user_id
    ",
]);
