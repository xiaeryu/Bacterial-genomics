#!/usr/bin/perl
##############################################################################
## This script is modified based on the script below:
##############################################################################
## source http://seqanswers.com/forums/showthread.php?t=2766  author = BENM
## count and maximum length added by Aaron Liston June 8, 2011
##############################################################################
## Modifications are made to restrict the calculation only to reads above
## certain user-defined lengths.
##############################################################################

## This script aims at calculating the stats of de novo aseembly contigs.
## Input1. the input contig file in fasta format.
## Input2. the length specified.

if(!defined($ARGV[1])){
        die "$0:<input contig file in fasta format><set the minimum length that a contig will be counted in the output statistics>\n";
}

my $cutOff=$ARGV[1];
use strict;
my ($len,$total,$contigs)=(0,0,0);
my @x;

open(INPUT,"$ARGV[0]") or die "Cannot open input file:$!\n";
while(<INPUT>){
        if(/^[\>\@]/){
                if($len>=$cutOff){
                        $total+=$len;
                        $contigs ++;
                        push @x,$len;
                }
                $len=0;
        }
        else{
                s/\s//g;
                $len+=length($_);
        }
}
if ($len>=$cutOff){
        $total+=$len;
        push @x,$len;
}
close INPUT;

@x=sort{$b<=>$a} @x;
my $max_value = $x[0];
my ($count,$half)=(0,0);
for (my $j=0;$j<@x;$j++){
        $count+=$x[$j];
        if (($count>=$total/2)&&($half==0)){
                print "sequence #: $contigs\t";
                print "total length: $total\t";
                print "max length: $max_value\t";
                print "N50: $x[$j]\t";
                $half=$x[$j]
        }elsif ($count>=$total*0.9){
                print "N90: $x[$j]\n";
                exit;
        }
}
