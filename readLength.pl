#!/usr/bin/perl

## This script aims at summarizing the sequencing stats from FASTQ files.
## Input1. the input fastq file
## Input2. choice, 1 for print out the read length for each read, 2 for print out the summary stats.

if(!defined($ARGV[1])){
        die "$0:<input fastq file><Choice, 1 for show each read length, 2 for show total>\n";
}

my $choice=$ARGV[1];
my $total;
my $number;
my $count;
open(INPUT,$ARGV[0]) or die "Cannot open input file:$!\n";
while(<INPUT>){
        chomp;
        if($count%4==1){
                my $here=length($_);
                if($choice==2){
                        $total+=$here;
                        $number++;
                }elsif($choice==1){
                        print "$here\n";
                }
        }
        $count++;
}
close INPUT;

if($choice==2){
        print "$ARGV[0]\tTotal number of reads: $number\tNumber of bases: $total\n";
}
