<?php chdir(dirname(__DIR__));
require_once 'include/_universal.php';
$x = new universal('change your password','password',1);
$x->display_top();
if ($x->is_secure()) { 
	if (empty($_POST)) { ?>
		<script language="javascript">
		<!-- 
		function doLogin() { 
		document.modify.javascript.value = "yes";
		} 
		// --> 
		</script>
		<b>change password</b>:<br />
		<br />
		<table border=0 cellpadding=4 cellspacing=4 width="400" class="centerd"><tr><td>
		<form action="change/chng_passwd.php" method="POST" name="modify">
		<input type="hidden" name="javascript" value="">
		<font size=1><b>current password</b><br /></font>
		<input type="password" name="current_passwd" maxlength=72 style="width: 99%"><br />
		<br />
		<font size=1><b>new password</b><br /></font>
		<input type="password" name="new_passwd" maxlength=72 style="width: 99%"><br />
		<font size=1><b>new password confirm</b><br /></font>
		<input type="password" name="new_passwd_confirm" maxlength=72 style="width: 99%"><br />
		<br />
		<div align="right"><input type="submit" value="change passwd" onClick="doLogin(); return true;" class="formcolors"></div>
		</form>
		</td></tr></table>
		<?php
	} else { 
		require_once 'include/cl_validation.php';
		$valid = new validate();

		
		if(!empty($userinfo['passwd'])) {
			$holder_passwd = $userinfo['passwd'];
		}

		$valid->is_empty('current_passwd','the current_passwd field is blank.');
		if(empty($holder_passwd) || !lancms_password_check(lancms_unescape($valid->get_value('current_passwd')), $holder_passwd)) {
			$valid->add_error('your password is incorrect.');
		}
	
		$valid->is_empty('new_passwd','the new password field is blank.');
		$valid->is_empty('new_passwd_confirm','the new password confirm field is blank.');
		$valid->is_same($valid->get_value('new_passwd'),$valid->get_value('new_passwd_confirm'),'your new password does not match the new password confirm field.');

		if(!$valid->is_error()) {
			$holder_passwd = lancms_password_hash(lancms_unescape($valid->get_value('new_passwd')));
			if($dbc->database_query ("UPDATE users SET passwd='".$holder_passwd."' WHERE userid='".$_COOKIE["userid"]."'")) {
				echo 'your password has been successfully updated.  don\'t forget it.  it\'s a big hassle to get the admin to reset your password.<br /><br /> &gt; <a href="change/chng_passwd.php">change your password again</a>.<br /><br />';
			} else {
				echo 'there has been an error updating your password with the database.  your password have not been updated.<br />';
			}
		} else {
			$valid->display_errors();
		}
	}
} else {
	echo 'you are not authorized to view this page.<br /><br />';
}
$x->display_bottom();
?>