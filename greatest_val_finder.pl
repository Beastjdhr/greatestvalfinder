#!/usr/bin/perl

##### libraries
use strict;


#### variables input

print "Please enter your list of numbers separated by commas: ";
my $usrinput= <STDIN>;

################# Main program
my $result= val_lookup($usrinput);
print "The greatest value on your data set is $result  \n";

#### Subrutines
sub val_lookup {
	my $input=shift; ## this is a string with numbers comma separated
				 ## returns tha maximum value
	my @data_set= split(',' , $input);
	use List::Util qw ( max );
	my $greatest_val= max @data_set;
	return $greatest_val; 
	}
