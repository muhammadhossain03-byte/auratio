<?php
/**
 * api/config.sample.php — Database configuration template for hosting.
 *
 * Instructions for Hostinger / Shared Hosting deployment:
 * 1. Copy this file to api/config.php (or rename it):
 *      cp api/config.sample.php api/config.php
 * 2. Update the credentials below with your Hostinger MySQL database details
 *    (created via Hostinger hPanel -> Databases -> Management).
 * 3. Shared hosting uses the standard MySQL port 3306 (unlike local XAMPP port 3307).
 */

return [
    'host'     => 'localhost',              // Hostinger MySQL host (usually 'localhost' or '127.0.0.1')
    'port'     => 3306,                     // Standard MySQL port on hosting (not local port 3307)
    'database' => 'u123456789_auratio_db',  // Hostinger database name (e.g., u123456789_auratio)
    'username' => 'u123456789_auratio_usr', // Hostinger database user (e.g., u123456789_admin)
    'password' => 'YourStrongHostingPasswordHere!', // Hostinger database password
];
