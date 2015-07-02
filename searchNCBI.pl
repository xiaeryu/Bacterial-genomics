#!/usr/bin/perl

#This script aims at finding all lines without signal '#', regards them as NCBI entries and download NCBI information.

if(!defined($ARGV[0]) || !defined($ARGV[1]) || !defined($ARGV[2])){
        die "$0:<input file><path to NCBI information directory><output directory>\n";
}

open(INPUT,"$ARGV[0]") or die "Cannot open input file:$!\n";
while(<INPUT>){
        chomp;
        if((!$_) || (/^#/)){
                print "$_\n";
        }else{
                my $search=$_;
                my $fasta_file=$_.'.fasta';
                my $flag=0;
                my $title;
                chdir "$ARGV[1]";
                opendir(NCBI,"$ARGV[1]") or die "Cannot open NCBI information DIR:$!\n";
                while(my $file=readdir(NCBI)){
                        if($file eq $fasta_file){
                                $flag=1;
                        }
                }
                closedir NCBI;

                if($flag==0){
                        open(OUT,"> $ARGV[2]/tmp.sh") or die "Cannot write to the output directory:$!\n";
                        print OUT "wget -O $fasta_file http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\\&id=$search\\&rettype=fasta\n";
                        close OUT;
                        system("chmod +x $ARGV[2]/tmp.sh");
                        system("sh $ARGV[2]/tmp.sh");

                }
                my $seq_length=0;
                my $title;

                if(open(ENT,"./$fasta_file")){
                        while(<ENT>){
                                chomp;
                                if(/^>/){
                                        my @tmp=split(/\s+/);
                                        for(my $i=1;$i<=$#tmp;$i++){
                                                $title.=$tmp[$i].' ';
                                        }
                                }else{
                                        $seq_length+=length($_);
                                }
                        }
                        close ENT;
                        print "$search\t$seq_length\t$title\n";
                }else{
                        print "$search\tFailure in automate download!\n";
                }
        }
}
close INPUT;
system("rm $ARGV[2]/tmp.sh");
