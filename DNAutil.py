#!/usr/bin/python

"""
The module DNAutil contains several useful functions to work with DNA strings

"""

def GC_content(dna):
    
    """
    (str) -> int
    Returns the GC content percentage of a DNA string
    >>>gc("aaaaaaaagC")
    >>>20.0
    """
    dna = dna.upper()
    C = dna.count("C")
    G = dna.count("G")
    nbases = dna.count("N") # to account for unknown bases and remove them
    GC_percent = ((C + G) / (len(dna) - nbases)) * 100
    return GC_percent


def stop_codon(dna, frame=0):
    """
    This function checks if a string of DNA has an in-frame stop codon
    """
    stop_codon_found = False
    stop_codons = ("TAG", "TAA", "TGA")
    for i in range(frame, len(dna), 3):
        codon = dna[i:i+3].upper() # Starts at zero and slices until (but not included) position 3. Upper in case the sequence is in lower
        if codon in stop_codons:
            stop_codon_found = True
            print("DNA sequence has an internal stop codon starting in position %d" %(i + 1))
            break

def reverse_string(seq):
    return seq[::-1]

def complement(dna):
    """
    Returns the reverse of the dna string
    """
    # Build a dictionary
    basecomplement = {"A" : "T", "C" : "G", "G" : "C", "T" : "A", "N" : "N",
     "a" : "t", "c" : "g", "g" : "c", "t" : "a", "n" : "n"}
    letters = list(dna) # converts the string into a list
    
    letters = [basecomplement[base] for base in letters] # this performs the operation `basecomplement` on each item (`base`) of the list `letters`
    
    return "".join(letters) #joins the items of the list `letters` using the method `join` that is available for strings. The separator is empty so the letters will be together.

def reverse_complement(seq):
    """
    Returns the reverse complement of the dna string
    """
    seq = reverse_string(seq)
    seq = complement(seq)
    return seq
