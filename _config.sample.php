<?php
// Copy to _config.php (or just run /install/install.php, which writes it for you).

// Database server connection settings
$database['type']     = 'mysqli';   // 'mysqli' (recommended). 'mysql' is auto-upgraded to mysqli on PHP 7+.
$database['user']     = 'root';
$database['passwd']   = '';
$database['database'] = 'lantastic';
$database['server']   = 'localhost';

// Do not change strict_mode unless you know what you are doing (-1 = off, 1 = TRADITIONAL)
$database['strict_mode']   = -1;
?>
