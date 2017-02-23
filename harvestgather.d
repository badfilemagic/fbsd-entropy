#!/usr/sbin/dtrace -s
/* (C) 2017, W. Dean Freeman CISSP CSSLP GCIH
 * wdfreeman@ieee.org
 */

/* this pulls a hex dump of the contents of arg0 up to 136 bytes
 * because that is the highest size value that I've seen in manual testing.
 * Environmental entropy sources get pushed into random_harvest_queue().
 */
fbt::random_harvest_queue:entry {
	printf("%d", arg1);
	tracemem(arg0, 136);
}

/* On my Xeon system, RDRAND pushes 8 bytes into random_harvest_direct() when it gets invoked
 * via random_harvest_feed().  We get a hexdump of 8 bytes out of it.
 */
fbt::random_harvest_direct:entry {
	printf("%d", arg1);
	tracemem(arg0, 8);
}

/* I haven't seen anything come in from here yet, but we'll leave it in for now anywawy. */ 
fbt::random_harvest_fast:entry {
	printf("%d", arg1);
	tracemem(arg0, 136);
}
