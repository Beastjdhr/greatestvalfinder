use warnings;
use strict;

my $input= $ARGV[0];
my $output= $ARGV[1];

open SEQ, $input or die " couldn open file$!\n";
my @input=<SEQ>;
close SEQ;

my @hashkeys;

my %IDS;

foreach my $line(@input) {
	 my @data= split('\t' , $line);
	 my $id= $data[0];
	if(!exists $IDS{$id}) { $IDS{$id} = (); }
	@{$IDS{$id}}=@data;
	#push(@data,@{$IDS{$id}});
	}


foreach  my $key (keys %IDS){
	print "key $key \n";
	foreach my $element (@{$IDS{$key}}){
		print "$element\n";
		}

print "###############3\n";
}
