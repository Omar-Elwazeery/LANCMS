<?php
session_start();
chdir('..');
require_once('header.php');
check_auth();
chdir('admin');
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
.style1 {font-size: 24px}
.style2 {font-size: 16px}
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
}
-->
</style>
</head>

<body>
<p class="style1">Autonomous LAN Party Online Administration</p>
<p class="style2">options: user list | <a href="admins.php">add admins</a> | <a href="party.php">party options</a> | <a href="export.php">export users</a> </p>
<p class="style2">Current registered users:<br />
  Currently you cannot change information. This will be added in the next release, along with reusing user signups. Currently, when a LAN is over you have to clear the list and start over. This will change next time around.</p>
<?php
$total   = (int) $dbc->database_result($dbc->database_query("SELECT count(*) FROM tempusers"), 0);
$prepaid = (int) $dbc->database_result($dbc->database_query("SELECT count(*) FROM tempusers WHERE paid = '1'"), 0);
$max     = (int) $settings['lan']['max'];
$avail   = $max > 0 ? max(0, $max - $prepaid) : 'unlimited';
?>
<p class="style2">Total Registered Gamers (reserved and unreserved): <?php echo $total; ?><br />
Total Unconfirmed Seats: <?php echo $total - $prepaid; ?><br />
Total Prepaid Seats (reserved): <?php echo $prepaid; ?> <br />
Seats still available: <?php echo $avail; ?>
</p>
<table width="90%" border="1" align="center" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col"><div align="center">Nickname</div></th>
    <th scope="col"><div align="center">Name</div></th>
    <th scope="col"><div align="center">Seat Status</div></th>
  </tr>
<?php
$q = $dbc->database_query("SELECT username, first_name, last_name, paid FROM tempusers ORDER BY paid DESC, userid ASC");
while ($r = $dbc->database_fetch_assoc($q)) {
	$status = $r['paid'] ? '<font color="#00FF00">RESERVED</font>' : '<font color="#FF0000"><b>UNRESERVED</b></font>';
	echo '<tr><td><div align="center">' . htmlspecialchars($r['username']) . '</div></td><td><div align="center">'
		. htmlspecialchars($r['first_name'] . ' ' . $r['last_name']) . '</div></td><td><div align="center">' . $status . '</div></td></tr>';
}
?>
</table>
</body>
</html>
