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
	say "infile is expected to in format from kernel message buffer.  Outfile will be a binary file to feed to NIST 800-90B noniid_main.py tool";
	return 1;
}

sub main {
	# print the help message if the files aren't defined
	if (!defined($INFILE) || !(defined($OUTFILE))) {
		help();
	}
	# open the files
	open(my $fh_in, '<', $INFILE)
		or die $!;
	open(my $fh_out, '>', $OUTFILE)
		or die $!;

	my @bytearray;
	while(<$fh_in>)
	{
		chomp;
		my @bytes = split(/\s+/,$_);
		for my $byte (@bytes)
		{
			if ($byte !~ /]/)
			{
				push @bytearray, $byte;
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
