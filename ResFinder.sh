## The ResFinder database is readily avialable at:
## https://cge.cbs.dtu.dk/services/data.php

## Step 1. Construct the database (Done only once):
makeblastdb -in all_databases.fsa -out resfinder -dbtype nucl

## Step 2. Blast the contigs in the database:
blastn -query contigs.fa -db resfinder -task blastn -outfmt 7 > contigs.resfinder.blast.out

## Step 3. Parse the blast output file:
perl hitDB.pl all_databases.fsa contigs.resfinder.blast.out 0.95(can change) 80(can change) > contigs.resfinder.parse.out

## Step 4. Collapse the .parse.out file to collapse overlapping hits.
sort -k1 -nk7 contigs.resfinder.parse.out | perl collapsePS.pl  - > contigs.resfinder.filter.out
