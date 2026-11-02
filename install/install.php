<?php
/**
 * LANCMS / ALP installer.
 * Creates the database, loads schema.sql + seed.sql, sets the admin password and
 * writes ../_config.php. Locks itself afterwards (install/DISABLED).
 */
define('LANCMS_RAW_INPUT', 1); // installer needs unescaped input
require_once dirname(__FILE__) . '/../include/_compat.php';

$root = dirname(dirname(__FILE__));
$lock = dirname(__FILE__) . '/DISABLED';
function h($s) { return htmlspecialchars($s, ENT_QUOTES); }

if (file_exists($lock)) {
	exit('Install has already been run. To run it again, delete install/DISABLED first.');
}
if (!function_exists('mysqli_connect')) {
	exit('The PHP "mysqli" extension is not enabled. Enable extension=mysqli in php.ini and reload.');
}

$errors = array();
$done = false;
$v = array('host' => 'localhost', 'user' => 'root', 'pass' => '', 'db' => 'lantastic', 'admin_pass' => '');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	foreach ($v as $k => $_) { $v[$k] = isset($_POST[$k]) ? (string) $_POST[$k] : ''; }
	if (!preg_match('/^[A-Za-z0-9_]+$/', $v['db'])) { $errors[] = 'Database name may only contain letters, numbers and underscores.'; }
	if (strlen($v['admin_pass']) < 8) { $errors[] = 'Choose an admin password of at least 8 characters.'; }

	if (!$errors) {
		$link = @mysqli_connect($v['host'], $v['user'], $v['pass']);
		if (!$link) {
			$errors[] = 'Could not connect: ' . mysqli_connect_error();
		} else {
			$existing = mysqli_query($link, "SHOW DATABASES LIKE '" . mysqli_real_escape_string($link, $v['db']) . "'");
			$exists = $existing && mysqli_num_rows($existing) > 0;
			if ($exists) {
				mysqli_select_db($link, $v['db']);
				$t = mysqli_query($link, 'SHOW TABLES LIKE "users"');
				if ($t && mysqli_num_rows($t) > 0) {
					$errors[] = 'Database "' . h($v['db']) . '" already contains ALP tables. Pick an empty/new database name; nothing was changed.';
				}
			} elseif (!mysqli_query($link, 'CREATE DATABASE `' . $v['db'] . '` CHARACTER SET utf8mb4')) {
				$errors[] = 'Could not create database: ' . mysqli_error($link);
			}
		}
	}

	if (!$errors) {
		mysqli_select_db($link, $v['db']);
		mysqli_set_charset($link, 'utf8mb4');
		foreach (array('schema.sql', 'seed.sql') as $file) {
			$sql = file_get_contents(dirname(__FILE__) . '/' . $file);
			if (mysqli_multi_query($link, $sql)) {
				do { if ($r = mysqli_store_result($link)) { mysqli_free_result($r); } } while (mysqli_more_results($link) && mysqli_next_result($link));
			}
			if (mysqli_errno($link)) { $errors[] = $file . ': ' . mysqli_error($link); break; }
		}
	}

	if (!$errors) {
		$hash = lancms_password_hash($v['admin_pass']);
		mysqli_query($link, "UPDATE users SET passwd='" . mysqli_real_escape_string($link, $hash) . "' WHERE username='admin'");
		mysqli_query($link, "UPDATE settings SET pw='" . mysqli_real_escape_string($link, $hash) . "'"); // online/ admin
		$cfg = "<?php\n// Written by install/install.php\n"
			. "\$database['type']     = 'mysqli';\n"
			. "\$database['user']     = " . var_export($v['user'], true) . ";\n"
			. "\$database['passwd']   = " . var_export($v['pass'], true) . ";\n"
			. "\$database['database'] = " . var_export($v['db'], true) . ";\n"
			. "\$database['server']   = " . var_export($v['host'], true) . ";\n\n"
			. "// Keep -1: the legacy code inserts '' into integer columns, which strict mode rejects.\n"
			. "\$database['strict_mode']   = -1;\n?>\n";
		if (@file_put_contents($root . '/_config.php', $cfg) === false) {
			$errors[] = 'Database created, but _config.php is not writable. Save this as _config.php manually:<pre>' . h($cfg) . '</pre>';
		}
		@file_put_contents($lock, date('c'));
		$done = empty($errors);
	}
}
?><!doctype html>
<html><head><meta charset="utf-8"><title>LANCMS installer</title>
<style>body{font:14px Tahoma,sans-serif;max-width:520px;margin:40px auto;color:#222}label{display:block;margin:10px 0 2px}input{width:100%;padding:5px;box-sizing:border-box}.err{background:#fde;border:1px solid #c66;padding:8px;margin:10px 0}.ok{background:#dfd;border:1px solid #6a6;padding:8px}</style></head>
<body><h2>LANCMS / ALP installer</h2>
<?php if ($done) { ?>
	<div class="ok">Installed. Log in as <b>admin</b> with the password you chose, then delete the <code>install/</code> folder.
	<br><a href="../index.php">Go to the site</a></div>
<?php } else { ?>
	<?php foreach ($errors as $e) { echo '<div class="err">' . (strpos($e, '<pre>') !== false ? $e : h($e)) . '</div>'; } ?>
	<form method="post">
		<label>Database host</label><input name="host" value="<?php echo h($v['host']); ?>">
		<label>Database user</label><input name="user" value="<?php echo h($v['user']); ?>">
		<label>Database password</label><input type="password" name="pass" value="">
		<label>Database name (created if missing; must not already hold ALP tables)</label><input name="db" value="<?php echo h($v['db']); ?>">
		<label>Admin password (for user "admin")</label><input type="password" name="admin_pass" value="">
		<p><button type="submit">Install</button></p>
	</form>
<?php } ?>
</body></html>
