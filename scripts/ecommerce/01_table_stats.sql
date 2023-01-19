-- Produce queries to show row counts in all tables
SELECT
    relname,
    n_live_tup
FROM
    pg_stat_user_tables;