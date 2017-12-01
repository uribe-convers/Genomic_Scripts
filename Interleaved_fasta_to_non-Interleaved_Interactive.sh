#!/bin/bash

# This script will convert interleaved fasta sequences in a file to non-interleaved sequences.
# It will create a new file.
# Simon Uribe-Convers, April 26, 2017, www.simonuribe.com

echo "Enter the name of the interleaved file you want to convert"
read file_in

echo "Enter the name of the new non-interleaved file you want to create"
read file_out

# Make non-interleaved
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $file_in > $file_out

# Delete leading empty line
sed -i "" '/^$/d' $file_out
