# ALP 0.98.3 reconstructed install files

The original `install/` (install.php, upgrade.php, SQL) is missing. These files
were reconstructed from the PHP code.

- `schema.sql` - `CREATE TABLE` statements (including `tempusers` and `settings` for `online/`) (InnoDB, utf8mb4, every NOT NULL column has a DEFAULT; TEXT columns are NULLable). Each table has a `DROP TABLE IF EXISTS` before it, so it destroys existing data if re-run.
- `seed.sql` - single-row config tables, default admin, module list.

## Install

    mysql -uroot -p -e "CREATE DATABASE lantastic CHARACTER SET utf8mb4"
    mysql -uroot -p lantastic < install/schema.sql
    mysql -uroot -p lantastic < install/seed.sql

Copy `_config.sample.php` to `_config.php` and edit the database settings (or use `install.php`, which writes it).
Keep `strict_mode = -1` (which makes `_functions.php` run `SET sql_mode=''`). Keep it at -1:
the code inserts `''` into integer/auto-increment columns (e.g. `INSERT INTO seating_seats VALUES('',...)`,
`UPDATE users SET room_loc=''`), which fails under strict mode.

## Admin account

There is no default password. `install/install.php` asks for one and stores it as a bcrypt hash (`password_hash`) for
the `admin` user (and for the `online/` admin). `seed.sql` creates `admin` with the locked placeholder `!`; for a manual
install set the hash yourself, see the main README.
