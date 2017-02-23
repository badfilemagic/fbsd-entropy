#!/usr/bin/env perl
# (C) 2017, W. Dean Freeman, CISSP CSSLP GCIH
# wdfreeman@ieee.org

use strict;
use warnings;
use v5.20;

use Getopt::Long;

my $INFILE = undef;
my $OUTFILE = undef;

GetOptions(	"infile=s"	=> \$INFILE,
		"outfile=s" 	=> \$OUTFILE,
	);


# useage function
sub help {
	say "USAGE: entropyfmt.pl --infile <some text file> --outfile <some data file>";
	say "infile is expected to be dtrace output of known format.  Outifle will be a binary file to feed to NIST 800-90B noniid_main.py tool";
	return 1;
}

sub main {
	# print the help message if the files aren't defined
	if (!defined($INFILE) || !(defined($OUTFILE))) {
		help();
	}
	# open the files
	my ($fh_in, $fh_out);
	open($fh_in, '<', $INFILE)
		or die $!;
	open($fh_out, '>', $OUTFILE)
		or die $!;

	my $byte_count = 0;
	my $expected_total = 0;
	my $capture_bytes = 0;
	my @bytearray;
	while(my $line = <$fh_in>)
	{

		if ($line =~ /:entry (\d+)/) {			# find the fbt entry marker and the amount of entropy bytes in arg0
			$capture_bytes = $1;			# save the regex capture off to our storage place
			$expected_total += $capture_bytes;	# track what we think we got
			$byte_count = 1;			# reset the count of bytes to grab
		}
		elsif ($line =~ /\s+\d+: /) {
			next unless $byte_count <= $capture_bytes;
			my @items = split(/\s/, $line);
			for my $item (@items) {
				next if $item =~ /[:.]/;
				if ($item =~ /([A-Fa-f0-9]{2})/ ) {			# find the hex-alphabet pairs
					next if $byte_count == $capture_bytes;		# stop if we've gotten everything we want from that sample
					push @bytearray, $item; 			# add the element to the byte array
					$byte_count++;					# increase the fetch counter
				}

			}
		}
		
	}
	for my $byte (@bytearray)
	{
		print {$fh_out} pack('C', hex($byte));	# pack the data and write it to a binary file
	}
	# clean up the file handles
	close($fh_in);
	close($fh_out);
}

&main;
