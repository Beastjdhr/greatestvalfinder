use strict;


my $numero="3";

nested_ifs($numero) ;


################### Subs #########################

sub nested_ifs {
	my $num=shift;

	if ($num==3) {
		print "number equals 3";
	}		
	else { print "number does not equal 3";}
} 
