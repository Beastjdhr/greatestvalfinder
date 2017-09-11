#!/usr/bin/perl
#list of 6s
use warnings;
use strict;


open TREE,"4.tree" or die "$!\n";
my @input=<TREE>;
close TREE;

my @context;

foreach my $line (@input) {
	chomp $line;
	if ($line=~/^gi/) {
		my @compnts= split/\|/, $line;
		my $genome= $compnts[1];
		push @context, $genome;
		}
		elsif ($line=~/BGC/) {
		my @list= split/:/, $line;
		my $bgc=$list[0];
		push @context, $bgc;
			}
	}
my $contexts= join(",", @context);
print $contexts;
