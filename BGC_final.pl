#!/usr/bin/perl
#BGC coordinate retriever
use warnings;
use strict;
use Getopt::Long;

GetOptions( 
'contexts=s' => \my $contexts,
) or die "check getoptions in BGCfinal $0\n";


my $bgcsFile= "MIBiG_prot_seqs_1.3.fasta";
#my $genomesFile= "newgenomes.txt";
my $bgcGenomes= "info.txt";
my $destination= "/LUSTRE/usuario/nselem/DANY/CORASONcoord/salida";

my @CONTEXTS= split/,/, $contexts;

my @BGCs=getBGCs(@CONTEXTS);
my @inputFiles= fileCreator($destination,@BGCs);
my @selectedBGCsGenes=lookForBGCsGenes($bgcsFile,@inputFiles);
my %BGCGenomes= getBGCGenomes($bgcGenomes,@BGCs);
my @finalData= coordRetriever(\@inputFiles,\@selectedBGCsGenes,\%BGCGenomes);

my @FILES= fileCreator($destination,@BGCs);
my $package= join(",",@FILES);
print $package;


my @FINALDATA =sort @finalData;
foreach my $datum (@FINALDATA) {
	my @pTs= split/\*\*\*/, $datum;
	shift @pTs;
	my $newdata= $pTs[0];
	my @pts= split/\.\.\./, $newdata;
	my $destiny= $pts[0];
	my $daTum=$pts[1];
	
	open DESTINY, ">>$destination/$destiny" or die "$! $destination/$destiny not an option\n";
	print DESTINY "$daTum\n";
	close DESTINY;
	}
###########################SUBS#################################################
#This sub creates an array containing the BGC names in your genomes.txt file___
sub getBGCs {
	my @bgcs;
	my @genomes= @_;

	foreach my $genome(@genomes) {
		if ($genome=~/^BGC/) {
			push @bgcs, $genome;
			}
		}
	return @bgcs;
	}
#___________________________________________________________________
#This sub creates the input files in the directory you specify and creates an array wuth such input files__________________________________________________

sub fileCreator {
	my $path=shift;
	my @genomesForFiles= @_;
	my @fileList;
	foreach my $genome (@genomesForFiles) {
	
		chomp $genome;
		$genome=~s/\s*//g;
		my $inputFile= "$genome" . "." . "input";
		push @fileList, $inputFile;
	
		
		open INPUT, ">>$path/$inputFile" or die "$! couldn't create input file $path/$inputFile\n";
		close INPUT;
	}
	return @fileList;
	}

#________________________________________________________________________
#this sub creates an array with the data of the genes of each genome that has an input file_____________________________________
sub lookForBGCsGenes {
	my $file= shift;
	my @list= @_;
	my @matches;
	foreach my $bgc(@list) {
		my @comps= split/[\._]/, $bgc;
		my $genome= $comps[0];
		my $qry= `grep $genome $file`;
		push @matches, $qry;
		}
	return @matches;
	}
#_________________________________________________________________________
#This sub creates a hash containig the genome as the key and the genome info as the value_________________________________________
sub getBGCGenomes {
	my $file=shift;
	my @query=@_;
	my %matches;
	foreach my $gene(@query) {
		chomp $gene;
		my @newgenms=split/_/,$gene;
		my $gen=$newgenms[0];
		my $qry= `grep $gen $file`;
		unless ($qry eq "") {
			$matches{$gen}=$qry;
			}
		}
	return %matches;
	}	
#______________________________________________________________________________
#this sub retrieves the data that each gene needs in order to be written
sub coordRetriever {
	my $InputFiles=shift; #this is an array contining the list of input files;
	my $geneMatches=shift; #this is an array containing all the info of the genes of the specified genomes
	my $genomeMatches=shift; #this is a hash containing the genome as the key and the genome data as the value
	my @DaTA;
	
	foreach my $file (@{$InputFiles}) {
		my $refGen="";
	
		my @compnts= split/[\._]/, $file;
		my $genome=$compnts[0];
		shift @compnts;
		pop @compnts;
		$refGen= join('_', @compnts);
		
		foreach my $geNoMe(keys %{$genomeMatches}) {
			my $num="0";
			
			if ($geNoMe=~$genome) {
				my $data= $genomeMatches->{$geNoMe};
				my @daTa= split/\t/, $data;
				pop @daTa;
				my $org=$daTa[0] . " " . $daTa[1] . " " . $daTa[3];;
				my $none= $daTa[2];
				
				foreach my $gen(@{$geneMatches}) {
					if ($gen=~/$genome/) {
						my @genes= split/>/, $gen;
						foreach my $geNe(@genes) {
							my @data= split/\|/, $geNe;
							my $coords=$data[2];
							my @cooRds= split/-/,$coords;
							my $startCoord=$cooRds[0];
							my $endCoord=$cooRds[1];
							my $id= $data[-1];
							chomp $id; 
							my $molecFunction= $data[5];
							my $sign=$data[3];
							my $number;
							if ($id=~/$refGen/) {$number=1;} else { $number=3;}
							my $fileID= $file;
							my $fileData= $number . "***" . $fileID . "..." . $startCoord . "\t" . $endCoord . "\t" . $sign . "\t" . $number . "\t" . $org . "\t" . $molecFunction . "\t" . $id . "\t" . $num . "\t" . $none;
						unless ($id eq "") 	{push @DaTA, $fileData};					
								}
							}
						}
					}
				}
		}
	return @DaTA;
	}

	
	
