use warnings;
use strict;

my $contexts=`perl listof6s.pl`;

#open FILE, ">>testGetDrawing.txt" or die "$!\n";
#print FILE "this is contexts $contexts end\n";


my $rastFiles= `perl Rast_Final.pl -l 10 -r 10 -c $contexts`;


#print FILE "these are the rast files $rastFiles end\n";


my $BGCFiles= `perl BGC_final.pl -c $contexts`;

#print FILE "these are the BGC files $BGCFiles end\n";

#my $totalList= $rastFiles . "," . $BGCFiles;

#print FILE "this is the total file list $totalList end \n";
#close FILE;

my $totalList=`perl fileCreator.pl`;

`perl 3_Draw.pl 85000 $totalList salida`;
