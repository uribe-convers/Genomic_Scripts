"""
This script will calculate the length of each fasta sequence in a multifasta file

Simon Uribe-Convers - May 31th, 2016 - http://simonuribe.combine
"""

from Bio import SeqIO
import sys

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage Error, type: python " + sys.argv[0] + " fasta_file"
        sys.exit(0)

filename = sys.argv[1]
for seq_record in SeqIO.parse(filename, "fasta"):
    output_line = "%s \t %d" % (seq_record.id, len(seq_record))
    print(output_line)
