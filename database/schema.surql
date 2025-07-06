USE NS medvedi_stezka DB medvedi_stezka;

# Users table
DEFINE TABLE IF NOT EXISTS users;
DEFINE FIELD OVERWRITE username ON TABLE users TYPE string;
DEFINE FIELD OVERWRITE password ON TABLE users TYPE string;
DEFINE FIELD OVERWRITE nickname ON TABLE users TYPE string;

# Logins table
DEFINE TABLE IF NOT EXISTS logins;
DEFINE FIELD OVERWRITE user ON TABLE logins TYPE record<users>;
DEFINE FIELD OVERWRITE datetime ON TABLE logins TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE expires ON TABLE logins TYPE datetime | null;
DEFINE FIELD OVERWRITE token ON TABLE logins TYPE string;
DEFINE FIELD OVERWRITE expired ON TABLE logins VALUE <future> {RETURN IF expires = null { false } ELSE { expires < time::now() }};

# Organizations table
DEFINE TABLE IF NOT EXISTS organizations;
DEFINE FIELD OVERWRITE name ON TABLE organizations TYPE string;

# Contestants table
DEFINE TABLE IF NOT EXISTS contestants;
DEFINE FIELD OVERWRITE name ON TABLE contestants TYPE object;
DEFINE FIELD OVERWRITE name.first ON TABLE contestants TYPE string;
DEFINE FIELD OVERWRITE name.middle ON TABLE contestants TYPE string | null;
DEFINE FIELD OVERWRITE name.last ON TABLE contestants TYPE string;
DEFINE FIELD OVERWRITE birthYear ON TABLE contestants TYPE int;

# Competitions table
DEFINE TABLE IF NOT EXISTS competitions;
DEFINE FIELD OVERWRITE type ON TABLE competitions TYPE "district" | "region" | "nation";
DEFINE FIELD OVERWRITE location ON TABLE competitions TYPE string;
DEFINE FIELD OVERWRITE schoolYear ON TABLE competitions TYPE string; # Format yyyy/yyyy (2025/2026)
DEFINE FIELD OVERWRITE organizations ON TABLE competitions TYPE array<record<organizations>> DEFAULT [];
DEFINE FIELD OVERWRITE teams ON TABLE competitions TYPE array<record<teams>> DEFAULT [];
DEFINE FIELD OVERWRITE checksDeaf ON TABLE competitions  TYPE array<record<checksDeaf>> DEFAULT [];
DEFINE FIELD OVERWRITE checksAlive ON TABLE competitions TYPE array<record<checksAlive>> DEFAULT [];
DEFINE FIELD OVERWRITE cards ON TABLE competitions TYPE array<record<cards>> DEFAULT [];

# Teams table
DEFINE TABLE IF NOT EXISTS teams;
DEFINE FIELD OVERWRITE number ON TABLE teams TYPE int | null; # Team number is unknown until they arrive at the finish line
DEFINE FIELD OVERWRITE organization ON TABLE teams TYPE record<organizations>;
DEFINE FIELD OVERWRITE category ON TABLE teams TYPE "M1" | "F1" | "M2" | "F2" | "M3" | "F3" | "M4" | "F4" | "M5" | "F5";
DEFINE FIELD OVERWRITE members ON TABLE teams TYPE array<record<contestants>>;

# Deaf checks table
DEFINE TABLE IF NOT EXISTS checksDeaf;
DEFINE FIELD OVERWRITE number ON TABLE checksDeaf TYPE int;
DEFINE FIELD OVERWRITE name ON TABLE checksDeaf TYPE string;
DEFINE FIELD OVERWRITE category ON TABLE checksDeaf TYPE "young" | "old";
DEFINE FIELD OVERWRITE answersCorrect ON TABLE checksDeaf TYPE array<string>;

# Alive checks table
DEFINE TABLE IF NOT EXISTS checksAlive;
DEFINE FIELD OVERWRITE number ON TABLE checksAlive TYPE int;
DEFINE FIELD OVERWRITE name ON TABLE checksAlive TYPE string;
DEFINE FIELD OVERWRITE category ON TABLE checksAlive TYPE "young" | "old";

# Deaf checks submitted answers table
DEFINE TABLE IF NOT EXISTS checksDeafSubmittedAnswers;
DEFINE FIELD OVERWRITE check ON TABLE checksDeafSubmittedAnswers TYPE record<checksDeaf>;
DEFINE FIELD OVERWRITE answers ON TABLE checksDeafSubmittedAnswers TYPE array<string>;

# Alive checks submitted times table
DEFINE TABLE IF NOT EXISTS checksAliveSubmittedTimes;
DEFINE FIELD OVERWRITE check ON TABLE checksAliveSubmittedTimes TYPE record<checksAlive>;
DEFINE FIELD OVERWRITE timePenalty ON TABLE checksAliveSubmittedTimes TYPE int;
DEFINE FIELD OVERWRITE timeWait ON TABLE checksAliveSubmittedTimes TYPE int;

# Cards table
DEFINE TABLE IF NOT EXISTS cards;
DEFINE FIELD OVERWRITE team ON TABLE cards TYPE record<teams>;
DEFINE FIELD OVERWRITE timeStart ON TABLE cards TYPE int;
DEFINE FIELD OVERWRITE timeFinish ON TABLE cards TYPE int;
DEFINE FIELD OVERWRITE checksDeafSubmittedAnswers ON TABLE cards TYPE record<checksDeafSubmittedAnswers>;
DEFINE FIELD OVERWRITE checksAliveSubmittedTimes ON TABLE cards TYPE record<checksAliveSubmittedTimes>;
