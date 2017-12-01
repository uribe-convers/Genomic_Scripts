"""
This script will take multiple fasta files and it will delete samples within them
based on a list of names from a second file. It will return a "cleaned" fasta file 
for each of the original files in a new directory.

Simon Uribe-Convers - December 1st, 2017 - http://simonuribe.com

"""
import sys
import os
from Bio import SeqIO
import glob


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage Error, type: python "+sys.argv[0]+" fasta_file_ending (e.g., fasta, fa, aln) list_with_names")
        sys.exit(0)

if os.path.exists("Cleaned_Files"):
    os.system("rm -r Cleaned_Files")
os.mkdir("Cleaned_Files")

file_ending = (sys.argv[1])
file_with_names = open(sys.argv[2], "r")

# Create list of genes to subset with
names_subset = []
for line in file_with_names:
    names = line.strip().split("\t")[0]
    names_subset.append(names)


for filename in glob.glob("*." + file_ending):
    #Read in sequence data
    seqfile = SeqIO.parse(open(filename),'fasta')
    
    # Files to write out
    output = open(filename.split("." + file_ending)[0] + "_cleaned." + file_ending , "w")
    
    # Delete sequence from list from each fasta file
    for seq in seqfile:
        # Split the name so it matches the names to subset
        # This is only necessary if the names in different fasta files have some
        # locus specific identifier, e.g., sp1_gene1, sp1_gene2. Modify the way
        # to split the name according to your naming convention.
        seq_name = str(seq.id.split("_Combined")[0])
        # If the names are all the same in every fasta file, comment the line
        # above and uncomment the line below.
        # seq_name = str(seq.id)
        sequence = str(seq.seq)
        if seq_name not in names_subset:
            output.write(">" + seq_name + "\n" + sequence + "\n")
        #print("Original file has: %d"),
    
    # Output some inforation 
    records = list(SeqIO.parse(filename, "fasta"))
    print("\nWorking on file: %s" %filename)
    print("Sequences in original file: %d" % len(records))
    clean_records = list(SeqIO.parse(filename.split("." + file_ending)[0] + "_cleaned." + file_ending, "fasta"))
    print("Sequences in cleaned file: %d" % len(clean_records))

# Housekeeping

os.system("mv *_cleaned* ./Cleaned_Files")

print("\nFinished, the cleaned files are in the 'Cleaned_Files' directory.\n")
