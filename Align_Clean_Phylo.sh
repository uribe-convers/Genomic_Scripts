#!/bin/bash

# This script will align, clean, and analyze multiple fasta files in a single
# directory. It assumes that you have Mafft, Phyutility, and FastTree installed
# and in your path. The first part of the script is meant to be used in a cluster
# where modules have to be loaded, so delete it or comment it out if you are working
# on a single machine. The fasta files, alignments, and trees will be placed in 
# separate directories.

# Simon Uribe-Convers - http://simonuribe.com - June 15th, 2017

# Load modules if running on a cluster

module load mafft
module load phyutility
module load fasttree

# Delete any empty files

find . -size 0 -delete

# Create directories

mkdir Alignments Fasta Phylo

## Align with Mafft, clean with Phyutility, and analyze with FastTree

# Alignment
for i in *.fasta; do \
    # Align
    echo ""
    echo "~~~Aligning with Mafft~~~"
    echo ""
    time mafft --auto --thread 6 --preservecase $i > $i.aln

    # Cleaninig Alignment at 50% occupancy per site
    echo ""
    echo "~~~Cleaninig alignment with Phyutility at at 50% occupancy per site~~~"
    echo ""
    time phyutility -clean 0.5 -in $i".aln" -out $i"_cleaned_05.aln"

    # Phylogenetics
    echo ""
    echo "~~~Building phylogeny with FastTre~~~"
    echo ""
    time FastTree -nt -gtr < $i"_cleaned_05.aln" > $i".tre"

    # House keeping
    mv $i".aln" $i"_cleaned_05.aln" Alignments
    mv $i".tre" Phylo
    mv $i Fasta
done
