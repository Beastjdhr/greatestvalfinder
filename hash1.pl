use strict;
my %hash;
my %who;
%hash= (
Gary=> "Dallas",
Lucy=> "Exeter",
Ian=> "Reading",
Samantha=> "Oregon"
);
%who= reverse %hash;
print "Gary lives in ", $hash{Gary}, "\n";
print "Ian lives in ", $hash{Ian}, "\n";
print "$who{Exeter} lives in Exeter\n";
print "$who{Oregon} lives in Oregon\n";

