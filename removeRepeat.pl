#!/usr/bin/perl

## This script aims at removing duplicate nucleotide sequences from a multiple-fasta file based on a similarity threshold.
## This is useful for the pre-processing of the coding sequences to remove gene duplicates.

## @param: multiple-fasta file with nucleotide sequences to remove.
## @param: similarity score threshold
## @param: output file

## @prerequisite: makeblastdb, blastn

## @output: multiple-fasta file with duplicate sequences removed.


if(!defined($ARGV[2])){
        die "Usage: perl $0 <multiple-fasta file with nucleotide sequences> <score threshold for removal> <output file>\n";
}

my $cutoff=$ARGV[1];

my %cat;
my $title;
open(SCAN,$ARGV[0]) or die "Cannot open input file:$!\n";
while(<SCAN>){
        chomp;
        if(/^>(\S+)/){
                $title=$1;
        }else{
                s/\s+//g;
                $cat{$title}.=$_;
        }

}
close SCAN;

system("mkdir tmp");

system("makeblastdb -in $ARGV[0] -out ./tmp/tmp_database -dbtype nucl");

my $trace;
my $seq;
my %removal;

open(INPUT,"$ARGV[0]") or die "Cannot open input file:$!\n";
while(<INPUT>){
        chomp;
        if(/^>(\S+)/){
                my $tmp=$1;
                if(defined($trace)){
                        open(TMP,"> ./tmp/xey_tmp") or die "Cannot write to the current directory:$!\n";
                        print TMP ">$trace\n";
                        print TMP "$seq\n";
                        close TMP;
                        system("blastn -query ./tmp/xey_tmp -db ./tmp/tmp_database -task blastn -outfmt 7 > ./tmp/output_blast");
                        open(BLAST,"./tmp/output_blast") or die "Cannot locate tmp file:$!\n";
                        while(<BLAST>){
                                chomp;
                                if(!/^#/){
                                        my @tmp=split(/\t/);
                                        if($tmp[0] ne $tmp[1]){
                                                my $length=length($cat{$tmp[0]});
                                                my $score=$tmp[3]*$tmp[2]*0.01/$length;
                                                if($score>=$cutoff){
                                                        if($removal{$tmp[0]}==0 && $removal{$tmp[1]}==0){
                                                                if(length($cat{$tmp[0]})>=length($cat{$tmp[1]})){
                                                                        $removal{$tmp[1]}=1;
                                                                }else{
                                                                        $removal{$tmp[0]}=1;
                                                                }
                                                        }
                                                }else{
                                                        last;
                                                }
                                        }
                                }
                        }
                }
                $trace=$tmp;
                $seq="";
        }else{
                s/\s+//g;
                $seq.=$_;
        }
}
open(TMP,"> ./tmp/xey_tmp") or die "Cannot write to the current directory:$!\n";
print TMP ">$trace\n";
print TMP "$seq\n";
close TMP;
system("blastn -query ./tmp/xey_tmp -db ./tmp/tmp_database -task blastn -outfmt 7 > ./tmp/output_blast");
open(BLAST,"./tmp/output_blast") or die "Cannot locate tmp file:$!\n";
while(<BLAST>){
        chomp;
        if(!/^#/){
                my @tmp=split(/\t/);
                if($tmp[0] ne $tmp[1]){
                        my $length=length($cat{$tmp[0]});
                        my $score=$tmp[3]*$tmp[2]*0.01/$length;
                        if($score>=$cutoff){
                                if($removal{$tmp[0]}==0 && $removal{$tmp[1]}==0){
                                        if(length($cat{$tmp[0]})>=length($cat{$tmp[1]})){
                                                $removal{$tmp[1]}=1;
                                        }else{
                                                $removal{$tmp[0]}=1;
                                        }
                                }
                        }else{
                                last;
                        }
                }
        }
}

system("rm -rf tmp");

open(OUT, "> $ARGV[2]") or die "Cannot write to the output file:$!\n";
foreach my $key(keys %cat){
        unless($removal{$key}==1){
                print  OUT ">$key\n$cat{$key}\n";
        }
}
close OUT;
