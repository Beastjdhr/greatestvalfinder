#!/usr/bin/perl
#sequence_converter.pl

use strict;
use warnings;
use Getopt::Long;
######GetOpt
GetOptions(
	'input=s' => \my $inputfile,
	'output=s' => \my $outputfile,
	'verbose' => \my $verbose,
	'length=i'=> \my $length,	
) or die "Invalid options passed to $0\n";

my $sequences= $inputfile;
my $convertedseqs= $outputfile;

if ($length<500) {
	die  "Sequence has to be longer than 500 characters."
	} 
open SEQ, $sequences or die "$!\n";
my @input=<SEQ>;
close SEQ;

print "The sequence conversion was succesful.\n";


 if ($verbose)  {
	foreach my $seq(@input)  {
		my $converted_sequence= existing_element($seq);
		print "$seq was converted to $converted_sequence\n"; sleep 1;
		}
	}


my @transformados=transform(@input);
printFile($convertedseqs,@transformados);







###############################################subs
sub printFile{
	my $convertedseqs=shift;
	my @tran=@_;

	open CONV, ">$convertedseqs" or die "$!\n";
 
	foreach  my $seq(@tran)  {
		print CONV "$seq \n";
		}

	close CONV;

}
print "The results have been saved in the file you specified as the destination: $convertedseqs\n";



sub transform{  
	my @input=@_;
	my @transformed;
	global_max(@input);
 	foreach my $seq(@input)  {

         	
         	existing_element($seq);
         	my $converted_sequence= existing_element($seq);
		push @transformed, $converted_sequence;
	 
		}
	return @transformed;
	}
        

sub global_max{
        my @input=@_;
	my @max_values;
	foreach my $sequence(@input) {
		chomp $sequence ;
		my @data= split(',' , $sequence);
		use List::Util qw ( max );
		my $localmax= max @data;
		push (@max_values,$localmax);
		}
	my $global_max;
	$global_max= max @max_values;

	return $global_max;
	}	





sub existing_element {
         my $input=shift;
         my $gmax=global_max(@input);
         my $sec= "";
         my @set= split(',' , $input);

         for (my $i=1; $i<= $gmax; $i++){
                if ($i~~@set) {
                        $sec=$sec."1";
                        }
                else {
                        $sec=$sec."0";
                        }
                };
         return $sec;
        }



