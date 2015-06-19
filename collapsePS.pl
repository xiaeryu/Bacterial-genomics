#!usr/bin/perl

use strict;
use warnings;

if(!defined($ARGV[0])){
        die "$0:<input .parse.out file to collapes>\n";
}

my $trace="";
my $start;
my $end;
open(INPUT,$ARGV[0]) or die "Cannot open input file:$!\n";
my $throw = <INPUT>;
print $throw;
while(<INPUT>){
        chomp;
        my @tmp=split(/\s+/);
        if($tmp[0] ne $trace){
                print "$_\n";
                $trace=$tmp[0];
                $start = $tmp[7];
                $end = $tmp[8];
        }else{
                if($tmp[7]>=($start-3) && $tmp[8]<=($end+3)){

                }else{
                        print "$_\n";
                        $start = $tmp[7];
                        $end = $tmp[8];
                }
        }
}
close INPUT;
