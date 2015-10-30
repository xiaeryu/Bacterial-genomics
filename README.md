Bacterial Genomics Analysis Pipeline
=========================================

#### Step 1. Sequencing reads quality check with FastQC
[FastQC](http://www.bioinformatics.babraham.ac.uk/projects/download.html) is a quality control application for high throughput sequence data. It can be called simply by calling fastqc followed by a list of fastq files to analyze. The results can be found in the same directory as the input file.
* **[_Command_] fastqc input1.fastq input.fastq input3.fastq**

#### Step 2. Reads pruning
After the quality check, low quality reads can be trimmed with public tools like [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic). We don't do this often since no abvious improvements were observed for downstream analysis after trimming the reads.  
**Update(2015-06-19):** Based on our experience, trimming based on quality score brings no significant improvements for downstream analysis. So given the absence of adaptor contamination, this step can be removed from the pipeline.

#### Step 3. Summary of the sequencing throughput
The sequencing throughput both before and after trimming the reads can be summarized by calculating: 1> the number of reads; 2> the number of bases. This can be down with the script [readLength.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/readLength.pl) in this repository.  
**Update(2015-10-30):** [readLength.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/readLength.pl) has been updated for accepting input files in gzipped-fastq format.

#### Step 4. _De novo_ assembly
##### _De novo_ assembly
Short sequencing reads are assembled with _de novo_ assembly software into long contigs for downstream analysis. The software we have been using is [Velvet](https://www.ebi.ac.uk/~zerbino/velvet/), of which the parameters can be optimized with [VelvetOptimiser](http://bioinformatics.net.au/software.velvetoptimiser.shtml).  
**Update(2015-06-19):** Based on an in house assessment of assembly tools, [SPAdes](http://bioinf.spbau.ru/spades) is suggested to fulfill the task!:octocat:
##### Summary statistics
A script named [contigLength.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/contigLength.pl) can be found in this repository to check the quality of the assembly.

#### Step 5. _In silico_ MLST
Given the species known and the MLST scheme available for the species, the _in silico_ MLST can be performed with a python script named [srst](http://sourceforge.net/projects/srst/files/mlstBLAST/) making use of BLAST similarity search. If, however, we don't want to assume the species known, we can identify the species first before this step.  
**Update(2015-06-28):** srst is often problematic for typing _K.pneumoniae_ by misjudging the PhoE gene as absent, thus not recommended for such purposes.  
**Update(2015-07-02):** [srst2](https://github.com/katholt/srst2) is an alternative to srst for _in silico_ MLST.  
**Update(2015-10-20):** [srst2](https://github.com/katholt/srst2) is highly suggested to be used for _in silico_ MLST.

#### Step 6. ResFinder to identidy resistance genes
In fact this can be done for ResFinder, PlasmidFinder, VirulenceFinder, and other finders thanks to the well curated database provided by [Center for Genomic Epidemiology](https://cge.cbs.dtu.dk/services/data.php):smile:.  
An example script for such pipelines can be found as [ResFinder.sh](https://github.com/xiaeryu/Bacterial-genomics/blob/master/ResFinder.sh) in this repository, with individual scripts used in this pipeline also in this repository as [hitDB.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/hitDB.pl) and [collapsePS.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/collapsePS.pl).  
**Update(2015-07-02):** [srst2](https://github.com/katholt/srst2) can also be used for such purposes.  
**Update(2015-10-20):** [srst2](https://github.com/katholt/srst2) is highly suggested to be used for resistance gene identification.
