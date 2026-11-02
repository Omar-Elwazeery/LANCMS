<?php
// Load PHP-version compatibility layer first (polyfills for removed functions).
require_once dirname(__FILE__) . '/../../include/_compat.php';

// Pick the database driver. The legacy ext/mysql is gone in PHP 7+, so use mysqli
// whenever it is available regardless of what _config.php asks for.
$__db_type = isset($database['type']) ? strtolower($database['type']) : '';
if (function_exists('mysqli_connect') && ($__db_type == 'mysql' || $__db_type == '' || $__db_type == 'mysqli')) {
	$__db_type = 'mysqli';
} elseif ($__db_type == '') {
	$__db_type = 'mysql';
}
switch ($__db_type) {
	case 'mysql':
		require_once('genesis_mysql.php');
		break;
	case 'mysqli':
		require_once('genesis_mysqli.php');
		break;
	default:
		echo 'Unknown database type set: ' . htmlspecialchars($database['type']);
		exit();
}
?>
