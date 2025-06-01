USE NS medvedi_stezka DB medvedi_stezka;

# Users table
DEFINE TABLE IF NOT EXISTS users;
DEFINE FIELD IF NOT EXISTS username ON users TYPE string;
DEFINE FIELD IF NOT EXISTS password ON users TYPE string;

# Logins table
DEFINE TABLE IF NOT EXISTS logins;
DEFINE FIELD IF NOT EXISTS user ON logins TYPE record<users>;
DEFINE FIELD IF NOT EXISTS datetime ON logins TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD IF NOT EXISTS expires ON logins TYPE datetime | null;
DEFINE FIELD IF NOT EXISTS token ON logins TYPE string;
DEFINE FIELD IF NOT EXISTS expired ON logins VALUE <future> {RETURN IF expires = null { false } ELSE { expires < time::now() }};