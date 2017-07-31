#!/usr/bin/perl

use strict;


print "Enter your set of values separated by commas: ";
my $values= <STDIN>;

my $result= maxval($values);
print "$result";


sub maxval {
	my $numbers= shift;
	my @numberarr= split (',' , $numbers);
	my $maxval=0;
	foreach my $number(@numberarr) {
	if ($number>$maxval) {$maxval=$number;} }
	return $maxval;}


	
