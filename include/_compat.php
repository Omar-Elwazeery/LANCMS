<?php
/**
 * LANCMS / ALP compatibility layer.
 *
 * Lets the legacy (PHP 4 / 5.0 era) code base run unchanged on PHP 5.3 - 8.x.
 * Every polyfill is guarded with function_exists(), so on an old PHP that still
 * has the real function nothing is replaced. Safe to include more than once.
 */
if (defined('LANCMS_COMPAT_LOADED')) { return; }
define('LANCMS_COMPAT_LOADED', 1);

// ---------------------------------------------------------------------------
// Error handling: legacy code emits lots of notices / undefined-index warnings
// that are fatal-noise on PHP 8. Keep real errors visible, log the rest.
// ---------------------------------------------------------------------------
$GLOBALS['lancms_compat_log'] = dirname(dirname(__FILE__)) . DIRECTORY_SEPARATOR . 'error_compat.log';
@error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED & ~(defined('E_USER_DEPRECATED') ? E_USER_DEPRECATED : 0));
if (!function_exists('lancms_error_handler')) {
	function lancms_error_handler($no, $str, $file = '', $line = 0) {
		$soft = E_WARNING | E_USER_WARNING;
		if (($no & $soft) && (error_reporting() & $no)) {
			// swallow warnings from display, append to a log instead
			if (defined('LANCMS_DEBUG') && LANCMS_DEBUG) {
				@error_log(date('c') . " [$no] $str in $file:$line\n", 3, $GLOBALS['lancms_compat_log']);
			}
			return true;
		}
		return false; // let PHP handle everything else
	}
	set_error_handler('lancms_error_handler');
}

// mysqli throws exceptions by default on PHP 8.1+; the legacy code checks return values.
if (function_exists('mysqli_report')) { @mysqli_report(MYSQLI_REPORT_OFF); }

// ---------------------------------------------------------------------------
// Magic quotes (removed in 8.0 / always off since 5.4)
//
// ALP was written for magic_quotes_gpc = On: request input reaches the SQL
// strings already escaped, and $dbc->quote() skips escaping when
// get_magic_quotes_gpc() is true. Without it every query that concatenates
// $_GET / $_POST / $_COOKIE is injectable, so emulate it once here.
// Define LANCMS_RAW_INPUT before including this file to opt out (installer).
// ---------------------------------------------------------------------------
if (!function_exists('lancms_escape_input')) {
	function lancms_escape_input($v) {
		if (is_array($v)) {
			$out = array();
			foreach ($v as $k => $x) { $out[is_string($k) ? addslashes($k) : $k] = lancms_escape_input($x); }
			return $out;
		}
		return is_string($v) ? addslashes($v) : $v;
	}
}
if (!defined('LANCMS_RAW_INPUT') && !(function_exists('get_magic_quotes_gpc') && @get_magic_quotes_gpc())) {
	$_GET     = lancms_escape_input($_GET);
	$_POST    = lancms_escape_input($_POST);
	$_COOKIE  = lancms_escape_input($_COOKIE);
	$_REQUEST = lancms_escape_input($_REQUEST);
	if (!function_exists('get_magic_quotes_gpc')) { function get_magic_quotes_gpc() { return true; } }
} elseif (!function_exists('get_magic_quotes_gpc')) {
	function get_magic_quotes_gpc() { return false; }
}
if (!function_exists('get_magic_quotes_runtime')) { function get_magic_quotes_runtime() { return false; } }
if (!function_exists('set_magic_quotes_runtime')) { function set_magic_quotes_runtime($v) { return false; } }

// ---------------------------------------------------------------------------
// POSIX regex functions (removed in 7.0)
// ---------------------------------------------------------------------------
if (!function_exists('lancms_posix_to_pcre')) {
	function lancms_posix_to_pcre($pattern, $ci = false) {
		return '~' . str_replace('~', '\\~', $pattern) . '~' . ($ci ? 'i' : '');
	}
}
if (!function_exists('ereg')) {
	function ereg($pattern, $string, &$regs = null) {
		$r = @preg_match(lancms_posix_to_pcre($pattern), $string, $m);
		if ($r) { $regs = $m; return strlen($m[0]) ? strlen($m[0]) : 1; }
		$regs = array();
		return false;
	}
}
if (!function_exists('eregi')) {
	function eregi($pattern, $string, &$regs = null) {
		$r = @preg_match(lancms_posix_to_pcre($pattern, true), $string, $m);
		if ($r) { $regs = $m; return strlen($m[0]) ? strlen($m[0]) : 1; }
		$regs = array();
		return false;
	}
}
if (!function_exists('ereg_replace'))  { function ereg_replace($p, $r, $s)  { return preg_replace(lancms_posix_to_pcre($p), $r, $s); } }
if (!function_exists('eregi_replace')) { function eregi_replace($p, $r, $s) { return preg_replace(lancms_posix_to_pcre($p, true), $r, $s); } }
if (!function_exists('split'))  { function split($p, $s, $limit = -1)  { return preg_split(lancms_posix_to_pcre($p), $s, $limit); } }
if (!function_exists('spliti')) { function spliti($p, $s, $limit = -1) { return preg_split(lancms_posix_to_pcre($p, true), $s, $limit); } }

// ---------------------------------------------------------------------------
// each() (removed in 8.0)
// ---------------------------------------------------------------------------
if (!function_exists('each')) {
	function each(&$array) {
		if (!is_array($array)) { return false; }
		$key = key($array);
		if ($key === null) { return false; }
		$value = current($array);
		next($array);
		return array(1 => $value, 'value' => $value, 0 => $key, 'key' => $key);
	}
}

// ---------------------------------------------------------------------------
// create_function() (removed in 8.0) - only the trivial form used by this code
// base is supported; prefer closures in new code.
// ---------------------------------------------------------------------------
if (!function_exists('create_function')) {
	function create_function($args, $code) {
		static $n = 0;
		$name = 'lancms_lambda_' . (++$n);
		eval('function ' . $name . '(' . $args . ') {' . $code . '}');
		return $name;
	}
}

// ---------------------------------------------------------------------------
// Session registration (removed in 5.4)
// ---------------------------------------------------------------------------
if (!function_exists('session_register')) {
	function session_register() {
		if (session_id() === '') { @session_start(); }
		foreach (func_get_args() as $name) {
			if (is_string($name) && !isset($_SESSION[$name])) { $_SESSION[$name] = null; }
		}
		return true;
	}
}
if (!function_exists('session_is_registered')) {
	function session_is_registered($name) { return isset($_SESSION) && array_key_exists($name, $_SESSION); }
}
if (!function_exists('session_unregister')) {
	function session_unregister($name) { unset($_SESSION[$name]); return true; }
}

// ---------------------------------------------------------------------------
// ext/mysql (removed in 7.0) implemented on top of mysqli
// ---------------------------------------------------------------------------
if (!function_exists('mysql_connect') && function_exists('mysqli_connect')) {
	if (!defined('MYSQL_ASSOC')) { define('MYSQL_ASSOC', 1); }
	if (!defined('MYSQL_NUM'))   { define('MYSQL_NUM', 2); }
	if (!defined('MYSQL_BOTH'))  { define('MYSQL_BOTH', 3); }
	$GLOBALS['lancms_mysql_link'] = null;

	function lancms_mysql_link($l = null) {
		if ($l !== null) { return $l; }
		return $GLOBALS['lancms_mysql_link'];
	}
	function mysql_connect($host = null, $user = null, $pass = null) {
		$port = null;
		if (is_string($host) && strpos($host, ':') !== false) {
			list($host, $port) = explode(':', $host, 2);
			$port = (int) $port;
		}
		$l = $port ? @mysqli_connect($host, $user, $pass, '', $port) : @mysqli_connect($host, $user, $pass);
		if ($l) { $GLOBALS['lancms_mysql_link'] = $l; }
		return $l;
	}
	function mysql_pconnect($h = null, $u = null, $p = null) { return mysql_connect($h, $u, $p); }
	function mysql_select_db($db, $l = null)     { return @mysqli_select_db(lancms_mysql_link($l), $db); }
	function mysql_query($q, $l = null)          { return @mysqli_query(lancms_mysql_link($l), $q); }
	function mysql_unbuffered_query($q, $l = null) { return mysql_query($q, $l); }
	function mysql_set_charset($cs, $l = null)   { return @mysqli_set_charset(lancms_mysql_link($l), $cs); }
	function mysql_fetch_array($r, $t = 3) {
		$map = array(1 => MYSQLI_ASSOC, 2 => MYSQLI_NUM, 3 => MYSQLI_BOTH);
		return mysqli_fetch_array($r, isset($map[$t]) ? $map[$t] : MYSQLI_BOTH);
	}
	function mysql_fetch_assoc($r)               { return mysqli_fetch_assoc($r); }
	function mysql_fetch_row($r)                 { return mysqli_fetch_row($r); }
	function mysql_fetch_object($r)              { return mysqli_fetch_object($r); }
	function mysql_num_rows($r)                  { return mysqli_num_rows($r); }
	function mysql_num_fields($r)                { return mysqli_num_fields($r); }
	function mysql_data_seek($r, $n)             { return mysqli_data_seek($r, $n); }
	function mysql_free_result($r)               { return mysqli_free_result($r); }
	function mysql_insert_id($l = null)          { return mysqli_insert_id(lancms_mysql_link($l)); }
	function mysql_affected_rows($l = null)      { return mysqli_affected_rows(lancms_mysql_link($l)); }
	function mysql_error($l = null)              { $k = lancms_mysql_link($l); return $k ? mysqli_error($k) : mysqli_connect_error(); }
	function mysql_errno($l = null)              { $k = lancms_mysql_link($l); return $k ? mysqli_errno($k) : mysqli_connect_errno(); }
	function mysql_close($l = null)              { $k = lancms_mysql_link($l); return $k ? @mysqli_close($k) : false; }
	function mysql_real_escape_string($s, $l = null) {
		$k = lancms_mysql_link($l);
		return $k ? mysqli_real_escape_string($k, $s) : addslashes($s);
	}
	function mysql_escape_string($s)             { return mysql_real_escape_string($s); }
	function mysql_result($r, $row = 0, $field = 0) {
		mysqli_data_seek($r, $row);
		$d = mysqli_fetch_array($r, MYSQLI_BOTH);
		return $d ? $d[$field] : false;
	}
}

// ---------------------------------------------------------------------------
// Passwords: bcrypt via password_hash(). Plain-text passwords arrive over the
// form (use HTTPS); lancms_unescape() undoes the input escaping above first.
// ---------------------------------------------------------------------------
if (!function_exists('lancms_unescape')) {
	function lancms_unescape($s) { return get_magic_quotes_gpc() ? stripslashes($s) : $s; }
}
if (!function_exists('lancms_password_hash')) {
	function lancms_password_hash($plain) { return password_hash($plain, PASSWORD_DEFAULT); }
}
if (!function_exists('lancms_password_check')) {
	function lancms_password_check($plain, $hash) {
		return is_string($hash) && $hash !== '' && $hash[0] === '$' && password_verify($plain, $hash);
	}
}
