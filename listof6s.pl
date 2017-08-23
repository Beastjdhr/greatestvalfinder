#!/usr/bin/perl
#list of 6s
use warnings;
use strict;


open TREE,"tree.svg.new" or die "$!\n";
my @input=<TREE>;
close TREE;



foreach my $line (@input) {
	chomp $line;
	if ($line=~/title/) {
		if ($line=~/BGC/)
			{
			my @set= split/[>\s]/, $line;		
			open OUT, ">>list.txt" or die "$!";
			print OUT "$set[1] \n";
		}
		elsif ($line=~/\./) {
		my @list= split/[>|]/, $line;
		open OUT, ">>list.txt" or die "$!";
		print OUT "$list[1]\n";
			}
		close OUT;

		
		
	}
}
