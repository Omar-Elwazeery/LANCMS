<?php
session_start();
chdir('..');
require_once("header.php");
chdir('admin');
if(!empty($_SESSION['online_admin']))
			die(header("Location:index.php"));
			


if($_POST['go']) {
	$row = $dbc->database_fetch_assoc($dbc->database_query("SELECT pw FROM `settings` LIMIT 1"));
	if($row && lancms_password_check(lancms_unescape($_POST['pw']), $row['pw'])) {
		session_regenerate_id(true);
		$_SESSION['online_admin'] = 1;
		echo "Logged in! <a href='./index.php'>Go back</a>";
	}
	else {
		echo "Invalid Password";
	}
}

echo " <br /><form method='post'> Password: <input type=password name=pw>
	<input type=hidden name=go value=go>
	<input type=submit name=submit value=Submit>";
	ob_end_flush();
?>
