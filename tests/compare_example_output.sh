#!/bin/bash
# Compare the SCINGE_Example.m output with the reference output
# This script must be called from the directory that contains SCINGE_Example.m
# Must have already run SCINGE_Example.m using the default output directory
# Must run inside the conda environment specified by environment.yml or have
# those Python packages available

outdir=Output
refdir=tests/reference

# Return 0 unless any individual test fails
# Continue running all tests even if one fails
exit_status=0

echo Comparing SCINGE_Gene_Influence.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Gene_Name $outdir/SCINGE_Gene_Influence.txt $refdir/SCINGE_Gene_Influence.txt
cat csvdiff.out
comparison=$(cat csvdiff.out)
rm csvdiff.out
if [[ "$comparison" != 'files are identical' ]] ; then
  exit_status=1
fi

# csvdiff requires a unique key in each row
# Provide the Regulator and Target columns together as the index
echo Comparing SCINGE_Ranked_Edge_List.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Regulator,Target $outdir/SCINGE_Ranked_Edge_List.txt $refdir/SCINGE_Ranked_Edge_List.txt
cat csvdiff.out
comparison=$(cat csvdiff.out)
rm csvdiff.out
if [[ "$comparison" != 'files are identical' ]] ; then
  exit_status=1
fi

echo Comparing sparse adjacency matrices
for id in 541 542
do
  for rep in 1 2
  do
    filename=AdjMatrix_data1_X_SCODE_datapmat_ID_${id}_lambda_0p01_replicate_${rep}.mat
    python tests/compare_adj_matrices.py $outdir/$filename $refdir/$filename
    return_code=$?
    if [[ $return_code -ne 0 ]] ; then
      exit_status=1
    fi
  done
done

exit $exit_status
