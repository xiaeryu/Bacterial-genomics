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

Build consensus tree
---
##### Calculate distance matrix
Based on the feature matrix, the distance matrix can be calculated with the script [dist.r](https://github.com/xiaeryu/Bacterial-genomics/blob/master/dist.r)
```shell
# @input 1: data matrix
# @input 2: target output distance matrix
# @require: R package 'data.table'

Rscript dist.r genome_against_gene.parse.out genome_against_gene.all.dist
```

##### Distance matrix to phylip format
```shell
perl src/phylipFromDist.pl genome_against_gene.all.dist genome_against_gene.all.phy
```

##### Phylogenetic tree
A neighbor-joining tree can be built with [phylip](http://evolution.genetics.washington.edu/phylip.html) by calling the function _neighbor_.


Build bootstrap tree
---
Apart from the consensus tree, a bootstrap tree is also needed to assess the accuracy of the consensus tree.  

##### Sampling
To conduct bootstrap tree, sampling should be conducted with the script [sampling.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/sampling.pl)

* Usage:
```shell
perl sampling.pl <input file to sample from> <percentage to take> <number of rounds to sample> <output directory> <prefix of output> <start number for naming>

# Argument 1: input genome_against_gene.parse.out file to sample from
# Argument 2: percentage for downsampling, suggested value can be 0.2
# Argument 3: number of rounds for the bootstrap analysis, suggested value can be 1000
# Argument 4: directory for the downsampling files
# Argument 5: prefix of the output files
# Argument 6: the start number of the naming.
```

* Example:
```shell
perl sampling.pl genome_against_gene.parse.out 0.2 1000 ./sampling.mat/ sampling 1
```

##### Tree building
For each downsampled matrix, build a neighbor-joining tree following the 'Build consensus tree' session. A number of phylogenetic trees would be constructed, from which the bootstrap tree can be computed with the phylip program _consense_. 
