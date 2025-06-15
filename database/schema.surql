USE NS medvedi_stezka DB medvedi_stezka;

# Users table
DEFINE TABLE IF NOT EXISTS users;
DEFINE FIELD IF NOT EXISTS username ON TABLE users TYPE string;
DEFINE FIELD IF NOT EXISTS password ON TABLE users TYPE string;
DEFINE FIELD IF NOT EXISTS nickname ON TABLE users TYPE string;

# Logins table
DEFINE TABLE IF NOT EXISTS logins;
DEFINE FIELD IF NOT EXISTS user ON TABLE logins TYPE record<users>;
DEFINE FIELD IF NOT EXISTS datetime ON TABLE logins TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD IF NOT EXISTS expires ON TABLE logins TYPE datetime | null;
DEFINE FIELD IF NOT EXISTS token ON TABLE logins TYPE string;
DEFINE FIELD IF NOT EXISTS expired ON TABLE logins VALUE <future> {RETURN IF expires = null { false } ELSE { expires < time::now() }};

# Organizations table
DEFINE TABLE IF NOT EXISTS organizations;
DEFINE FIELD IF NOT EXISTS name ON TABLE organizations TABLE TYPE string;

# Contestants table
DEFINE TABLE IF NOT EXISTS contestants;
DEFINE FIELD IF NOT EXISTS name ON TABLE TABLE contestants TYPE string;
DEFINE FIELD IF NOT EXISTS birthYear ON TABLE TABLE contestants TYPE int;

# Competitions table
DEFINE TABLE IF NOT EXISTS competitions;
DEFINE FIELD IF NOT EXISTS type ON TABLE competitions TYPE "district" | "region TABLE" | "nation TABLE";
DEFINE FIELD IF NOT EXISTS location TABLE ON TABLE competitions TYPE string;
DEFINE FIELD IF NOT EXISTS schoolYear ON TABLE competitions TYPE string; # Format yyyy/yyyy (2025/2026)
DEFINE FIELD IF NOT EXISTS organizations ON TABLE competitions TYPE array<record<organizations>>;
DEFINE FIELD IF NOT EXISTS teams ON TABLE competitions TYPE array<record<teams>>;
DEFINE FIELD IF NOT EXISTS checksDeaf ON TABLE competition  TYPE array<record<checksDeaf>>;
DEFINE FIELD IF NOT EXISTS checksAlive ON TABLE competitions TYPE array<record<checksAlive>>;
DEFINE FIELD IF NOT EXISTS cards ON TABLE competitions TYPE array<record<cards>>;

# Teams table
DEFINE TABLE IF NOT EXISTS teams;
DEFINE FIELD IF NOT EXISTS number ON TABLE teams TYPE int | null; # Team number is unknown until they arrive at the finish line
DEFINE FIELD IF NOT EXISTS organization TABLE teams TYPE record<organizations>;
DEFINE FIELD IF NOT EXISTS category ON TABLE teams TYPE "1F" | "1M" | "2F" | "2M" | "3F" | "3M" | "4F" | "4M" | "5F" | "5M";
DEFINE FIELD IF NOT EXISTS members ON TABLE teams TYPE array<record<contestants>>;

# Deaf checks table
DEFINE TABLE IF NOT EXISTS checksDeaf;
DEFINE FIELD IF NOT EXISTS number ON TABLE checksDeaf TYPE int;
DEFINE FIELD IF NOT EXISTS name ON TABLE checksDeaf TYPE string;
DEFINE FIELD IF NOT EXISTS category ON TABLE checksDeaf TYPE "young" | "old";
DEFINE FIELD IF NOT EXISTS answersCorrect ON TABLE checksDeaf TYPE array<string>;

# Alive checks table
DEFINE TABLE IF NOT EXISTS checksAlive;
DEFINE FIELD IF NOT EXISTS number ON TABLE checksAlive TYPE int;
DEFINE FIELD IF NOT EXISTS name ON TABLE checksAlive TYPE string;
DEFINE FIELD IF NOT EXISTS category ON TABLE checksAlive TYPE "young" | "old";

# Deaf checks submitted answers table
DEFINE TABLE IF NOT EXISTS checksDeafSubmittedAnswers;
DEFINE FIELD IF NOT EXISTS check ON TABLE checksDeafSubmittedAnswers TYPE record<checksDeaf>;
DEFINE FIELD IF NOT EXISTS answers ON TABLE checksDeafSubmittedAnswers TYPE array<string>;

# Alive checks submitted times table
DEFINE TABLE IF NOT EXISTS checksAliveSubmittedTimes;
DEFINE FIELD IF NOT EXISTS check ON TABLE checksAliveSubmittedTimes TYPE record<checksAlive>;
DEFINE FIELD IF NOT EXISTS timePenalty ON TABLE checksAliveSubmittedTimes TYPE int;
DEFINE FIELD IF NOT EXISTS timeWait ON TABLE checksAliveSubmittedTimes TYPE int;

# Cards table
DEFINE TABLE IF NOT EXISTS cards;
DEFINE FIELD IF NOT EXISTS team ON TABLE cards TYPE record<teams>;
DEFINE FIELD IF NOT EXISTS timeStart ON TABLE cards TYPE int;
DEFINE FIELD IF NOT EXISTS timeFinish ON TABLE cards TYPE int;
DEFINE FIELD IF NOT EXISTS checksDeafSubmittedAnswers ON TABLE cards TYPE record<checksDeafSubmittedAnswers>;
DEFINE FIELD IF NOT EXISTS checksAliveSubmittedTimes ON TABLE cards TYPE record<checksAliveSubmittedTimes>;
