Plasmid Tree
===

The clustering of plasmids is based on the methods described by Zhou, et al. in the paper 
["Genetic relationships among 527 Gram-negative bacterial plasmids"](http://linkinghub.elsevier.com/retrieve/pii/S0147-619X(12)00062-5)

Preparation
---
##### Complete plasmid sequences for analysis:
* The fna files be downloaded from NCBI ftp site: ftp://ftp.ncbi.nlm.nih.gov/genomes/Plasmids/
* Sequences with accession numbers known can be downloaded with [Entrez Programming Utilities](http://www.ncbi.nlm.nih.gov/books/NBK25499/).
```shell
wget -O $output.fna http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=$accession\&rettype=fasta
```

##### Coding sequences of each plasmid sequence:
* The ffn files be downloaded from NCBI ftp site: ftp://ftp.ncbi.nlm.nih.gov/genomes/Plasmids/
* Sequences with accession numbers known can be downloaded with [Entrez Programming Utilities](http://www.ncbi.nlm.nih.gov/books/NBK25499/).
```shell
wget -O $output.ffn http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=$accession\&rettype=fasta_cds_na
```
* If the coding sequences are not available in NCBI, then can use orf prediction software like _prodigal_.
```shell
prodigal -i input_file -o output_summary -a output_protein_sequence -d output_nt_sequence -s output_gene_file
# For very short sequences that cannot be predicted as above:
prodigal -p meta -i input_file -o output_summary -a output_protein_sequence -d output_nt_sequence -s output_gene_file
```

Pre-processing
---
1. Remove duplicate gene coding sequences on each plasmid using [removeRepeat.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/removeRepeat.pl) based on a sequence similarity score (use 0.45 usually).
```shell
perl removeRepeat.pl input.ffn 0.45 input.removed.ffn
```

2. Concatenate all complete plasmid sequences to generate a multiple-fasta file.
```shell
cat fna/* > genomes.fasta
```

3. Concatenate all coding sequences to generate a multiple fasta file.
```shell
cat removed.ffn/* > genes.fasta
```

Generate data matrix
---
##### Blastn to identify genes in genetic sequences.
```shell
makeblastdb -in genes.fasta -out genes.fasta -dbtype nucl
blastn -query genomes.fasta -db genes.fasta -task blastn -outfmt 7 > genome_against_gene.blast.out
```

##### Parse blast output file
```shell
perl parseBlastout.pl genomes.fasta genes.fasta genome_against_gene.blast.out genome_against_gene.parse.out
```

##### Adding outgroup
```shell
var=`awk '{print NF}' genome_against_gene.parse.out | head -1`; echo -n "outgroup" >> genome_against_gene.parse.out; for(( i=1;i<$var;i++ )); do echo -ne "\t0" >> genome_against_gene.parse.out; done; echo >> genome_against_gene.parse.out
```

Calculate  distance matrix
---
Based on the feature matrix, the distance matrix can be calculated with the script [dist.r](https://github.com/xiaeryu/Bacterial-genomics/blob/master/dist.r)
```shell
# @input 1: data matrix
# @input 2: target output distance matrix
# @require: R package 'data.table'

Rscript dist.r genome_against_gene.parse.out genome_against_gene.distance.all
```
