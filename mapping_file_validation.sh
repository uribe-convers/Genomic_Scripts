#!/bin/bash

# This script will validate that the indices and sample names are unique in a mapping file. 
# Usage: ./mapping_file_validation.sh mapping_file.tsv

# Delete any empty lines if there are any
cat $1 | sed '/^\s*$/d' > tmp
mv tmp $1

# Check that the indices and sample names are unique
INDICES=$(cat $1 | cut -f 1 | uniq -c | cut -d " " -f 4 | uniq)
SAMPLES=$(cat $1 | cut -f 2 | uniq -c | cut -d " " -f 4 | uniq)
if [[ $INDICES == 1 && $SAMPLES == 1 ]]; then
    printf "\n-------------------------------------------------------
    All good! Indices and sample names are unique\n-------------------------------------------------------\n"
    
elif [[ $INDICES > 1 ]]; then
    printf "\n------------------------------------
    STOP! Indices are repeated\n------------------------------------\n"
elif [[ $SAMPLES > 1 ]]; then
    printf "\n----------------------------------------
    STOP! Sample names are repeated\n----------------------------------------\n"
fi
