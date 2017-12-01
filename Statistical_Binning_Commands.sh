#!/bin/bash

#Before Statistical Binnig

#FASTA HAVE TO BE ALIGNED

#Within a directory that contains the Phylip files to be used:

#make directories for each phylip based on file name and move/rename files into each directory
for i in *phy; do mkdir Dir$i; mv $i ./Dir$i/Dir$i; done
#Create fasta file within each directory based on the phylip file
for i in *; do (cd $i && NCLconverter -fdnarelaxedphylip *phy -efasta -o$i);done
#Rename fasta file to match phylip file name
for c in *; do (cd $c && for i in *fasta; do mv $i $(echo $i | sed "s/.dna.fasta/.fasta/g");done); done

#RAxML
for d in ./*/ ; do (cd "$d" && raxmlHPC-PTHREADS-AVX -T 8 -f a -# 1000 -m GTRCAT -x 6789 -p 876 -s *.phy -n Final.tre); done



#Create a file with paths to bootstrap trees
ls > Bootstraps.txt
sed -i '' "s|\(.*\)|`pwd`\/\1\/RAxML_bootstrap.Final.tre|g" Bootstraps.txt
sed -i '' 's/.*Bootstraps.txt.*//g' Bootstraps.txt
sed -i '' '/^\s*$/d' Bootstraps.txt

#Move all gene trees for Statistical Binning and delete the file that are not needed
mkdir ../Statistical_Binning
mkdir ../Statistical_Binning/Genes_dir
cp -r * ../Statistical_Binning/Genes_dir/.
cd ../Statistical_Binning/Genes_dir
mv  Bootstraps.txt ../.
for i in *; do (cd $i && rm *reduced* *best* *Branch* *info* *phy *boot*); done
cd ..

#Run Statistical Binning

export BINNING_HOME=/Applications/Statistical_Binning
$BINNING_HOME/makecommands.compatibility.sh Genes_dir 35 Output RAxML_bipartitions.Final.tre
sh commands.compat.35.genes_dir 
cd Output
ls| grep -v ge|sed -e "s/.35$//g" > genes
python $BINNING_HOME/cluster_genetrees.py genes 35
cd ../

$BINNING_HOME/build.supergene.alignments.sh Output Genes_dir Super_Genes_dir 

#Run RAxML to build super-gene-trees

cd Super_Genes_dir/

for d in ./*/ ; do (cd "$d" && raxmlHPC-PTHREADS-AVX -T 8 -f a -# 1000 -m GTRCAT -x 6789 -p 876 -s supergene.fasta -q supergene.part -n Super_Gene_Tree_Final.tre); done

#Run ASTRAL II

#Create a file with each gene tree (bipartitions) for each per line, called it Gene_trees.tre

mkdir ASTRAL
mv Gene_trees.tre ./ASTRAL/.
cd ASTRAL
#Create a file with paths to bootstrap trees
ls  .. > Bootstraps.txt
cd ..
sed -i '' "s|\(.*\)|`pwd`\/\1\/RAxML_bootstrap.Super_Gene_Tree_Final.tre|g" ./ASTRAL/Bootstraps.txt
sed -i '' 's/.*ASTRAL.*//g' ./ASTRAL/Bootstraps.txt
sed -i '' '/^\s*$/d' ./ASTRAL/Bootstraps.txt
cd ASTRAL

#Run ASTRAL
java -jar /Applications/ASTRAL-master/Astral/astral.4.10.8.jar -i Gene_trees.tre -o Astral_Results.txt -b Bootstraps.txt -r 1000