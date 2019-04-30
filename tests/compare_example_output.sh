#!/bin/bash
# Compare the SCINGE_Example.m output with the reference output
# This script must be called from the directory that contains SCINGE_Example.m
# Must have already run SCINGE_Example.m using the default output directory
# Must run inside the conda environment specified by environment.yml or have
# those Python packages available

echo Comparing SCINGE_Gene_Influence.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Gene_Name Output/SCINGE_Gene_Influence.txt tests/reference/SCINGE_Gene_Influence.txt
cat csvdiff.out
comparison=$(cat csvdiff.out)
rm csvdiff.out
if [[ "$comparison" != 'files are identical' ]] ; then
  exit 1
fi

# csvdiff requires a unique key in each row
# Provide the Regulator and Target columns together as the index
echo Comparing SCINGE_Ranked_Edge_List.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Regulator,Target Output/SCINGE_Ranked_Edge_List.txt tests/reference/SCINGE_Ranked_Edge_List.txt
cat csvdiff.out
comparison=$(cat csvdiff.out)
rm csvdiff.out
if [[ "$comparison" != 'files are identical' ]] ; then
  exit 1
fi
