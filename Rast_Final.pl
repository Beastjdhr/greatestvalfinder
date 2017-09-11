#!/usr/bin/perl
#Rast Final
use warnings;
use strict;
use Getopt::Long;

GetOptions(
        'left=i'=> \my $genL,
        'right=i' => \my $genR,
        'contexts=s' => \my $contexts,
) or die "Invalid options passed to $0\n";

my $outputdir="/LUSTRE/usuario/nselem/DANY/CORASONcoord/salida";
my $inputdir="/LUSTRE/usuario/nselem/DANY/MK_INPUTS";
my $RastIdFile="$inputdir/Actinos.ids";
my $ornament="$inputdir/ornament.3";
my $genomeFiles="/LUSTRE/usuario/nselem/DANY/MK_INPUTS/GENOMES";

my @CONTEXTS= split/,/, $contexts;

my %OrgName;
my @fileList= idshash($RastIdFile, \%OrgName, $outputdir,@CONTEXTS);

my $package= join(",",@fileList);
print $package;

open FILE, ">testRast_final.txt" or die "$!\n";
print FILE "these are the rast files $package end\n";
print FILE "contexts @CONTEXTS end\n";

coordRetriever($genL,$genR,$outputdir,$ornament,$genomeFiles,\%OrgName, @fileList);
close FILE;
#_________________________________SUBS__________________________________#

sub idshash {
        my @files;
        my $file=shift;
        my $OrgName=shift;
	my $destination=shift;
	my @query=@_;

        foreach my $gene (@query) {
                if ($gene=~/^\d/) { 
			
			my @pts= split/\./, $gene;
			my $genome= $pts[0] . "." . $pts[1]; 
			my $gNum= $pts[2];
               		my $line= `grep $genome $file`; 
                	my @info= split/\t/, $line;
                	my $jobId= $info[0]; 
			my $fileName= $jobId . "_" . $gNum . ".input"; 
               		
			push @files, $fileName;
			open FILE, ">>$destination/$fileName" or die "$! error in Rast_Final.pl\n";
			close FILE;
			chomp $info[2];
                	$OrgName->{$jobId}= $info[2];
                	#print "$jobId -> $OrgName{$jobId}\n";
 		}
	}
	return @files;
 }

#_________________________________________________________________________________________________

sub coordRetriever {
	my $lN= shift;
	my $rN=shift;
	my $out=shift;
	my $ornmnt=shift;
	my $genomeTxt=shift;
	my $orgName=shift;
	my @files=@_;
	
	

	foreach my $file (@files) {
		my @fileData;
		my @breakdown= split/[_\.]/, $file;
		my $jobId=$breakdown[0];
		my $gNum=$breakdown[1];
		my $fle= $jobId . ".txt";
		my $minimo= $gNum - $lN;
		my $maximo= $gNum +$rN;
		my @gNums=($minimo .. $maximo);
		my $gNumMatch= `grep peg.$gNum $fle`;
		my @paRtS= split/\t/, $gNumMatch;
		my $centralContig=$paRtS[0];	

		foreach my $geNe (@gNums) {
			open CT,">>fcTest.txt" or die "$!\n";
			print CT "gene $geNe\n";
		
			my $maTch= `grep "peg.$geNe\tpeg" $fle`;print CT "gene $geNe and match $maTch end \n";close CT;
			my @arr= split/\t/, $maTch;
			my $contig= $arr[0];
			my $startCoord= $arr[4];
			my $endCoord= $arr[5];
			my $sign= $arr[6];
			my $number=0;
			my $fig= $arr[1];
			my @fiG= split/[\.\|]/, $fig;
			my $geNomE= $fiG[1] . "." . $fiG[2];
			my $molecFunction= $arr[7];
			my $id= $arr[1];
			my $color2=0;
			my $none= "none";
			my $genomeGen= $geNomE . "." . $geNe; open TEST, ">>fcTest.txt" or die "$!\n"; print TEST "genomegen $genomeGen end\n"; 
			my $actinosMatch= `grep $genomeGen\t ActinoSMASH`;print TEST "actinosmatch $actinosMatch end\n"; close TEST;
			my @actinosParts= split/[\t\s]/, $actinosMatch;
			my $function= $actinosParts[2]; 
			unless ($function eq "") {$none=$function; $number=7;}
			
			if ($geNe eq $gNum) {
				$number=1;
				$color2= centralGenes($genomeGen, $ornmnt);
				my $cData= 1 . "....." .$startCoord . "\t" . $endCoord . "\t" . $sign.  "\t" . $number . "\t" . "$jobId:$orgName->{$jobId}" . "\t" . $molecFunction . "\t" . $id ."\t" . $color2 . "\t" . $none . "\n";	
				push @fileData, $cData;
				}
		
			else {	my $gData= 3 . "....." .$startCoord . "\t" . $endCoord . "\t" . $sign .  "\t" . $number . "\t" . "$jobId:$orgName->{$jobId}" . "\t" . $molecFunction . "\t" . $id ."\t" . $color2 . "\t" . $none . "\n";
				if ($centralContig eq $contig) {push @fileData, $gData; open COT,">>fcTest.txt" or die "$!\n"; print COT"match cc $centralContig nd c $contig end id $id end\n"; close COT;}
			else {open CON,">>fcTest.txt" or die "$!\n";print CON "no match cc $centralContig end c $contig  id $id end\n"; close CON;}
				}
			}
		my @finalData= sort @fileData;
		foreach my $datum (@finalData) {
			my @daTa= split/\.\.\.\.\./, $datum;
			shift @daTa;
			open FILE, ">>$out/$file" or die "$! check your gene writing\n";
			print FILE $daTa[0];
			close FILE;
			}
	}
 }

sub centralGenes {
        my $ref=shift; ##PAsar genoma.gen
        my $file=shift;
        my $number2="";

        #print "Buscando el de tag $ref";
        open ORNAMENT, "$file" or die "$!; check your code cant open $file!\n";
        my @svg= <ORNAMENT>;
        close ORNAMENT;


                foreach my $tag(@svg) {
                        if ($tag=~/"<circle style='fill:/ and $tag=~/$ref\|/) {
                                my @elementsL= split/[:;I\|]/, $tag;
                                my $color=$elementsL[1];# print "color $color\n";

                                  if ($color=~/red/) {$number2=1;}
                                                        elsif ($color=~/blue/) {$number2=2;}
                                                       elsif ($color=~/cyan/) {$number2=3;}
                                                        elsif ($color=~/orange/) {$number2=4;}
                                                        elsif ($color=~/black/) {$number2=5;}
                                                        elsif ($color=~/a5bb47/) {$number2=6;}
                                                        #print "OK $tag -- $ref $number2 color $color\n";
                                                            last;
                                                                 }
                                else {
                                                $number2="0";
                                                #print "not OK-- $ref \n";
                                                }
                            }

     return $number2;
 }

			 	
	
	




