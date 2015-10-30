#!/usr/bin/perl

if(!defined($ARGV[1])){
        die "$0:<input distance matrix file><output file>\n";
}

my $count=-1;
open(SCAN,$ARGV[0]) or die "Cannot open input file:$!\n";
while(<SCAN>){
        $count++;
}
close SCAN;

open(OUT, "> $ARGV[1]") or die "Cannot write to the output file specified:$i!\n";
print OUT "\t$count\n";


open(INPUT,$ARGV[0]) or die "Cannot open input dist matrix file:$!\n";
my $throw = <INPUT>;
while(<INPUT>){
        chomp;
        my @tmp=split(/\s+/);
        my $name;
        if($tmp[0]=~m/\w+\|\w+\|\w+\|(\S+)\|/){
                $name = (split('\.',$1))[0];
        }else{
                $tmp[0] =~ s/"//g;
                $name = $tmp[0];
        }

        if(length($name) > 9){
                $name = substr($name,-9,9);
        }
        print OUT $name.(" " x (10-length($name)));

        print OUT "$tmp[1]";
        for(my $i=2;$i<=$#tmp;$i++){
                print OUT "\t$tmp[$i]";
        }
        print OUT "\n";
}
close INPUT;
close OUT;
