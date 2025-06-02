USE NS medvedi_stezka DB medvedi_stezka;

# Users table
DEFINE TABLE IF NOT EXISTS users;
DEFINE FIELD IF NOT EXISTS username ON users TYPE string;
DEFINE FIELD IF NOT EXISTS password ON users TYPE string;
DEFINE FIELD IF NOT EXISTS nickname ON users TYPE string;
DEFINE FIELD IF NOT EXISTS role ON users TYPE "admin" | "leader" | "validator";

# Logins table
DEFINE TABLE IF NOT EXISTS logins;
DEFINE FIELD IF NOT EXISTS user ON logins TYPE record<users>;
DEFINE FIELD IF NOT EXISTS datetime ON logins TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD IF NOT EXISTS expires ON logins TYPE datetime | null;
DEFINE FIELD IF NOT EXISTS token ON logins TYPE string;
DEFINE FIELD IF NOT EXISTS expired ON logins VALUE <future> {RETURN IF expires = null { false } ELSE { expires < time::now() }};

# Competitions table
DEFINE TABLE IF NOT EXISTS competitions;
DEFINE FIELD IF NOT EXISTS type ON competitions TYPE "district" | "region" | "nation";
DEFINE FIELD IF NOT EXISTS location ON competitions TYPE string;
DEFINE FIELD IF NOT EXISTS schoolYear ON competitions TYPE string;

# Organizations table
DEFINE TABLE IF NOT EXISTS organizations;
DEFINE FIELD IF NOT EXISTS competition ON organizations TYPE record<competitions>;
DEFINE FIELD IF NOT EXISTS name ON organizations TYPE string;

# Teams table
DEFINE TABLE IF NOT EXISTS teams;
DEFINE FIELD IF NOT EXISTS competition ON teams TYPE record<competitions>;
DEFINE FIELD IF NOT EXISTS number ON teams TYPE int | null; # Team number is unknown until they arrive at the finish line
DEFINE FIELD IF NOT EXISTS organization ON teams TYPE record<organizations>;
DEFINE FIELD IF NOT EXISTS category ON teams TYPE "1F" | "1M" | "2F" | "2M" | "3F" | "3M" | "4F" | "4M" | "5F" | "5M";

# Deaf checks table
DEFINE TABLE IF NOT EXISTS deafChecks;
DEFINE FIELD IF NOT EXISTS competition ON deafChecks TYPE record<competitions>;
DEFINE FIELD IF NOT EXISTS number ON deafChecks TYPE int;
DEFINE FIELD IF NOT EXISTS name ON deafChecks TYPE string;
DEFINE FIELD IF NOT EXISTS category ON deafChecks TYPE "young" | "old";
DEFINE FIELD IF NOT EXISTS answers ON deafChecks TYPE array<string> DEFAULT [];

# Alive checks table
DEFINE TABLE IF NOT EXISTS aliveChecks;
DEFINE FIELD IF NOT EXISTS competition ON aliveChecks TYPE record<competitions>;
DEFINE FIELD IF NOT EXISTS number ON aliveChecks TYPE int;
DEFINE FIELD IF NOT EXISTS name ON aliveChecks TYPE string;
DEFINE FIELD IF NOT EXISTS category ON aliveChecks TYPE "young" | "old";

# Cards table
DEFINE TABLE IF NOT EXISTS cards;
DEFINE FIELD IF NOT EXISTS competition ON cards TYPE record<competitions>;
DEFINE FIELD IF NOT EXISTS team ON cards TYPE record<teams>;
DEFINE FIELD IF NOT EXISTS startSeconds ON cards TYPE number;
DEFINE FIELD IF NOT EXISTS finishSeconds ON cards TYPE number;