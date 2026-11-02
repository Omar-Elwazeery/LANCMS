<?php
// this file not needed if !ALP_TOURNAMENT_MODE_COMPUTER_GAMES
require_once 'include/_universal.php'; 
$x = new universal('files','files',0);
$x->display_smallwindow_top($colors['cell_background'],1); 
if ($dbc->database_num_rows($dbc->database_query("SELECT * FROM games WHERE gameid='".(!empty($_GET['gameid'])?$_GET['gameid']:'')."'")) && !empty($_GET['map'])) { 
	$game = $dbc->database_fetch_assoc($dbc->database_query('SELECT thumbs_dir FROM games WHERE gameid='.(int)$_GET['gameid']));
	$bool = false; $map = str_replace('..', '', preg_replace('/[^A-Za-z0-9_ .-]/', '', stripslashes(urldecode($_GET['map']))));
	if (file_exists('img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.jpg')) {
		$bool = true;
		$url = 'img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.jpg';
	} elseif (file_exists('img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.gif')) {
		$bool = true;
		$url = 'img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.gif';
	} elseif (file_exists('img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.png')) {
		$bool = true;
		$url = 'img/map_thumbnails/'.$game['thumbs_dir'].'/'.$map.'.png';
	}
	if ($bool) { ?><img src="<?php echo $url; ?>" width="218" height="163" border="0" alt="<?php echo htmlspecialchars($map, ENT_QUOTES); ?>" /><?php
	} else { ?>
		<font class="normal" color="<?php echo $colors['blended_text']; ?>">map thumbnail not found.</font>
		<?php
	}
}
$x->display_smallwindow_bottom();
?>