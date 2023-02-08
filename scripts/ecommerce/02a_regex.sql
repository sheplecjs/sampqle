-- Replace any obvious email addresses from nps comments to reduce chance of PII leaking.
CREATE
OR REPLACE VIEW nps_clean AS
SELECT
    timestamp AS "Submission",
    score AS "Response",
    REGEXP_REPLACE(
        comments,
        '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]*',
        '****@****',
        'g'
    ) AS "Cleaned Comment"
FROM
    nps;

SELECT
    *
FROM
    nps_clean
LIMIT
    15;

-- sample output:

-- Submission           | Response | Cleaned Comment                                                                                                                                                                                        regexp_replace                                                                                                                                                                                           
-- ---------------------+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  2021-11-08 15:55:37 |        3 | Nostrud sit commodo veniam laboris ipsum et nostrud qui do quis consequat. ****@****
--  2021-11-30 11:23:37 |        6 | Aliqua irure sunt enim ullamco incididunt amet adipiscing velit velit nostrud, esse aute proident incididunt magna deserunt cillum tempor. ****@****
--  2022-01-09 21:24:28 |        2 | Id aliqua qui laborum, laborum est ad est ut cillum esse ipsum. ****@****
--  2021-12-18 23:35:46 |        9 | Irure enim laborum tempor eu aliquip cillum quis incididunt minim incididunt, exercitation anim aliqua dolore commodo irure cupidatat occaecat commodo aute sit consectetur tempor veniam commodo non esse eu voluptate. ****@****
--  2022-01-27 16:45:24 |       10 | Commodo reprehenderit aute labore mollit veniam occaecat irure elit aute elit reprehenderit minim adipiscing dolor deserunt sunt
--  aliqua cillum. ****@****
--  2022-02-08 08:34:13 |     8 | Culpa officia sit sunt amet sint ea irure fugiat id aliqua duis reprehenderit eu exercitation fugiat id nisi. ****@****
--  2022-01-19 22:36:54 |     7 | Cillum quis fugiat anim magna pariatur nostrud est exercitation enim sunt enim labore qui aliquip, ea consectetur tempor duis no
-- strud in consectetur enim id cupidatat qui ea consectetur do laboris duis duis ad, reprehenderit minim eu est velit irure aute ullamco fugiat et tempor ut cupi
-- datat, deserunt dolor eu sed qui commodo laborum amet tempor officia nisi elit nisi enim. ****@****
--  2022-01-13 11:14:51 |     6 | Laborum mollit elit id officia ea ullamco consectetur et esse pariatur eiusmod consequat mollit, laborum ullamco occaecat non, m
-- agna adipiscing in aliqua consequat anim ad non. ****@****
--  2022-01-01 20:09:14 |     9 | Incididunt proident ullamco eiusmod sint nisi et ullamco minim adipiscing consectetur et ullamco occaecat. ****@****
--  2021-12-04 16:07:11 |     7 | Consequat est in magna sunt, cillum incididunt do aute occaecat sunt non elit est occaecat esse excepteur ut, quis nostrud tempo
-- r tempor est consequat nulla eu esse. ****@****
-- (10 rows)