-- Produce queries to show row counts in all tables
SELECT
    relname,
    n_live_tup
FROM
    pg_stat_user_tables;

-- sample output:
-- 
--    relname    | n_live_tup 
-- --------------+------------
--  users        |       1000
--  transactions |        128
--  sessions     |       5067
--  nps          |       1455
--  products     |       1000
--  profiles     |        763
-- (6 rows)