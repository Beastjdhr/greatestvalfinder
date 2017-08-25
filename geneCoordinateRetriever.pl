#!/usr/bin/perl
#Gene coordinate retriever 
use warnings;
use strict;
use Getopt::Long;

GetOptions(
        'left=i'=> \my $genL,
        'right=i' => \my $genR,
        
) or die "Invalid options passed to $0\n";

my $outputdir="/home/jose/CORASONcoord";
my $inputdir="/home/jose/greatestvalfinder";
my $RastIdFile="$inputdir/los17Rast.ids";
my $genomesFile= "$inputdir/Pocos.txt";
my $ornament="$inputdir/ornament2.1";

my %geneandjobid= idshash($RastIdFile); ## lee job ids transforma id genoma jobid 
#foreach my $gen (keys %geneandjobid){	print "$gen --- $geneandjobid{$gen} \n ";}
#print "enter to contnue \n"; my $pause = <STDIN>;

my %genenumbers= genomeshash($genomesFile); ##FOr each gene cuts last number and get the genome number 
#foreach my $gen (keys %genenumbers){	print "$gen --- $genenumbers{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;

my @fileList= fileCreator(\%geneandjobid,\%genenumbers,$outputdir); ## creates an array with the names of the .input files 
#	foreach my $gen (@fileList){print "$gen \n ";}print "enter to contnue \n";my $pause = <STDIN>;

my %inputForSub=existsActinos($genL,$genR, $inputdir, @fileList); ##REads txt
#foreach my $gen (keys %inputForSub){	print "$gen --- $inputForSub{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;

my  %switchToGenome= idshash($RastIdFile); ##gets job id from genome.id
#foreach my $gen (keys %switchToGenome){	print "$gen --- $switchToGenome{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;

my %hasH= reverse %switchToGenome; ## get genome id from jobid
#foreach my $gen (keys %hasH){	print "reverso $gen --- $hasH{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;

my @usefulArray=genomeFromId(\%inputForSub,\%switchToGenome); ## Gives all genes  that must on cluster by each genome (genome.gene) 
## DANYARREGLALO sin variables globales y pasa por referencia basate en el fileList
#foreach my $gen (@usefulArray){	print "$gen \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;

my %SMASHnumbers= SMASHhash($genomesFile,@usefulArray);
#foreach my $gen (keys %SMASHnumbers){	print "$gen --- $SMASHnumbers{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;


my %geneCoordinates= coordRetriever(\%SMASHnumbers,\%hasH,$ornament,$genL,$genR,@fileList);
#foreach my $gen (sort keys %geneCoordinates){print "$gen --- $geneCoordinates{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;

#my %centralCoords= centralGenes();
#foreach my $gen (sort keys %centralCoords){print "$gen --- $centralCoords{$gen} \n ";}print "enter to contnue \n";my $pause = <STDIN>;
#exit;

#my %geneData= (%geneCoordinates, %centralCoords);
#my @leftArr= leftGenes();


foreach my $inptSource (keys %geneCoordinates) {
	my @prts= split/\./, $inptSource;
	my $fileID= $prts[0];
	my $destinyFile= $fileID ."." . "input"; 
	open DESTINY, ">>/home/jose/CORASONcoord/$destinyFile" or die "$!check your code \n";
		print DESTINY "$geneCoordinates{$inptSource}\n";
		close DESTINY;
				
			}
	
		






##################### SUBS ##############################

sub coordRetriever { 

	my %coordinates;
	my $actinosGenes= shift;
	my $oneMoreHash=shift;
	my $inputfile=shift;
	my $left=shift;
	my $right=shift;
	my @fileList=@_;
	
	open ORNAMENT, "$inputfile" or die "$!; check your code!\n";
	my @svg= <ORNAMENT>;
	close ORNAMENT;


	foreach my $inputFile(@fileList) {
		my @breakdown= split/[_\.\,]/, $inputFile;
		my $jobId= $breakdown[0];	
		my $gNum= $breakdown[1];# print "gnum $gNum\n";
		my $fle= $jobId . ".txt";
		my $minimo=$gNum -$left;
       	        my $maximo=$gNum + $right;
       	        my @pegR= ($minimo .. $maximo);
		my $contig="";
		my $contigLR="";
		my $genome= $oneMoreHash->{$jobId}; #print "genome $genome\n";
		my $central=$genome.".".$gNum;
		#print " central $central\n";
		my $pegLStartCoord="";# $pegLData[4];#print "peglstartcoord $pegLStartCoord\n";
		my $pegLEndCoord="";# $pegLData[5];
		my $pegLSign= "";#$pegLData[6];
		my $pegLNumber="";#0;
		my $pegLMolecFunction="";# $pegLData[7];
		my $pegLId= "";#$pegLData[1];
		my $pegLNone= "";#"none";
		my $refL="";# $genome ."." .  $pL;# print "genome $genome pl $pL refl $refL\n";
		my $dataID= "";#$jobId . "_" . $gNum . "." . $pL;			

		open FILE, "/home/jose/InputforCORASON/GENOMES/$fle" or die "$!\n";
		my @lines=<FILE>;
		close FILE;

		foreach my $line(@lines) { ## obtengo el contig del gen central
			if ($line=~/peg\.$gNum\t/) {
			my @gData=split/\t/, $line;
			 $contig= $gData[0];
			#print "contig central $contig\n";
				}
			}


		foreach my $pL(@pegR) {
			#print "$pL a ver \n";
			#print "Enter to continue \n";
			#my $pause=<STDIN>;

			foreach my $line(@lines) { ## obtengo el contig del gen central

				if ($line =~/peg\.$pL\t/ ) {
		#			print "line found \n";
		#			print "$line\n";
					my @pegLData=split/[\t]/, $line;
					$contigLR= $pegLData[0];
					 $pegLStartCoord= $pegLData[4];#print "peglstartcoord $pegLStartCoord\n";
					 $pegLEndCoord= $pegLData[5];
					 $pegLSign= $pegLData[6];
					 $pegLNumber=0;
					 $pegLMolecFunction= $pegLData[7];
					 $pegLId= $pegLData[1];
					 $pegLNone= "none";
					 $refL= $genome ."." .  $pL;# print "genome $genome pl $pL refl $refL\n";
					 $dataID= $jobId . "_" . $gNum . "." . $pL;			

					##Funciona para antiSMASH 
				  foreach my $genes(keys %{$actinosGenes}) {
                                                my @group= split/[\t\s]/, $actinosGenes->{$genes};
						my $function;
						if($group[2]){
                                                	$function= $group[2];
							}
						else{$function="none";}


                                                my @keysGroup= split/\./, $genes;
                                                my $genNUM= $keysGroup[2];

					#	print " $pL gen $genNUM debug2 $pegLNone \n";
					#	my $pause3=<STDIN>;
	
                                #               print "$genNUM gene num actinos and pl $pL\n";
                                                if ($genNUM == $pL) {
                                                        $pegLNumber=7;
                                                        $pegLNone= $function;

						#	print " $pL debug function $pegLNone \n";
						#	my $pause4=<STDIN>;	
							last;
                                                                }
						}

                                                   
	      	
		}else{
			#	print "line not found \n";
			}

		}
	
					#		print "colorL outside loop $pegLNumber\n";\
					my $color2=0;

					if ($gNum == $pL) {
							#print "CENTRAL $pL = $gNum \n";
							$pegLNumber=1;
						$color2=centralGenes($central,$inputfile);
						open DESTINY, ">>/home/jose/CORASONcoord/$jobId\_$gNum\.input" or die "$!check your code \n";
						print DESTINY $pegLStartCoord . "\t" . $pegLEndCoord . "\t" . $pegLSign . "\t" . $pegLNumber . "\t" ."org"."\t". $pegLMolecFunction . "\t" . $pegLId . "\t" . $color2 . "\t" . $pegLNone."\n";
						close DESTINY;
								}
					my $pegLFlData= $pegLStartCoord . "\t" . $pegLEndCoord . "\t" . $pegLSign . "\t" . $pegLNumber . "\t" ."org"."\t". $pegLMolecFunction . "\t" . $pegLId . "\t" . $color2 . "\t" . $pegLNone;

					if ($contig eq $contigLR) {
					#	print "same $contig --- $contigLR\n";
					#	print "match!\n";
						 $coordinates{$dataID}=$pegLFlData; 
						}
					else {
						#print "not same $contig --- $contigLR\n";
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
	my @moreData= @_;
	
	open GENOMES, "$genFile" or die "$!\n";
	my @genomes=<GENOMES>;
	close GENOMES;
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
			if($smash eq ""){
				$genmbrs{$line}="none";	
			}	
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
	my $RefgenJob= shift;
	my $RefgeneNums= shift;
 	my $outdir=shift;

        foreach my $genum (keys %{$RefgeneNums}) {
                my @components=split( /\./, $genum);
                my $geneNum=$components[2];
                my $genome= $RefgeneNums->{$genum};
                my $job_id= $RefgenJob->{$genome};
                my $file= $job_id."_".$geneNum.".input";
                push @files, "$file\t";
		open INPTFL, ">> $outdir/$file" or die "$!";
   		close INPTFL;
        }
return @files;
}
#_________________________________________________________________________________________________________________
sub existsActinos {
        my %genNJob;
	my $left=shift;
	my $right=shift;
	my $inputdir=shift;
	my @fileList=@_;

        foreach my $inputFile(@fileList) {
	#	print "$inputFile \n";
		my @breakdown= split/[_\.\,]/, $inputFile;
                my $jobId= $breakdown[0];
                my $gNum= $breakdown[1];
                my $fle= $jobId . ".txt";
                my $minimo=$gNum - $left;
                my $maximo=$gNum + $right;
                my @pegLR= ($minimo .. $maximo);

                open FILE, "$inputdir/GENOMES/$fle" or die "$! couldn open $fle\n";
		#print "$fle has been opened\n";
                my @lines= <FILE>;
                close FILE;
                foreach my $pL(@pegLR) {
			#print " file $fle numero $pL\n";
                	foreach my $line(@lines) {
                                if ($line=~/peg\.$pL\t/) {
                                        my $gJobL= $jobId ."." . $pL;
                                        $genNJob{$gJobL}= $jobId;
                                        }
				else {
					#print " $fle $pL not found\n";
					}
                                }
                        }
        }
        return %genNJob;
}
#__________________________________________________________________________________________________________________
sub genomeFromId {
	my $idGnum= shift;
	my $genomeId= shift;

	my @readyArr;
	my $newHash;
	
	
	my %usefulHash=reverse %{$genomeId};
	foreach my $jobIdGNum(keys %{$idGnum}) {
		#print "$jobIdGNum dentro \n"; 
		my @parts= split/\./, $jobIdGNum;
		my $jobId= $parts[0];
		my $geNum=$parts[1];
		my $genome= $usefulHash{$jobId};
		my $genomeGeNum= $genome . "." . $geNum;
		push @readyArr, "$genomeGeNum\t";
	}
return @readyArr;
}
		
#______________________________________________________________________________________________________________________________
sub centralGenes {
        my %centralCoordinates;
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

#_____________________________________________________________________________

sub leftGenes { my @coordinates;
                    my %actinosGenes= %SMASHnumbers;
                        my %oneMoreHash=%hasH;
        foreach my $inputFile(@fileList) {
                my @breakdown= split/[_\.\,]/, $inputFile;
                my $jobId= $breakdown[0];
                my $gNum= $breakdown[1];# print "gnum $gNum\n";
                my $fle= $jobId . ".txt";
                my $left=$genL;
		my $lefTo= $gNum - 1;
		my $minVal= $gNum - $left-1;
                my @pegL= ($minVal .. $lefTo);print "pegL @pegL\n";
                my $contig="";
                my $contigLR="";
                my $genome= $oneMoreHash{$jobId};
                open FILE, "/home/jose/InputforCORASON/GENOMES/$fle" or die "$!\n";
                my @lines=<FILE>;
                close FILE;
                foreach my $line(@lines) {
                        if ($line=~/peg\.$gNum/) {
                                my @gData=split/\t/, $line;
                                 $contig= $gData[0];
                        }
                        foreach my $pL(@pegL) {
                                if ($line =~/peg\.$pL/) {
                                        my @pegLData=split/[\t]/, $line;
                                        $contigLR= $pegLData[0];
                                        my $pegLStartCoord= $pegLData[4];#print "peglstartcoord $pegLStartCoord\n";
                                        my $pegLEndCoord= $pegLData[5];
                                        my $pegLSign= $pegLData[6];
                                        my $pegLNumber=0;
                                        my $pegLMolecFunction= $pegLData[7];
                                        my $pegLId= $pegLData[1];
                                        my $pegLNone= "none";
                                        my $refL= $genome ."." .  $pL;# print "genome $genome pl $pL refl $refL\n";
                                        my $dataID= $jobId . "_" . $gNum . "." . "input" ;
                                  foreach my $genes(keys %actinosGenes) {
                                                my @group= split/[\t\s]/, $actinosGenes{$genes};
                                                my $function;
                                                if($group[2]){
                                                        $function= $group[2];
                                                        }
                                                else{$function="none";}
                                                my @keysGroup= split/\./, $genes;
                                                my $genNUM= $keysGroup[2];

           				 if ($genNUM == $pL) {
                                                        $pegLNumber=7;
                                                        $pegLNone= $function;
                                                        last;
                                                                }
                                                }
                                                   
                                my $pegLFlData= $pegLStartCoord . "\t" . $pegLEndCoord . "\t" . $pegLSign . "\t" . $pegLNumber . "\t" ."org"."\t". $pegLMolecFunction . "\t" . $pegLId . "\t" . "0" . "\t" .                               $pegLNone . "\t" ."..." . $dataID ;
                                        if ($contig eq $contigLR) {
                                                 push @coordinates, $pegLFlData;
                                                }
#                                                       }
                }
    
                }
        }    
        }
    return @coordinates;
}                                                        
