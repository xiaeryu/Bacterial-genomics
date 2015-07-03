Blast Pipeline for Identification of NDM Plasmid
=========
**Function:**  
A wrapper script [blastPipeline.sh](https://github.com/xiaeryu/Bacterial-genomics/blob/master/blastPipeline.sh) has been written to identify NDM plasmid from assembled contigs 
 with several steps:  
1. Identify the contig containing the NDM gene from the _de novo_ assemblies.  
2. Find similar plasmids in the NCBI nt database to the identified contig.  
3. Sort the assemblies against each of the assembled contigs to calculate what percent of each plasmid is covered by the assemblies.

**Scripts to download:**  
[contigSequence.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/contigSequence.pl)  
[searchNCBI.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/searchNCBI.pl)  
[process.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/process.pl)  
[ABACAS](http://sourceforge.net/projects/abacas/files/)

**Before running:** To modify accordingly: Line 7-9 about the databases to use; Line 33 about the path to ABACAS.  
**Running:** 
```shell
sh blastPipeline.sh input.contig.fa out_directory out_prefix
```
