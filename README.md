Bacterial Genomics Analysis Pipeline
=========================================

#### Step 1. Sequencing reads quality check with FastQC
[FastQC](http://www.bioinformatics.babraham.ac.uk/projects/download.html) is a quality control application for high throughput sequence data. It can be called simply by calling fastqc followed by a list of fastq files to analyze. The results can be found in the same directory as the input file.
* **[_Command_] fastqc input1.fastq input.fastq input3.fastq**

#### Step 2. Reads pruning
After the quality check, low quality reads can be trimmed with public tools like [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic). We don't do this often since no abvious improvements were observed for downstream analysis after trimming the reads.

#### Step 3. De novo assembly
##### De novo assembly
Short sequencing reads are assembled with de novo assembly software into long contigs for downstream analysis. The software we have been using is [Velvet](https://www.ebi.ac.uk/~zerbino/velvet/), of which the parameters can be optimized with [VelvetOptimiser](http://bioinformatics.net.au/software.velvetoptimiser.shtml).
##### Summary statistics
A script named [contigLength.pl](https://github.com/xiaeryu/Bacterial-genomics/blob/master/contigLength.pl) can be found in this repository to check the quality of the assembly.
