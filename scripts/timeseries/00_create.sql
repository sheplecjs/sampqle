-- drop and create a database for timeseries synthetic data create a table and read in from the variable 'timeseries'
DROP DATABASE IF EXISTS sampqle_timeseries;

CREATE DATABASE sampqle_timeseries;

\c sampqle_timeseries;

CREATE TABLE aud_usd(idx INT PRIMARY KEY, observed DECIMAL, tm DATE);

COPY aud_usd(idx, observed, tm)
FROM
    :timeseries_1 DELIMITER ',' CSV HEADER;

CREATE TABLE gbp_usd(idx INT PRIMARY KEY, observed DECIMAL, tm DATE);

COPY gbp_usd(idx, observed, tm)
FROM
    :timeseries_2 DELIMITER ',' CSV HEADER;

CREATE TABLE gbp_aud(idx INT PRIMARY KEY, observed DECIMAL, tm DATE);

COPY gbp_aud(idx, observed, tm)
FROM
    :timeseries_3 DELIMITER ',' CSV HEADER;