# LANCMS (Lantastic)

A LAN-party intranet: news, schedule, tournaments and brackets, seating maps, game servers,
prizes, pizza and food runs, tech support, shoutbox, file and music sharing, and more.

LANCMS is a maintained fork of **ALP (Autonomous LAN Party) 0.98.3**, updated to run on current
PHP and MariaDB/MySQL. The original history is in `CHANGELOG.txt`. Licensed under the GPL (see `LICENSE`).

## Requirements

- PHP 5.6 through 8.4 with `mysqli` (required), `gd` (seating images) and `openssl` (satellite client listener only)
- MySQL 5.5+ or MariaDB
- Apache or nginx, or the PHP built-in server for a quick look

## Install

1. Serve this folder, e.g. `php -S 127.0.0.1:8000 -t .`
2. Open `/install/install.php`, enter the database details and an admin password. The installer:
   - creates the database and loads `install/schema.sql` and `install/seed.sql`
   - sets the password of the `admin` user (also used for the `online/` pre-registration admin)
   - writes `_config.php` and locks itself (`install/DISABLED`)
3. **Delete the `install/` folder.**

Manual install: create a database (`utf8mb4`), import `install/schema.sql` then `install/seed.sql`, and copy
`_config.sample.php` to `_config.php` and edit it. There is no default password: the seeded `admin` account is locked
until you set one:

    php -r "echo password_hash('your-password', PASSWORD_DEFAULT);"
    -- then, in MySQL:
    UPDATE users SET passwd='<hash from above>' WHERE username='admin';
    UPDATE settings SET pw='<same hash>';   -- only if you use online/

Keep `$database['strict_mode'] = -1`: the legacy code inserts `''` into integer columns, which strict mode rejects.

Writable folders: `files/` (user uploads) and `music/mp3s/` (music uploads). Raise `upload_max_filesize`
in `php.ini` if you allow large uploads. Many features (pizza, benchmarks, seating, marathon, ...) show
"not authorized" until enabled under Admin > toggle main features.

## Folder overview

| Path | Purpose |
|---|---|
| `*.php` | public pages; `admin_*.php` and `chng_*.php` are admin / edit pages |
| `include/` | core classes (`cl_*`), database drivers (`genesis_*`), modules, tournament engines, language files |
| `include/_compat.php` | compatibility layer for removed PHP features and request-input escaping (see below) |
| `online/` | optional pre-registration website; shares the main database and `_config.php` |
| `skins/` | themes |
| `install/` | installer and SQL; remove after installing |

## Differences from the original ALP

- Runs on modern PHP: `ereg*`, `each`, `mysql_*`, `session_register`, magic quotes and `create_function`
  are provided by `include/_compat.php`; old-style constructors and `$str{0}` syntax were updated.
- The original `install/` was missing from the source release; the schema is rebuilt from the code
  (see `install/README.md`).
- Security hardening: request input is escaped on entry (the original relied on `magic_quotes_gpc`),
  numeric and ORDER BY inputs are cast or whitelisted, passwords use bcrypt (`password_hash`), login session ids
  come from a CSPRNG and cookies are `HttpOnly`, and debugging and import tools (`phpinfo`, query tester, BigDump) were removed.
  Sensitive files and the upload folders are protected by `.htaccess`.
- Unused third-party code (ProChatRooms, BracketPress, phpFreeChat stubs) was removed.
- Warnings are hidden from output. Set `define('LANCMS_DEBUG', 1);` before `include/_compat.php` loads to log
  them to `error_compat.log`. Failed SQL is always logged there.

## Security notes

This is old software. It is meant for a LAN, not the public internet.

- Do not expose it to the internet without a reverse proxy and HTTPS.
- Change the default admin password; delete `install/`.
- On nginx, `.htaccess` is ignored: deny access to `_config.php`, `*.sql`, `*.log` and disable PHP execution in
  `files/` and `music/mp3s/` yourself.
- SQL is still mostly built by string concatenation (inherited from ALP). The input escaping in
  `include/_compat.php` covers quoted values; new code should use `$dbc->quote()` or prepared statements.
- Passwords are stored with bcrypt (`password_hash`) and sent to the server as typed, so use HTTPS on any network
  you don't fully control. Accounts created by older ALP/LANCMS versions (`crypt(md5())` hashes) are not
  compatible; reset them with Admin > reset password, or re-register.

## Contributing

Issues and pull requests are welcome. Please keep changes PHP 5.6 compatible, and mention in your pull request
if you used any generated code.
