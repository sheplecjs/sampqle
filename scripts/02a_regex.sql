-- Replace any obvious email addresses from nps comments to reduce chance of PII leaking.
CREATE
OR REPLACE VIEW nps_clean AS
SELECT

timestamp,
score,
REGEXP_REPLACE(comments, '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$', '****@****', 'g')

FROM nps;