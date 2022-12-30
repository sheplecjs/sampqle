echo 'Subquery time:'

for N in {1..10};

do

    psql -d sampqle -c '\timing' -f scripts/04_with_subquery.sql | grep Time:;

done

echo 'CTE time:'

for N in {1..10};

do

    psql -d sampqle -c '\timing' -f scripts/04_with_CTE.sql | grep Time:;

done