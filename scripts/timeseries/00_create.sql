-- drop and create a database for timeseries synthetic data create a table and read in from the variable 'timeseries'

DROP DATABASE IF EXISTS sampqle_timeseries;

CREATE DATABASE sampqle_timeseries;

\c sampqle_timeseries;

CREATE TABLE aud_usd(idx INT PRIMARY KEY, observed DECIMAL, tm DATE);

COPY aud_usd(idx, observed, tm)
FROM
    :timeseries DELIMITER ',' CSV HEADER;