# Input files
input=$1                                                        # Input contig file
outdir=$2                                                       # Output directory
prefix=$3                                                       # Ouput prefix

# Other variables
database="path/to/NDM-1"                                        # Constructed NDM-1 database
nt="/path/to/nt"                                                # The prepared nt database
script="/path/to/"                                              # Directory to the perl scripts

# Search for NDM-containing contig
blastn -query $input -db $database -task blastn -outfmt 7 > $outdir/$prefix\_blast.out
awk '{if(($4>800)&&($3>=95)) print}' $outdir/$prefix\_blast.out | grep -v '#' | awk '{print $1}' > $outdir/$prefix\_NDM.contigName
cat $outdir/$prefix\_NDM.contigName | while read line; do perl $script/contigSequence.pl $input $line; done > $outdir/$prefix\_NDM.contigSeq


# Search for plasmids similar to the NDM-containing contig
blastn -db $nt -query $outdir/$prefix\_NDM.contigSeq -task blastn -outfmt 7 > $outdir/$prefix\_NDM.blast.out
grep -v '#' $outdir/$prefix\_NDM.blast.out | awk '{if(($4>2000)&&($3>=80)) print}' | awk '{print $2}' | sort | uniq | awk -F"|" '{print $4}' > $outdir/$prefix\_NDM.genomeName


# Annotate the plasmids and download reference data
mkdir $outdir/NCBI_info/
perl $script/searchNCBI.pl $outdir/$prefix\_NDM.genomeName $outdir/NCBI_info/ $outdir > $outdir/$prefix\_NDM.genomeName.anno


# Abacas to arrage the contigs against the references
# Change the path to the abacas script accordingly
mkdir $outdir/abacas
while read line;
do
        mkdir $outdir/abacas/$line;
        perl abacas.1.3.1.pl -r $outdir/NCBI_info/$line.fasta -q $input -p 'nucmer' -c -o $outdir/abacas/$line/contigSorted_$line;
done < $outdir/$prefix\_NDM.genomeName

# Summary
perl $script/process.pl $outdir/$prefix\_NDM.genomeName.anno $outdir/abacas $outdir/$prefix\_NDM.genome.summary
