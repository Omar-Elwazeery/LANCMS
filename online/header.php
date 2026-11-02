<?php
if (session_status() !== PHP_SESSION_ACTIVE) { session_start(); }
require_once('functions.php');

$settings = get_settings();
extract($settings);
?>