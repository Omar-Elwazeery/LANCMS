<?php
// Shows a user's balance. Uses the shared DB settings instead of hard-coded credentials.
require_once '_config.php';
require_once 'include/_compat.php';
$link = mysqli_connect($database['server'], $database['user'], $database['passwd'], $database['database']);
if (!$link) { die('Unable to connect to MySQL'); }
$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;
$result = mysqli_query($link, 'SELECT balance FROM users WHERE userid=' . $id);
?>
<BODY TEXT="0097AE">
<FONT FACE="arial">
<?php
if ($result && ($row = mysqli_fetch_assoc($result))) {
	echo '<strong>Balance: </strong>' . htmlspecialchars($row['balance']);
}
mysqli_close($link);
?>
 LC
 </FONT>
</BODY>
