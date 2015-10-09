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
