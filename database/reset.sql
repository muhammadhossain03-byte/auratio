-- database/reset.sql
-- Drops and rebuilds auratio_db from scratch.
--
-- Usage (from mysql client, working directory = project root):
--   SOURCE database/reset.sql;
--
-- Or run each file separately from the command line:
--   C:\xampp\mysql\bin\mysql -u root < database/schema.sql
--   C:\xampp\mysql\bin\mysql -u root auratio_db < database/seed.sql

SOURCE database/schema.sql;
SOURCE database/seed.sql;
