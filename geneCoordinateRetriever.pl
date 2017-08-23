#!/usr/bin/perl
#Gene coordinate retriever 
#use warnings;
use strict;
use Getopt::Long;

GetOptions(
        'left=i'=> \my $genL,
        'right=i' => \my $genR,
        
) or die "Invalid options passed to $0\n";

my $RastIdFile="/home/jose/InputforCORASON/los17Rast.ids";
my $genomesFile= "/home/jose/greatestvalfinder/genomes.txt";
my %geneandjobid= idshash($RastIdFile);
my %genenumbers= genomeshash($genomesFile);  
my @fileList= fileCreator();
my %inputForSub=existsActinos();
my %switchToGenome= idshash($RastIdFile);
my @usefulArray=genomeFromId();
my %SMASHnumbers= SMASHhash($genomesFile);
my %hasH= reverse %switchToGenome;
my %geneCoordinates= coordRetriever();



#foreach my $inptFile (keys %geneCoordinates) {
#	foreach my $datum (@{$geneCoordinates{$inptFile}}) {
#		open DESTINY, ">>/home/jose/CORASONcoord/$inptFile" or die "$!check your code \n";
#		print DESTINY "$datum\n";
#		close DESTINY;
#				}
#			}
		






##################### SUBS ##############################

sub coordRetriever { my %coordinates;
		    my %actinosGenes= %SMASHnumbers;
			my %oneMoreHash=%hasH;
			open ORNAMENT, "/home/jose/greatestvalfinder/ornament2.1" or die "$!; check your code!\n";
			my @svg= <ORNAMENT>;
			close ORNAMENT;
	foreach my $inputFile(@fileList) {
		my @breakdown= split/[_\.\,]/, $inputFile;
		my $jobId= $breakdown[0];	
		my $gNum= $breakdown[1];# print "gnum $gNum\n";
		my $fle= $jobId . ".txt";
		my $left=$genL;
		my $right=$genR;
		my $pegLeft=$gNum - $left; 
       	        my $pegRight=$gNum + $right; 
       	        my $pegLeftTo= $gNum-1; 
                my $pegRightTo= $gNum + 1;
       	        my @pegL= ($pegLeft .. $pegLeftTo);
                my @pegR= ($pegRightTo .. $pegRight);
           	my @universe;
		my $contig="";
		my $contigL="";
		my $contigR="";
		my $genome= $oneMoreHash{$jobId}; #print "genome $genome\n";
		open FILE, "/home/jose/InputforCORASON/GENOMES/$fle" or die "$!\n";
		my @lines=<FILE>;
		close FILE;
		foreach my $line(@lines) {
			if ($line=~/peg\.$gNum/) {
				my @gData=split/\t/, $line;
				 $contig= $gData[0];
			}
			foreach my $pL(@pegL) {
				if ($line=~/peg\.$pL/) {
					my @pegLData=split/[\t]/, $line;
					$contigL= $pegLData[0];
					my $pegLStartCoord= #$pegLData[4];print "peglstartcoord $pegLStartCoord\n";
					my $pegLEndCoord= $pegLData[5];
					my $pegLSign= $pegLData[6];
					my $pegLNumber=0;
					my $pegLMolecFunction= $pegLData[7];
					my $pegLId= $pegLData[1];
					my $pegLNone= "none";
					my $refL= $genome ."." .  $pL;# print "genome $genome pl $pL refl $refL\n";
								 
				  foreach my $genes(keys %actinosGenes) {
                                                my @group= split/[\t\s]/, $actinosGenes{$genes};
                                                my $function= $group[2];
                                                my @keysGroup= split/\./, $genes;
                                                my $genNUM= $keysGroup[2];
                                #               print "$genNUM gene num actinos and pl $pL\n";
                                                if ($genNUM=~$pL) {
                                                        $pegLNumber=2;
							$pegLNone="";
                                                        $pegLNone= $function;
                                                  #     print "match! $pegLNone \n";
                                                                }
                                                        }
				foreach my $tag(@svg) {
					if ($tag=~/"<circle style='fill:\w/) {
						my @elementsL= split/[:;I\|]/, $tag;
						my $colorL=$elementsL[1];
						my $GenomeGen=$elementsL[4];
						if ($GenomeGen=~/$refL/) {
							 $pegLNumber="";
							
							print "MATCH! color L inside loop $pegLNumber\n";
							if ($colorL=~/red/ {$pegLNumber=1;}
							elsif ($colorL=~/blue/ {$pegLNumber=2;}
							elsif ($colorL=~/cyan/ {$pegLNumber=3;}
							elsif ($colorL=~/orange/ {$pegLNumber=4;}
							elsif ($colorL=~/black/ {$pegLNumber=5;}
							elsif ($colorL=~/1/ {$pegLNumber=6;}
							}
							else { print "no match :(. genomegen $GenomeGen and refl $refL\n";
							}	
								 
									}
						}
				my $pegLFlData= $pegLStartCoord . "\t" . $pegLEndCoord . "\t" . $pegLSign . "\t" . $pegLNumber . "\t" . $pegLMolecFunction . "\t" . $pegLId . "\t" . "0" . "\t" . 				   $pegLNone;
					#		print "colorL outside loop $pegLNumber\n";
					if ($contig eq $contigL) {
						push @universe, $pegLFlData;
					#	print "match!\n";
						}
					} 
				}
			if ($line=~/peg\.$gNum/) {
				my @geneData=split/[\t]/, $line;
				my $startCoord= $geneData[4];# print "$startCoord\n";
				my $endCoord= $geneData[5]; #print "$endCoord\n";
				my $sign= $geneData[6]; #print "$sign\n";
				my $number= 1; 
				my $molecFunction= $geneData[7]; #print "$molecFunction\n";
				my $id= $geneData[1]; 
				my $number2= 0;
				my $number3= 0;
				my $none= "none";
				
				  foreach my $genes(keys %actinosGenes) {
                                                my @group= split/[\t\s]/, $actinosGenes{$genes};
                                                my $functionRef= $group[2];
                                                my @keysGroup= split/\./, $genes;
                                                my $genNUM= $keysGroup[2];
                                #               print "$genNUM gene num actinos and pl $gNum\n";
                                                if ($genNUM=~$gNum) {
                                                        $number=2;
							$none="";
                                                        $none= $functionRef;
                                                #       print "match! $none \n";
                                                                }
                                                        }

				
				my $flData= $startCoord . "\t" . $endCoord . "\t" . $sign . "\t" . $number . "\t" . $molecFunction . "\t" . $id . "\t" . $number2 . "\t" . $none;
				push @universe, $flData;
				}
             		 foreach my $pR(@pegR) {
                       		 if ($line=~/peg\.$pR/) {
                               		 my @pegRData=split/[\t]/, $line;
					 $contigR= $pegRData[0];
                               		 my $pegRStartCoord= $pegRData[4];
                            		 my $pegREndCoord= $pegRData[5];
                              		 my $pegRSign= $pegRData[6];
                              		 my $pegRNumber=0;
                              		 my $pegRMolecFunction= $pegRData[7];
                                  	 my $pegRId= $pegRData[1];
                               		 my $pegRNone= "none";
                               		  foreach my $genes(keys %actinosGenes) {
                                                my @group= split/[\t\s]/, $actinosGenes{$genes};
                                                my $functionR= $group[2];
                                                my @keysGroup= split/\./, $genes;
                                                my $genNUM= $keysGroup[2];
                                #               print "$genNUM gene num actinos and pl $pL\n";
                                                if ($genNUM=~$pR) {
                                                        $pegRNumber=2;
							$pegRNone= "";
                                                        $pegRNone= $functionR;
                                                 #      print "match! $pegRNone\n";
                                                                }
                                                        }

					 my $pegRFlData= $pegRStartCoord . "\t" . $pegREndCoord . "\t" . $pegRSign . "\t" . $pegRNumber . "\t" . $pegRMolecFunction . "\t" . $pegRId . "\t" . "0" . "\t" .                                  $pegRNone;
					 if ($contig eq $contigR) {
						push @universe, $pegRFlData;
						}
                               		 }
                       		 }
	}
		if (! exists $coordinates{$inputFile}) { $coordinates{$inputFile}=(); }
		@{$coordinates{$inputFile}}= @universe;
	      
		 foreach my $iKeys (keys %coordinates) {
			foreach my $element (@{$coordinates{$iKeys}}){
			}
		}

	}	 
    return %coordinates;
}
#this sub creates a hash contaning genome numbers as the keys and rast IDs as the values
sub idshash {
        my %genjob;
	my $file=shift;
	open IDS, "$file" or die "$!\n";
	my @rastIds= <IDS>;
	close IDS;

	foreach my $line (@rastIds) {
		my @info= split/[\t \s]/, $line;
		my $jobId= $info[0];  
		my $genome= $info[1];
		$genjob{$genome}= $jobId;	
	}
  
return %genjob;
}


#_________________________________________________________________________________________________________
#this subroutine creates a hash containing the gene numbers as keys and the genomes as the values 
sub SMASHhash {
	my $genFile= shift;
	open GENOMES, "$genFile" or die "$!\n";
	my @genomes=<GENOMES>;
	close GENOMES;
	my @moreData= @usefulArray;	
	my %genmbrs;
	
	foreach my $datum(@moreData) {
		push @genomes, $datum;
		}
	
	foreach my $line (@genomes) {
		chomp $line;
		if ($line=~/^\d/) {
	#		print "$line\n" ;
			my $smash=`grep $line ActinoSMASH`;
#			print "SIIIII $line $smash\n";
			$genmbrs{$line}=$smash;	
		}
	}	 
	return %genmbrs;
}



#_________________________________________________________________________________________________________
#this subroutine creates a hash containing the gene numbers as keys and the genomes as the values 
sub genomeshash {
	my $genFile= shift;
	open GENOMES, "$genFile" or die "$!\n";
	my @genomes=<GENOMES>;
	close GENOMES;	
	my %genmbrs;
	
	foreach my $line (@genomes) {
		if ($line=~/^\d/) {
			my @dt= split/\./, $line;
			my $genome= $dt[0].".". $dt[1];
			my $gno;
			chomp $genome;
			$gno= $dt[0].".".$dt[1].".".$dt[2];
			chomp $gno;
			$genmbrs{$gno}=$genome;	
		}
	}	 
	return %genmbrs;
}

#this sub creates one file for each gene number consisting of
# rastID_geneNumber.input
sub fileCreator {
        my @files;
	my %genJob= %geneandjobid;
	my %geneNums= %genenumbers;
        foreach my $genum (keys %geneNums) {
                my @components=split( /\./, $genum);
                my $geneNum=$components[2];
                my $genome= $geneNums{$genum};
                my $job_id= $genJob{$genome};
                my $file= $job_id."_".$geneNum.".input";
                push @files, "$file\t";
		open INPTFL, ">> /home/jose/CORASONcoord/$file" or die "$!";
   		close INPTFL;
        }
return @files;
}
#_________________________________________________________________________________________________________________
sub existsActinos {
        my %genNJob;
        foreach my $inputFile(@fileList) {
		my @breakdown= split/[_\.\,]/, $inputFile;
                my $jobId= $breakdown[0];
                my $gNum= $breakdown[1];
                my $fle= $jobId . ".txt";
                my $left=$genL;
                my $right=$genR;
                my $pegLeft=$gNum - $left;
                my $pegRight=$gNum + $right;
                my $pegLeftTo= $gNum-1;
                my $pegRightTo= $gNum + 1;
                my @pegL= ($pegLeft .. $pegLeftTo);
                my @pegR= ($pegRightTo .. $pegRight);

                open FILE, "/home/jose/InputforCORASON/GENOMES/$fle" or die "$!\n";
                my @lines= <FILE>;
                close FILE;
                foreach my $line(@lines) {
                        foreach my $pL(@pegL) {
                                if ($line=~/peg\.$pL/) {
                                        my $gJobL= $jobId ."." . $pL;
                                        $genNJob{$gJobL}= $jobId;
                                        }
                                }
                        foreach my $pR(@pegR) {
                                if ($line=~/peg\.$pR/) {
                                        my $gJobR= $jobId ."." . $pR;
                                        $genNJob{$gJobR}= $jobId;
                                }
                        }
                }
        }
        return %genNJob;
}
#__________________________________________________________________________________________________________________
sub genomeFromId {
	my %idGnum= %inputForSub;
	my %genomeId= %switchToGenome;
	my @readyArr;
	my $newHash;
	my %usefulHash=reverse %genomeId;
	foreach my $jobIdGNum(keys %idGnum) { 
		my @parts= split/\./, $jobIdGNum;
		my $jobId= $parts[0];
		my $geNum=$parts[1];
		my $genome= $usefulHash{$jobId};
		my $genomeGeNum= $genome . "." . $geNum;
		push @readyArr, "$genomeGeNum\t";
	}
return @readyArr;
}
		

