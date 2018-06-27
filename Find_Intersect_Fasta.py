"""
This script will return the intersect of two fasta files.

Simon Uribe-Convers - December 1st, 2017 - http://simonuribe.comma
"""

import sys
from Bio import SeqIO

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage Error, type: python "+sys.argv[0]+" fasta_file_1 fasta_file_2 results_file")
        sys.exit(0)

file1 = SeqIO.parse(open(sys.argv[1]),'fasta')
file2 = SeqIO.parse(open(sys.argv[2]), 'fasta')
outfile = open(sys.argv[3], "w")

# Create lists with the names only
names1 = []
for seq in file1:
    names1.append(seq.id)

names2 = []
for seq in file2:
    names2.append(seq.id)

# Find intersect
intersect = list(set(names1) & set(names2))

out = "\r".join(intersect)
outfile.write(out)
