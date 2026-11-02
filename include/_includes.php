<?php
if($userinfo['skin'] AND !$master['skin_override'] AND preg_match('#^skins/[A-Za-z0-9_ .-]+/$#', $userinfo['skin']) AND strpos($userinfo['skin'], '..') === false)
	$master['currentskin'] = $userinfo['skin'];

include_once $master['currentskin'].'_config.inc.php';

include_once 'include/cl_form.php';
include_once 'include/cl_URL_handler.php';

include_once 'include/tournaments/tournament_types.php';
?>