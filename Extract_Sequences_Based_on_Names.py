"""
This script will take a fasta file with many sequences and it will subset it based 
on a list of names from a second file. It will return a second fasta file with
the sequences that were specified.

Simon Uribe-Convers - Nov 29th, 2017 - http://simonuribe.com

"""
import sys
from Bio import SeqIO


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage Error, type: python "+sys.argv[0]+" fasta_file list_with_names final_fasta_subset")
        sys.exit(0)


fasta_sequences = SeqIO.parse(open(sys.argv[1]),'fasta')
name_file = open(sys.argv[2], "r")
final_file = open(sys.argv[3], "w")


# Create list of genes to subset with
names_subset = []
for line in name_file:
    names = line.strip().split("\t")[0]
    names_subset.append(names)

# Read in sequence data
for seq in fasta_sequences:
    if seq.id in names_subset:
        SeqIO.write([seq], final_file, "fasta")
