input=$1
database=$2

makeblastdb -in $database -out $database -dbtype nucl
blastn -db $database -query $input -task blastn -outfmt 7 > $input\_sp.blast.out
grep -v '#' $input\_sp.blast.out | awk '{if($4 > 700) print}' | sort -nrk12 | head -3 | awk '{print $2}' | while read line; do grep $line $database; done > $input.species
