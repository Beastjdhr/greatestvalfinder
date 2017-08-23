use warnings;
use strict;

my $input= $ARGV[0];
my $output= $ARGV[1];
my %IDS;



open CYANOS, $input or die " couldnt open file$!\n";
my @input=<CYANOS>;
close CYANOS;



foreach my $line(@input) {
	 my @data= split('\t' , $line);
	 my $id= $data[0];
	if(!exists $IDS{$id}) { $IDS{$id} = (); }
	@{$IDS{$id}}=@data;

	}


open TAGS,"> $output" or die "$!\n";

foreach  my $key (keys %IDS){
	my $cs= int($IDS{$key}[5])/10;
	print TAGS "<name bgStyle= \"$IDS{$key}[7]\"> $IDS{$key}[3] $IDS{$key}[0] </name> \n",
		"<chart>\n",
		"<content> $IDS{$key}[6]</content>\n",
		"</chart>\n",
		"<annotation>\n",
		"<desc> Size: GC: $IDS{$key}[13] </desc>\n",
		"</annotation>\n";

		
		}
close TAGS;

print "The results were saved in $output/n.";

