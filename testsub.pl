use strict;
sub testsub {
print "Please enter your numbers: ";
my $input= <STDIN>;
my @set= split(',' , $input);
use List::Util qw ( min max );
my $greatest_val= max @set;
 print "The greatest value in your data set is $greatest_val \n";
 } ;
testsub();
