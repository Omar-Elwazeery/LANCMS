-- ---------------------------------------------------------------------------
-- ALP 0.98.3 -- seed data (run AFTER install/schema.sql)
-- Default administrator:  username  admin   password  admin   (CHANGE IT!)
-- ---------------------------------------------------------------------------

-- master: one row. currentskin is a PATH PREFIX (code does $master['currentskin'].'_config.inc.php')
INSERT INTO `master` (`internetmode`,`currentlanguage`,`currentskin`,`skin_override`,`dateformat`,`alpver`,
  `techsupport_index_limit`,`shoutbox_index_limit`,`shoutbox_inbox_limit`,`sponsors_index_limit`,`music_min_time`,`music_max_queue`)
VALUES (0,'en','skins/default_grey/',0,'h:i a - D d M Y','0.98.3',5,5,5,5,0,0);

-- toggle: one row. Everything off except the basics.
INSERT INTO `toggle` (`schedule`,`messaging`,`shoutbox`,`techsupport`,`gamerequests`,`servers`)
VALUES (1,1,1,1,1,1);

-- config: one row (event info).  alp_tournament_mode=0 -> full LAN-party mode.
INSERT INTO `config` (`name`,`org`,`location`,`address`,`country`,`max`,`datetimestart`,`datetimeend`,
  `email`,`admin`,`websiteurl`,`alp_tournament_mode`,`alp_tournament_mode_computer_games`)
VALUES ('My LAN Party','My LAN Group','Local','','outside us',100,NOW(),DATE_ADD(NOW(), INTERVAL 2 DAY),
  'admin@localhost','admin','',0,1);

-- prizes_control: code UPDATEs / SELECTs this single row, it must exist
INSERT INTO `prizes_control` (`lock_prizes`,`draw_mode`) VALUES (0,0);

-- default admin (priv_level 3 = super administrator).
-- passwd '!' is an unusable placeholder: install/install.php (or the SQL step in README.md) sets the real bcrypt hash.
INSERT INTO `users` (`username`,`first_name`,`last_name`,`passwd`,`email`,`priv_level`,`recent_ip`,`date_of_arrival`)
VALUES ('admin','Admin','Administrator','!','admin@localhost',3,'127.0.0.1',NOW());

-- modules: index-page side modules. ordernum 0 = disabled, >0 = enabled in that order.
-- `required` = name of a toggle column that must be on for the module to show (NULL = always).
INSERT INTO `modules` (`file`,`description`,`ordernum`,`required`) VALUES
 ('mod_importantinfo.php','important info',1,NULL),
 ('mod_messages.php','messages',2,'messaging'),
 ('mod_shoutbox.php','shoutbox',3,'shoutbox'),
 ('mod_techsupport.php','tech support',4,'techsupport'),
 ('mod_credits.php','credits',5,NULL),
 ('mod_attendance.php','attendance',0,NULL),
 ('mod_files.php','files',0,'files'),
 ('mod_gamerofthehour.php','gamer of the hour',0,'gamerofthehour'),
 ('mod_gamingrig.php','gaming rigs',0,'gamingrigs'),
 ('mod_music.php','music',0,'music'),
 ('mod_sponsors.php','sponsors',0,'sponsors'),
 ('mod_timeremaining.php','time remaining',0,'timeremaining'),
 ('mod_voice.php','voice server',0,NULL);

-- online/ pre-registration admin; same placeholder, replaced by the installer
INSERT INTO `settings` (`pw`,`group`,`event`,`admin_email`,`paypal_account`)
VALUES ('!','','LAN Party','','');
