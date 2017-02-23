(C) 2017, W. Dean Freeman, CISSP CSSLP GCIH
	  Mailto: wdfreeman@ieee.org
	  PGP/GPG Key: B2EC597C

Package Contents:
	* totalgather.d -> a DTrace script that fetchs out hex dumps of the value of
	  the entropy blob pushed into the Yarrow/Fortuna randomdev_hash_iterate(9)
	  functions in FreeBSD 11's /dev/random implementation.

	* harvestgather.d -> a DTrace script that fetches out hex dumps of the value
	  of entropy blobs pushed into the random_harvest_*(9) functions in FreeBSD
	  11's /dev/random implementation

	* entropyfmt.pl -> a Perl script which parses out the relevant bytes of hex 
	  from the output of entropygather.d and then writes a file that can be fed 
	  into NIST'S SP800-90B entropy estimation tool.

How to use it:
1) Make sure that you have the DTrace kernel module and all of the providers loaded:
	# kldload dtraceall

2) Run the D script and pipe the output to some file:
	# ./totalgather.d > entropy.txt

3) After allowing the script to gather a sufficient number of samples (run it for a 
   couple of minutes), run the Perl script to convert the text file into a blob of 
   the sampled entropy:
	# ./entropyfmt.pl --input entropy.txt --output entropy.dat

4) Obtain the NIST SP800-90B entropy assessment tool from their Github and follow the
   posted instructions.

