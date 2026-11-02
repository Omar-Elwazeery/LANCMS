-- ---------------------------------------------------------------------------
-- ALP (Autonomous LAN Party) 0.98.3 -- reconstructed database schema
-- Reconstructed from the PHP code (original install/ folder is missing).
-- Target: MySQL 5.5+ / 8.x and MariaDB.  InnoDB, utf8mb4, no TYPE=, no
-- strict-mode-dependent defaults (every NOT NULL column has a DEFAULT; long
-- TEXT columns are NULLable because TEXT cannot carry a literal default).
--
-- Usage:
--   mysql -uroot -p -e "CREATE DATABASE lantastic CHARACTER SET utf8mb4"
--   mysql -uroot -p lantastic < install/schema.sql
--   mysql -uroot -p lantastic < install/seed.sql
-- ---------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ===== single-row configuration tables ===================================

DROP TABLE IF EXISTS `master`;
CREATE TABLE `master` (
  `internetmode` TINYINT(1) NOT NULL DEFAULT 0,
  `currentlanguage` VARCHAR(10) NOT NULL DEFAULT 'en',
  `currentskin` VARCHAR(255) NOT NULL DEFAULT 'skins/default_grey/',
  `skin_override` TINYINT(1) NOT NULL DEFAULT 0,
  `dateformat` VARCHAR(45) NOT NULL DEFAULT 'h:i a - D d M Y',
  `alpver` VARCHAR(20) NOT NULL DEFAULT '0.98.3',
  `ip_register_lock` TINYINT(1) NOT NULL DEFAULT 0,
  `useskinforcaffeine` TINYINT(1) NOT NULL DEFAULT 0,
  `authbyiponly` TINYINT(1) NOT NULL DEFAULT 0,
  `doublecheckpassword` TINYINT(1) NOT NULL DEFAULT 0,
  `loginselect` TINYINT(1) NOT NULL DEFAULT 0,
  `proficiencylock` TINYINT(1) NOT NULL DEFAULT 0,
  `alldates` TINYINT(1) NOT NULL DEFAULT 0,
  `pollsguest` TINYINT(1) NOT NULL DEFAULT 0,
  `caching` TINYINT(1) NOT NULL DEFAULT 0,
  `max_file_upload_size` BIGINT NOT NULL DEFAULT 0,
  `policyurl` VARCHAR(255) NOT NULL DEFAULT '',
  `files_redirect` VARCHAR(255) NOT NULL DEFAULT '',
  `techsupport_index_limit` INT NOT NULL DEFAULT 5,
  `shoutbox_index_limit` INT NOT NULL DEFAULT 5,
  `shoutbox_inbox_limit` INT NOT NULL DEFAULT 5,
  `gamerhour` VARCHAR(255) NOT NULL DEFAULT '',
  `important_info` TEXT NULL,
  `pizza_orders_lock` TINYINT(1) NOT NULL DEFAULT 0,
  `staff_photo_url` VARCHAR(200) NOT NULL DEFAULT '',
  `staff_photo_width` VARCHAR(200) NOT NULL DEFAULT '',
  `sponsors_index_limit` INT NOT NULL DEFAULT 5,
  `sponsors_width` INT NOT NULL DEFAULT 0,
  `sponsors_banner_width` INT NOT NULL DEFAULT 0,
  `sponsors_border` TINYINT(1) NOT NULL DEFAULT 0,
  `music_files` VARCHAR(255) NOT NULL DEFAULT '',
  `music_min_time` INT NOT NULL DEFAULT 0,
  `music_max_queue` INT NOT NULL DEFAULT 0,
  `music_stream_id` VARCHAR(20) NOT NULL DEFAULT '',
  `voice_mode` VARCHAR(10) NOT NULL DEFAULT 'ts',
  `voice_name` VARCHAR(45) NOT NULL DEFAULT '',
  `voice_ip` VARCHAR(45) NOT NULL DEFAULT '',
  `voice_pass` VARCHAR(20) NOT NULL DEFAULT '',
  `ts_name` VARCHAR(45) NOT NULL DEFAULT '',
  `ts_pass` VARCHAR(45) NOT NULL DEFAULT '',
  `benchmarkleader` INT NOT NULL DEFAULT 0,
  `marathonleader` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `toggle`;
CREATE TABLE `toggle` (
  `satellite` TINYINT(1) NOT NULL DEFAULT 0,
  `benchmarks` TINYINT(1) NOT NULL DEFAULT 0,
  `caffeine` TINYINT(1) NOT NULL DEFAULT 0,
  `hlsw` TINYINT(1) NOT NULL DEFAULT 0,
  `uploading` TINYINT(1) NOT NULL DEFAULT 0,
  `files` TINYINT(1) NOT NULL DEFAULT 0,
  `foodrun` TINYINT(1) NOT NULL DEFAULT 0,
  `pizza` TINYINT(1) NOT NULL DEFAULT 0,
  `gamerequests` TINYINT(1) NOT NULL DEFAULT 0,
  `servers` TINYINT(1) NOT NULL DEFAULT 0,
  `marath` TINYINT(1) NOT NULL DEFAULT 0,
  `music` TINYINT(1) NOT NULL DEFAULT 0,
  `prizes` TINYINT(1) NOT NULL DEFAULT 0,
  `schedule` TINYINT(1) NOT NULL DEFAULT 0,
  `seating` TINYINT(1) NOT NULL DEFAULT 0,
  `shoutbox` TINYINT(1) NOT NULL DEFAULT 0,
  `messaging` TINYINT(1) NOT NULL DEFAULT 0,
  `currentattendance` TINYINT(1) NOT NULL DEFAULT 0,
  `filesharing` TINYINT(1) NOT NULL DEFAULT 0,
  `gamerofthehour` TINYINT(1) NOT NULL DEFAULT 0,
  `gamingrigs` TINYINT(1) NOT NULL DEFAULT 0,
  `policy` TINYINT(1) NOT NULL DEFAULT 0,
  `techsupport` TINYINT(1) NOT NULL DEFAULT 0,
  `timeremaining` TINYINT(1) NOT NULL DEFAULT 0,
  `staff` TINYINT(1) NOT NULL DEFAULT 0,
  `sponsors` TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `name` VARCHAR(100) NOT NULL DEFAULT '',
  `org` VARCHAR(100) NOT NULL DEFAULT '',
  `location` VARCHAR(50) NOT NULL DEFAULT '',
  `address` VARCHAR(255) NOT NULL DEFAULT '',
  `country` VARCHAR(20) NOT NULL DEFAULT 'us',
  `max` INT NOT NULL DEFAULT 0,
  `datetimestart` DATETIME NULL DEFAULT NULL,
  `datetimeend` DATETIME NULL DEFAULT NULL,
  `email` VARCHAR(60) NOT NULL DEFAULT '',
  `admin` VARCHAR(100) NOT NULL DEFAULT '',
  `websiteurl` VARCHAR(100) NOT NULL DEFAULT '',
  `alp_tournament_mode` TINYINT(1) NOT NULL DEFAULT 0,
  `alp_tournament_mode_computer_games` TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== modules (index page side modules) =================================

DROP TABLE IF EXISTS `modules`;
CREATE TABLE `modules` (
  `moduleid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `file` VARCHAR(45) NOT NULL DEFAULT '',
  `description` VARCHAR(45) NOT NULL DEFAULT '',
  `ordernum` INT UNSIGNED NOT NULL DEFAULT 0,
  `required` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`moduleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== users ==============================================================

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `userid` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(40) NOT NULL DEFAULT '',
  `first_name` VARCHAR(30) NOT NULL DEFAULT '',
  `last_name` VARCHAR(30) NOT NULL DEFAULT '',
  `passwd` VARCHAR(255) NOT NULL DEFAULT '',
  `paid` TINYINT(1) NOT NULL DEFAULT 0,
  `balance` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `email` VARCHAR(60) NOT NULL DEFAULT '',
  `language` VARCHAR(10) NOT NULL DEFAULT '',
  `skin` VARCHAR(45) NOT NULL DEFAULT '',
  `dateformat` VARCHAR(45) NOT NULL DEFAULT '',
  `display_email` TINYINT(1) NOT NULL DEFAULT 0,
  `gender` VARCHAR(10) NOT NULL DEFAULT '',
  `gaming_group` VARCHAR(20) NOT NULL DEFAULT '',
  `quote` VARCHAR(255) NULL DEFAULT NULL,
  `room_loc` INT NOT NULL DEFAULT 0,
  `caffeine_mg` DOUBLE NOT NULL DEFAULT 0,
  `proficiency` INT NOT NULL DEFAULT 0,
  `recent_ip` VARCHAR(15) NOT NULL DEFAULT '',
  `display_ip` TINYINT(1) NOT NULL DEFAULT 0,
  `priv_level` INT NOT NULL DEFAULT 1,
  `sesid` VARCHAR(34) NULL DEFAULT NULL,
  `date_of_arrival` DATETIME NULL DEFAULT NULL,
  `date_of_departure` DATETIME NULL DEFAULT NULL,
  `sharename` VARCHAR(35) NULL DEFAULT NULL,
  `ftp_server` TINYINT(1) NOT NULL DEFAULT 0,
  `comp_proc` VARCHAR(60) NULL DEFAULT NULL,
  `comp_proc_spd` VARCHAR(60) NULL DEFAULT NULL,
  `comp_proc_type` VARCHAR(60) NULL DEFAULT NULL,
  `comp_mem` VARCHAR(60) NULL DEFAULT NULL,
  `comp_mem_type` VARCHAR(60) NULL DEFAULT NULL,
  `comp_hdstorage` VARCHAR(60) NULL DEFAULT NULL,
  `comp_gfx_gpu` VARCHAR(60) NULL DEFAULT NULL,
  `comp_gfx_type` VARCHAR(60) NULL DEFAULT NULL,
  `ccode` VARCHAR(34) NULL DEFAULT NULL,
  `marathon_points` INT NOT NULL DEFAULT 0,
  `marathon_points_tourney` INT NOT NULL DEFAULT 0,
  `marathon_rank` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`userid`),
  KEY `username` (`username`),
  KEY `room_loc` (`room_loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `users_benchmarks`;
CREATE TABLE `users_benchmarks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `benchid` INT NOT NULL DEFAULT 0,
  `value` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  KEY `benchid` (`benchid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `users_pizza`;
CREATE TABLE `users_pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pizzaid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `quantity` INT NOT NULL DEFAULT 0,
  `delivered` TINYINT(1) NOT NULL DEFAULT 0,
  `paid` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `users_staff`;
CREATE TABLE `users_staff` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `staffid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `data` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userid_staffid` (`userid`,`staffid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== site content ======================================================

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `headline` VARCHAR(255) NOT NULL DEFAULT '',
  `userid` BIGINT NOT NULL DEFAULT 0,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `news_article` TEXT NULL,
  `hide_item` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `shoutbox`;
CREATE TABLE `shoutbox` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `post` TEXT NULL,
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `messageid` INT NOT NULL AUTO_INCREMENT,
  `to_userid` BIGINT NOT NULL DEFAULT 0,
  `from_userid` BIGINT NOT NULL DEFAULT 0,
  `subject` VARCHAR(255) NOT NULL DEFAULT '',
  `data` TEXT NULL,
  `read` ENUM('n','y') NOT NULL DEFAULT 'n',
  `time_stamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` ENUM('n','y') NOT NULL DEFAULT 'n',
  PRIMARY KEY (`messageid`),
  KEY `to_userid` (`to_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `itemtime_priv` INT NOT NULL DEFAULT 0,
  `headline` VARCHAR(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `sponsors`;
CREATE TABLE `sponsors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sponsor` VARCHAR(50) NOT NULL DEFAULT '',
  `sponsor_url` VARCHAR(100) NOT NULL DEFAULT '',
  `img_sidebar_url` VARCHAR(100) NOT NULL DEFAULT '',
  `img_banner_url` VARCHAR(100) NOT NULL DEFAULT '',
  `img_alt` VARCHAR(100) NOT NULL DEFAULT '',
  `caption` VARCHAR(100) NOT NULL DEFAULT '',
  `description` TEXT NULL,
  `priority` INT NOT NULL DEFAULT 0,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
  `staffid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL DEFAULT '',
  `priority` INT NOT NULL DEFAULT 0,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`staffid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `lodging`;
CREATE TABLE `lodging` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `address` VARCHAR(255) NOT NULL DEFAULT '',
  `phone` VARCHAR(20) NOT NULL DEFAULT '',
  `costpernight` VARCHAR(100) NOT NULL DEFAULT '',
  `traveltime` VARCHAR(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `foodplaces`;
CREATE TABLE `foodplaces` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `address` VARCHAR(255) NOT NULL DEFAULT '',
  `city` VARCHAR(100) NOT NULL DEFAULT '',
  `state` VARCHAR(2) NOT NULL DEFAULT '',
  `zipcode` VARCHAR(12) NOT NULL DEFAULT '',
  `phone` VARCHAR(20) NOT NULL DEFAULT '',
  `traveltime` VARCHAR(100) NOT NULL DEFAULT '',
  `delivery` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `foodrun`;
CREATE TABLE `foodrun` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `headline` VARCHAR(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `pizza`;
CREATE TABLE `pizza` (
  `pizzaid` INT NOT NULL AUTO_INCREMENT,
  `pizza` VARCHAR(150) NOT NULL DEFAULT '',
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `price` DOUBLE NOT NULL DEFAULT 0,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`pizzaid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `techsupport`;
CREATE TABLE `techsupport` (
  `itemid` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `severity` INT NOT NULL DEFAULT 1,
  `info` TEXT NULL,
  `fixed` TINYINT(1) NOT NULL DEFAULT 0,
  `fixer` BIGINT NOT NULL DEFAULT 0,
  `result` TEXT NULL,
  `assigned_to` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== games / servers / game requests ===================================

DROP TABLE IF EXISTS `games`;
CREATE TABLE `games` (
  `gameid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `current_version` VARCHAR(40) NOT NULL DEFAULT '',
  `url_update` VARCHAR(255) NOT NULL DEFAULT '',
  `url_maps` VARCHAR(255) NOT NULL DEFAULT '',
  `thumbs_dir` VARCHAR(255) NOT NULL DEFAULT '',
  `short` VARCHAR(50) NOT NULL DEFAULT '',
  `querystr2` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `servers`;
CREATE TABLE `servers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `gameid` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(100) NOT NULL DEFAULT '',
  `ipaddress` VARCHAR(255) NOT NULL DEFAULT '',
  `queryport` VARCHAR(10) NOT NULL DEFAULT '',
  `tourneyid` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `game_requests`;
CREATE TABLE `game_requests` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `gameid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `gamename` VARCHAR(255) NOT NULL DEFAULT '',
  `ipaddress` VARCHAR(255) NOT NULL DEFAULT '',
  `queryport` VARCHAR(10) NOT NULL DEFAULT '',
  `itemtime` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== music =============================================================

DROP TABLE IF EXISTS `music`;
CREATE TABLE `music` (
  `musicid` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL DEFAULT '',
  `artist` VARCHAR(255) NOT NULL DEFAULT '',
  `genre` VARCHAR(255) NOT NULL DEFAULT '',
  `path` VARCHAR(255) NOT NULL DEFAULT '',
  `plays` INT NOT NULL DEFAULT 0,
  `votes` INT NOT NULL DEFAULT 0,
  `playingid` INT NOT NULL DEFAULT 0,
  `nowplaying` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`musicid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `music_votes`;
CREATE TABLE `music_votes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playingid` INT NOT NULL DEFAULT 0,
  `musicid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `subtime` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `playingid` (`playingid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== caffeine / benchmarks =============================================

DROP TABLE IF EXISTS `caffeine_types`;
CREATE TABLE `caffeine_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `caffeine_items`;
CREATE TABLE `caffeine_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `caffeine_permg` DOUBLE NOT NULL DEFAULT 0,
  `ttype` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `caffeine`;
CREATE TABLE `caffeine` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `caffeine_date` DATETIME NULL DEFAULT NULL,
  `caffeine_id` INT NOT NULL DEFAULT 0,
  `caffeine_oz` DOUBLE NOT NULL DEFAULT 0,
  `caffeine_mult` DOUBLE NOT NULL DEFAULT 0,
  `caffeine_qty` INT NOT NULL DEFAULT 0,
  `caffeine_total` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `benchmarks`;
CREATE TABLE `benchmarks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `abbreviation` VARCHAR(100) NOT NULL DEFAULT '',
  `composite` TINYINT(1) NOT NULL DEFAULT 0,
  `deflate` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== polls =============================================================

DROP TABLE IF EXISTS `poll`;
CREATE TABLE `poll` (
  `pollid` INT NOT NULL AUTO_INCREMENT,
  `headline` VARCHAR(255) NOT NULL DEFAULT '',
  `activepoll` TINYINT(1) NOT NULL DEFAULT 0,
  `choice1` VARCHAR(255) NULL DEFAULT NULL,
  `choice2` VARCHAR(255) NULL DEFAULT NULL,
  `choice3` VARCHAR(255) NULL DEFAULT NULL,
  `choice4` VARCHAR(255) NULL DEFAULT NULL,
  `choice5` VARCHAR(255) NULL DEFAULT NULL,
  `choice6` VARCHAR(255) NULL DEFAULT NULL,
  `choice7` VARCHAR(255) NULL DEFAULT NULL,
  `choice8` VARCHAR(255) NULL DEFAULT NULL,
  `choice9` VARCHAR(255) NULL DEFAULT NULL,
  `choice10` VARCHAR(255) NULL DEFAULT NULL,
  `choice11` VARCHAR(255) NULL DEFAULT NULL,
  `choice12` VARCHAR(255) NULL DEFAULT NULL,
  `choice13` VARCHAR(255) NULL DEFAULT NULL,
  `choice14` VARCHAR(255) NULL DEFAULT NULL,
  `choice15` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`pollid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `poll_votes`;
CREATE TABLE `poll_votes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pollid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `choiceid` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `pollid` (`pollid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `poll_maps`;
CREATE TABLE `poll_maps` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `filename` VARCHAR(255) NOT NULL DEFAULT '',
  `filedesc` TEXT NULL,
  `selected` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `poll_votes_maps`;
CREATE TABLE `poll_votes_maps` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `mapid` INT NOT NULL DEFAULT 0,
  `vote` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== prizes ============================================================

DROP TABLE IF EXISTS `prizes`;
CREATE TABLE `prizes` (
  `prizeid` INT NOT NULL AUTO_INCREMENT,
  `prizename` VARCHAR(255) NOT NULL DEFAULT '',
  `prizequantity` INT NOT NULL DEFAULT 1,
  `prizevalue` DOUBLE NOT NULL DEFAULT 0,
  `prizepicture` VARCHAR(255) NOT NULL DEFAULT '',
  `prizegroup` INT NOT NULL DEFAULT 0,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `tourneyplace` INT NOT NULL DEFAULT 0,
  `tourneyclaim` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`prizeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- NOTE: column ORDER matters; the code does positional INSERT ... VALUES('',...)
DROP TABLE IF EXISTS `prizes_winners`;
CREATE TABLE `prizes_winners` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prizeid` INT NOT NULL DEFAULT 0,
  `prizegroup` INT NOT NULL DEFAULT 0,
  `winnerid` BIGINT NOT NULL DEFAULT 0,
  `group_order` INT NOT NULL DEFAULT 0,
  `claimed` TINYINT(1) NOT NULL DEFAULT 0,
  `ignoreit` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `prizeid` (`prizeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `prizes_unwinners`;
CREATE TABLE `prizes_unwinners` (
  `userid` BIGINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `prizes_votes`;
CREATE TABLE `prizes_votes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `prizeid` INT NOT NULL DEFAULT 0,
  `getall` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `prizes_control`;
CREATE TABLE `prizes_control` (
  `lock_prizes` TINYINT(1) NOT NULL DEFAULT 0,
  `draw_mode` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `prizes_display_groups`;
CREATE TABLE `prizes_display_groups` (
  `prizegroup` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== seating (positional INSERTs: keep column order) ===================

DROP TABLE IF EXISTS `seating_control`;
CREATE TABLE `seating_control` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pixelcorr` INT NOT NULL DEFAULT 15,
  `distancecorr` DOUBLE NOT NULL DEFAULT 3,
  `distancetype` VARCHAR(10) NOT NULL DEFAULT 'feet',
  `room_width` INT NOT NULL DEFAULT 0,
  `room_height` INT NOT NULL DEFAULT 0,
  `dev_mode` TINYINT(1) NOT NULL DEFAULT 0,
  `grid` TINYINT(1) NOT NULL DEFAULT 1,
  `dev_javascript` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `seating_seats`;
CREATE TABLE `seating_seats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `x` INT NOT NULL DEFAULT 0,
  `y` INT NOT NULL DEFAULT 0,
  `shape` VARCHAR(10) NOT NULL DEFAULT 'rect',
  `direction` VARCHAR(5) NOT NULL DEFAULT '',
  `sittable` TINYINT(1) NOT NULL DEFAULT 0,
  `reservedID` INT NOT NULL DEFAULT 0,
  `groupnum` INT NOT NULL DEFAULT 0,
  `dev_selected` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `xy` (`x`,`y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== satellite (ALP satellite game-server manager; disabled in UI) =====
-- satellite_clients is inserted positionally with 13 values.

DROP TABLE IF EXISTS `satellite_clients`;
CREATE TABLE `satellite_clients` (
  `ip` VARCHAR(45) NOT NULL DEFAULT '',
  `game` VARCHAR(50) NOT NULL DEFAULT '',
  `cert` TEXT NULL,
  `passwd` VARCHAR(255) NOT NULL DEFAULT '',
  `installed` VARCHAR(10) NOT NULL DEFAULT 'FALSE',
  `cpu` VARCHAR(100) NOT NULL DEFAULT '',
  `mhz` INT NOT NULL DEFAULT 0,
  `ram` INT NOT NULL DEFAULT 0,
  `servers` INT NOT NULL DEFAULT 1,
  `running1` TINYINT(1) NOT NULL DEFAULT 0,
  `running2` TINYINT(1) NOT NULL DEFAULT 0,
  `running3` TINYINT(1) NOT NULL DEFAULT 0,
  `running4` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `satellite_config`;
CREATE TABLE `satellite_config` (
  `path` VARCHAR(255) NOT NULL DEFAULT '',
  `game` VARCHAR(50) NOT NULL DEFAULT '',
  `name` VARCHAR(100) NOT NULL DEFAULT '',
  KEY `game` (`game`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `satellite_config_files`;
CREATE TABLE `satellite_config_files` (
  `path` VARCHAR(255) NOT NULL DEFAULT '',
  `game` VARCHAR(50) NOT NULL DEFAULT '',
  `filename` VARCHAR(255) NOT NULL DEFAULT '',
  KEY `game` (`game`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `satellite_config_inuse`;
CREATE TABLE `satellite_config_inuse` (
  `ip` VARCHAR(45) NULL DEFAULT NULL,
  `filename` VARCHAR(255) NULL DEFAULT NULL,
  `path` VARCHAR(255) NOT NULL DEFAULT '',
  `server` INT NULL DEFAULT NULL,
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== tournaments =======================================================

DROP TABLE IF EXISTS `tournaments`;
CREATE TABLE `tournaments` (
  `tourneyid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `tentative` TINYINT(1) NOT NULL DEFAULT 0,
  `gameid` INT NOT NULL DEFAULT 0,
  `ttype` INT NOT NULL DEFAULT 1,
  `moderatorid` BIGINT NOT NULL DEFAULT 0,
  `random` TINYINT(1) NOT NULL DEFAULT 0,
  `per_team` INT NOT NULL DEFAULT 1,
  `max_teams` INT NOT NULL DEFAULT 0,
  `itemtime` DATETIME NULL DEFAULT NULL,
  `url_stats` VARCHAR(255) NOT NULL DEFAULT '',
  `marathon` TINYINT(1) NOT NULL DEFAULT 0,
  `lockjoin` TINYINT(1) NOT NULL DEFAULT 0,
  `lockteams` TINYINT(1) NOT NULL DEFAULT 0,
  `lockstart` TINYINT(1) NOT NULL DEFAULT 0,
  `lockfinish` TINYINT(1) NOT NULL DEFAULT 0,
  `ffa` TINYINT(1) NOT NULL DEFAULT 0,
  `teamcolors` INT NOT NULL DEFAULT 0,
  `notes` TEXT NULL,
  `settings` TEXT NULL,
  PRIMARY KEY (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_teams_type`;
CREATE TABLE `tournament_teams_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `gameid` INT NOT NULL DEFAULT 0,
  `onename` VARCHAR(100) NOT NULL DEFAULT '',
  `onecolor` VARCHAR(10) NOT NULL DEFAULT '',
  `twoname` VARCHAR(100) NOT NULL DEFAULT '',
  `twocolor` VARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_teams`;
CREATE TABLE `tournament_teams` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `captainid` BIGINT NOT NULL DEFAULT 0,
  `sig` VARCHAR(255) NOT NULL DEFAULT '',
  `sigplace` INT NOT NULL DEFAULT 0,
  `ranking` INT NOT NULL DEFAULT 0,
  `in_ladder` TINYINT(1) NOT NULL DEFAULT 0,
  `ladder_ranking` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_players`;
CREATE TABLE `tournament_players` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `teamid` INT NOT NULL DEFAULT 0,
  `ranking` INT NOT NULL DEFAULT 0,
  `in_ladder` TINYINT(1) NOT NULL DEFAULT 0,
  `ladder_ranking` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_matches`;
CREATE TABLE `tournament_matches` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `rnd` INT NOT NULL DEFAULT 0,
  `mtc` INT NOT NULL DEFAULT 0,
  `server` INT NOT NULL DEFAULT 0,
  `bracket` VARCHAR(1) NOT NULL DEFAULT 'w',
  `map` VARCHAR(255) NULL DEFAULT NULL,
  `top_x_advance` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_matches_teams`;
CREATE TABLE `tournament_matches_teams` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `matchid` INT NOT NULL DEFAULT 0,
  `team` BIGINT NOT NULL DEFAULT 0,
  `top` TINYINT(1) NOT NULL DEFAULT 0,
  `score` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tourneyid` (`tourneyid`),
  KEY `matchid` (`matchid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tournament_matches_score_votes`;
CREATE TABLE `tournament_matches_score_votes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tourneyid` INT NOT NULL DEFAULT 0,
  `matchid` INT NOT NULL DEFAULT 0,
  `userid` BIGINT NOT NULL DEFAULT 0,
  `entry_id` INT NOT NULL DEFAULT 0,
  `entry_val` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `matchid` (`matchid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------------
-- pid: process-id registry used by the satellite listener (clientlisten.php /
-- admin_satellite.php): INSERT INTO pid VALUES('clientlisten', <pid>)
-- (added after the first schema pass missed it)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pid` (
  `name` VARCHAR(50) NOT NULL DEFAULT '',
  `pid`  INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- online/ (pre-registration site) tables
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `tempusers`;
CREATE TABLE `tempusers` (
  `userid` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(40) NOT NULL DEFAULT '',
  `first_name` VARCHAR(30) NOT NULL DEFAULT '',
  `last_name` VARCHAR(30) NOT NULL DEFAULT '',
  `passwd` VARCHAR(255) NOT NULL DEFAULT '',
  `paid` TINYINT(1) NOT NULL DEFAULT 0,
  `email` VARCHAR(60) NOT NULL DEFAULT '',
  `language` VARCHAR(10) NOT NULL DEFAULT '',
  `skin` VARCHAR(45) NOT NULL DEFAULT '',
  `dateformat` VARCHAR(45) NOT NULL DEFAULT '',
  `display_email` TINYINT(1) NOT NULL DEFAULT 0,
  `gender` VARCHAR(10) NOT NULL DEFAULT '',
  `gaming_group` VARCHAR(20) NOT NULL DEFAULT '',
  `quote` VARCHAR(255) NULL,
  `room_loc` INT NOT NULL DEFAULT 0,
  `caffeine_mg` DOUBLE(10,2) NOT NULL DEFAULT 0,
  `proficiency` INT NOT NULL DEFAULT 0,
  `recent_ip` VARCHAR(15) NOT NULL DEFAULT '',
  `display_ip` TINYINT(1) NOT NULL DEFAULT 0,
  `priv_level` INT NOT NULL DEFAULT 0,
  `sesid` VARCHAR(34) NULL,
  `date_of_arrival` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `date_of_departure` DATETIME NULL,
  `sharename` VARCHAR(35) NULL,
  `ftp_server` TINYINT(1) NOT NULL DEFAULT 0,
  `comp_proc` VARCHAR(60) NULL,
  `comp_proc_spd` VARCHAR(60) NULL,
  `comp_proc_type` VARCHAR(60) NULL,
  `comp_mem` VARCHAR(60) NULL,
  `comp_mem_type` VARCHAR(60) NULL,
  `comp_hdstorage` VARCHAR(60) NULL,
  `comp_gfx_gpu` VARCHAR(60) NULL,
  `comp_gfx_type` VARCHAR(60) NULL,
  `ccode` VARCHAR(34) NULL,
  `marathon_points` INT NOT NULL DEFAULT 0,
  `marathon_points_tourney` INT NOT NULL DEFAULT 0,
  `marathon_rank` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `pw` TEXT NOT NULL,
  `group` TEXT NOT NULL,
  `event` TEXT NOT NULL,
  `start_date` VARCHAR(10) NOT NULL DEFAULT '0000-00-00',
  `end_date` VARCHAR(10) NOT NULL DEFAULT '0000-00-00',
  `start_time` TIME NOT NULL DEFAULT '00:00:00',
  `end_time` TIME NOT NULL DEFAULT '00:00:00',
  `admin_email` TEXT NOT NULL,
  `send_mail` TINYINT(1) NOT NULL DEFAULT 0,
  `max_attendance` SMALLINT NOT NULL DEFAULT 0,
  `paypal_account` TEXT NOT NULL,
  `attendance_price_door` DECIMAL(10,0) NOT NULL DEFAULT 0,
  `attendance_price_online` DECIMAL(10,0) NOT NULL DEFAULT 0,
  `prepay_toggle` TINYINT(1) NOT NULL DEFAULT 0,
  `bleh` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
