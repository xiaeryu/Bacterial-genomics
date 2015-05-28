Bacterial Genomics Analysis Pipeline
=========================================

#### Step 1. Sequencing reads quality check with FastQC
FastQC is a quality control application for high throughput sequence data that is freely available at
the [Babraham Bioinformatics Project site](http://www.bioinformatics.babraham.ac.uk/projects/download.html). It can be called simply by calling fastqc followed by a list of fastq files to analyze. The results can be found in the same directory as the input file.
* **[_Command_] fastqc input1.fastq input.fastq input3.fastq**

#### Step 2. Reads pruning
After the quality check, low quality reads can be trimmed with public tools like [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic). We don't do this often since no abvious improvements were observed for downstream analysis after trimming the reads.
