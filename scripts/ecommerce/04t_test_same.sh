#!/bin/bash

diff <(psql -d sampqle -f scripts/04_with_CTE.sql) \
     <(psql -d sampqle -f scripts/04_with_subquery.sql)