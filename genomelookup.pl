####libraries
use strict;


####variable declaration
print "Please enter your set of numbers separated by commas: ";
my $input= <STDIN>;


#####main program
my $result= existing_element($input);
print "$result" , "\n";


####subroutines
sub val_lookup {
	my $input=shift; ## this is a string with numbers comma separated
				 ## returns tha maximum value
	my @data_set= split(',' , $input);
	use List::Util qw ( max );
	my $greatest_val= max @data_set;
	return $greatest_val; 
	}



sub existing_element {
         my $input=shift;
         my $greatestvalue=val_lookup($input);
         my $sec= " ";
         my $i=1;
	 my @set= split(',' , $input);
         
         for ($i=1; $i<= $greatestvalue; $i++)
         {if ($i~~@set) {
         $sec=$sec."1";}
         else {
         $sec=$sec."0";}
         };
         return $sec;}
