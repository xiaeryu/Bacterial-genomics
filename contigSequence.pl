#!/usr/bin/perl

if(!defined($ARGV[0])){
        die "$0:<input contig.fa><contig name>\n";
}

my $name=$ARGV[1];
my $flag;

open(INPUT,"$ARGV[0]") or die "Cannot open input contig.fa file:$!\n";
while(<INPUT>){
        if(/>(\S+)/){
                if($name eq $1){
                        $flag=1;
                }else{
                        $flag=0;
                }
        }
        if($flag){
                print $_;
        }
}
close INPUT;
