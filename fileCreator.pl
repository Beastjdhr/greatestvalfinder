use warnings;
use strict;

open TREE, "3.tree" or die "$!\n";
my @lines=<TREE>;
close TREE;


my @files;

foreach my $line (@lines) {
	chomp $line;
	if ($line=~/^gi/) {
		my @comps= split/\|/,$line;
		my $genomeGen= $comps[1];
		my @pts= split/\./,$genomeGen;
		my $genome= $pts[0] . "." . $pts[1];
		my $gNum= $pts[2];
		my $match= `grep $genome Actinos.ids`;
		my @parts= split/\t/,$match;
		my $jobId= $parts[0];
		my $file= $jobId . "_" . $gNum . ".input";
		push @files, $file;
		}
	elsif ($line=~/BGC/) {
		my @bd=split/:/, $line;
		my $BGCGen= $bd[0];
		my $bFile= $BGCGen . ".input";
		push @files, $bFile;
		}
	}
my $fileList=join(",", @files);
print $fileList;
		
