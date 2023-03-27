-- drop and create a database for timeseries synthetic data create a table and read in from the variable 'timeseries'
DROP DATABASE IF EXISTS sampqle_timeseries;

CREATE DATABASE sampqle_timeseries;

\c sampqle_timeseries;

CREATE TABLE aud_usd(tm DATE PRIMARY KEY, observed DECIMAL);

COPY aud_usd(tm, observed)
FROM
    :timeseries_1 DELIMITER ',' CSV HEADER;

CREATE TABLE gbp_usd(tm DATE PRIMARY KEY, observed DECIMAL);

COPY gbp_usd(tm, observed)
FROM
    :timeseries_2 DELIMITER ',' CSV HEADER;

CREATE TABLE gbp_aud(tm DATE PRIMARY KEY, observed DECIMAL);

COPY gbp_aud(tm, observed)
FROM
    :timeseries_3 DELIMITER ',' CSV HEADER;