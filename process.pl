#!/usr/bin/perl

if(!defined($ARGV[2])){
        die "$0:<input annotation file><directory to the abacas results files><output file>";
}

$out=$ARGV[1];

open(OUT,"> $ARGV[2]") or die "Cannot weite to the output file:$!\n";
open(INPUT,$ARGV[0]) or die "Cannot open input file:$!\n";
while(<INPUT>){
        my @tmp=split(/\t/);
        my $gap=0;
        unless(-z "$out/$tmp[0]/contigSorted_$tmp[0].gaps"){
                open(GAP,"$out/$tmp[0]/contigSorted_$tmp[0].gaps");
                while(<GAP>){
                        chomp;
                        my @here=split(/\s+/);
                        if($here[6] eq 'NON-Overlapping'){
                                $gap+=$here[1];
                        }
                }
                close GAP;
         }else{
                $gap=$tmp[1];
         }
         if($tmp[1]>0){
                printf OUT ("%s\t%d\t%.4f\t%d\t%s\n",$tmp[0],$tmp[1],1-$gap/$tmp[1],$tmp[1]-$gap,$tmp[2]);
         }


}
close INPUT;
close OUT;
