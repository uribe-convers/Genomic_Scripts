#!/bin/bash

# This script will convert interleaved fasta sequences in a file to non-interleaved sequences.
# It will create a new file. This is a non interactive script and it expects information from the stdin.
# Simon Uribe-Convers, April 26, 2017, www.simonuribe.com

# Usage: 1 = File to be converted, 2 = New file to be created

# Make non-interleaved
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $1 > $2

# Delete leading empty line
sed -i "" '/^$/d' $2
