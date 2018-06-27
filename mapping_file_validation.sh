#!/bin/bash

# This script will validate that the barcodes and sample names are unique in a mapping file. 
# Usage: ./mapping_file_validation.sh mapping_file.tsv

BARCODES=$(cat $1 | cut -f 1 | uniq -c | cut -d " " -f 4 | uniq)
SAMPLES=$(cat $1 | cut -f 2 | uniq -c | cut -d " " -f 4 | uniq)
if [[ $BARCODES == 1 && $SAMPLES == 1 ]]; then
    printf "\n-------------------------------------------------------
    All good! Barcodes and sample names are unique\n-------------------------------------------------------\n"
    
elif [[ $BARCODES > 1 ]]; then
    printf "\n------------------------------------
    STOP! Barcodes are repeated\n------------------------------------\n"
elif [[ $SAMPLES > 1 ]]; then
    printf "\n----------------------------------------
    STOP! Sample names are repeated\n----------------------------------------\n"
fi