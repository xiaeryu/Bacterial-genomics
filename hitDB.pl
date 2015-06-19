#!usr/bin/perl

## This script aims at extracting necessary information from blast output file.
## Input: 1. database fasta file for the blast search
##        2. blast output file
##        3. coverage cut-off, 0 to 1
##        4. identity cut-off, 0 to 100


if(!defined($ARGV[3])){
        die "Usage:<database fasta file for the blast search><input _blast.out file><coverage,0 to 1><identity, 0 to 100>\n";
}

my $input=$ARGV[1];
my $coverage=$ARGV[2];
my $identity=$ARGV[3];

my %storage;
my $trace;
my $length;
open(INPUT,$ARGV[0]) or die "Cannot open input query file for the blast search:$!\n";
while(<INPUT>){
        chomp;
        if(/>(\S+)/){
                if (defined($trace)){
                        $storage{$trace} = $length;
                }
                $trace = $1;
                $length = 0;
        }else{
                $length += length($_);
        }
}
close INPUT;
$storage{$trace} = $length;

print "query\thit\tidentity\thit_length\talignment_length\tmismatches\tgap_opens\tq.start\tq.end\ts.start\ts.end\te-value\tbit_score\n";
# NODE_1_length_29727_cov_113.546707      gi|281177210|dbj|AP009378.1|    99.98   29789   6       0       1       29789   4170358 4200146 0.0     5.369e+04
open(INPUT,$input) or die "Cannot open input _blast.out file:$!\n";
while(<INPUT>){
        chomp;
        if(!/^#/){
                my @tmp=split(/\s+/);
                if(($tmp[2]>=$identity) && ($tmp[3]>=$coverage*$storage{$tmp[1]})){
                        print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$storage{$tmp[1]}";
                        for($i=3;$i<=$#tmp;$i++){
                                print "\t$tmp[$i]";
                        }
                        print "\n";
                }
        }
}
close INPUT;
