Species identification
===========================================

The species identification task can be done simply by querying the assembled contigs against the 16S RNA database for the most 
similar 16S RNA.

A sample database is the [HOMD database](http://www.homd.org/modules.php?op=modload&name=seqDownload&file=index&type=R), 
while other possibilities are well summarized and compiled at [greengenes](http://greengenes.lbl.gov/Download/Sequence_Data/Fasta_data_files/).

After making the fasta file into a blastn database, query the assembled contigs against the database with blastn.
Then sort the output based on the bit score for the most similar sequence and the annotation.
```sh
$ input="contigs.fa"  # The input contig file, modify accordingly.
$ database="HOMD_16S_rRNA_RefSeq_V13.2.fasta" # The input reference fasta file, modify accordingly.
$ makeblastdb -in $database -out $database -dbtype nucl
$ blastn -db $database -query $input -task blastn -outfmt 7 > $input\_blast.out
$ grep -v '#' $input\_blast.out | sort -nrk12 | head -3 | awk '{print $2}' | while read line; do grep $line $database; done > $input.species
```
