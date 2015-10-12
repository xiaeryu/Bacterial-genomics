#!/usr/bin/perl

if(!defined($ARGV[5])){
        die "$0:<input file to sample from><percentage to take><number of rounds to sample><output directory><prefix of output><start number for naming>\n";
}

my $input=$ARGV[0];
my $percentage=$ARGV[1];
my $round=$ARGV[2];
my $out_dir=$ARGV[3];
my $prefix=$ARGV[4];
my $start=$ARGV[5];


my $col;
open(INPUT,$input) or die "Cannot open input file:$!\n";
while(<INPUT>){
        chomp;
        my @tmp=split(/\s+/);
        $col=$#tmp+1;
        last;
}
close INPUT;

for(my $i=1;$i<=$round;$i++){
        my @candidate;
        for(my $j=1;$j<$col;$j++){
                my $here=rand(1);
                if($here<$percentage){
                        $candidate[$j]=1;
                }else{
                        $candidate[$j]=0;
                }
        }
        my $count=$i+$start-1;
        open(OUT,"> $out_dir/$prefix.$count");
        open(INPUT,$input) or die "Cannot open input file:$!\n";
        while(<INPUT>){
                chomp;
                my @tmp=split(/\s+/);
                print OUT "$tmp[0]";
                for(my $t=1;$t<$col;$t++){
                        if($candidate[$t]==1){
                                print OUT "\t$tmp[$t]";
                        }
                }
                print OUT "\n";
        }
        close INPUT;
        close OUT;
}
