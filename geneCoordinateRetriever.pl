#!/usr/bin/perl
#Gene coordinate retriever 
use warnings;
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
my %SMASHnumbers= SMASHhash($genomesFile); 
my @fileList= fileCreator(%geneandjobid, %genenumbers);
my %geneCoordinates= coordRetriever();


foreach my $inptFile (keys %geneCoordinates) {
	foreach my $datum (@{$geneCoordinates{$inptFile}}) {
		open DESTINY, ">>/home/jose/CORASONcoord/$inptFile" or die "$!check your code \n";
		print DESTINY "$datum\n";
		close DESTINY;
				}
			}
		






##################### SUBS ##############################

sub coordRetriever {
#	open ACTINOSMASH, "/home/jose/greatestvalfinder/smashchico" or die "$!\n";
#	my @actinos=<ACTINOSMASH>;
#	close ACTINOSMASH;
	my %coordinates;
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
           	my @universe;
		my $contig="";
		my $contigL="";
		my $contigR="";
		my @actinosCheck;	
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
					my $pegLStartCoord= $pegLData[4];
					my $pegLEndCoord= $pegLData[5];
					my $pegLSign= $pegLData[6];
					my $pegLNumber=0;
					my $pegLMolecFunction= $pegLData[7];
					my $pegLId= $pegLData[1];
					my $pegLNone= "none";
					my $checkActinos= $jobId . "." . $pL;
					#foreach my $actinoSmash(@actinos) {
		#			my $smash=`grep $checkActinos ActinoSMASH`;
		#			print "SIIIII $checkActinos $smash\n";
						my @ACTNS= split/\t/, $line;
						my $jbID= $ACTNS[0];
						my $gene= $ACTNS[1];
						my $function= $ACTNS[2];
						my @genes= split/\./, $gene;
						my $geneNm= $genes[2];
						my $match= $jbID . "." . $geneNm;
						if ($match =~ /$checkActinos/) {
							print "There has been a match\n";
							$pegLNumber=2;
							$pegLNone= $function;
								} 
					# }							 
					my $pegLFlData= $pegLStartCoord . "\t" . $pegLEndCoord . "\t" . $pegLSign . "\t" . $pegLNumber . "\t" . $pegLMolecFunction . "\t" . $pegLId . "\t" . $pegLNumber . "\t" . 				   $pegLNone;
					if ($contig eq $contigL) {
						push @universe, $pegLFlData;
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
                               		 my $pegRFlData= $pegRStartCoord . "\t" . $pegREndCoord . "\t" . $pegRSign . "\t" . $pegRNumber . "\t" . $pegRMolecFunction . "\t" . $pegRId . "\t" . $pegRNumber . "\t" .                                  $pegRNone;
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
	my %genmbrs;
	
	foreach my $line (@genomes) {
		chomp $line;
		if ($line=~/^\d/) {
			print "$line\n" ;
			my $smash=`grep $line ActinoSMASH`;
			print "SIIIII $line $smash\n";
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
                push @files, $file . ",";
		open INPTFL, ">> /home/jose/CORASONcoord/$file" or die "$!";
   		close INPTFL;
        }
return @files;
}

