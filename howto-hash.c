Replace the hash.c in sys/dev/random

Will dump bytes to kernel message buffer/syslog

grep Entropy /var/log/messages | awk -F'[' '{print $2}' | awk -F']' '{print $1}' > somefile
bzgrep Entropy /var/log/messages.0.bz2 ...
