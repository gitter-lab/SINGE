#!/bin/bash
# Compare the SINGE output with the reference output
# This script must be called from the base directory of the repository
# Must have already run SINGE on the example data
# The SINGE output directory is provided as an argument
# The reference SINGE output directory is provided as an argument
# Must run inside the conda environment specified by environment.yml or have
# those Python packages available

usage="Usage: $(basename $0) output-directory reference-directory [rtol] [atol] [dataset]"

if [ $# -gt 0 ]; then
  # First arugment is the SINGE output directory
  if [ $1 == "-h" ]; then
    echo $usage
    exit 0
  fi
  outdir=$1
else
  echo $usage
  exit 1
fi

if [ $# -gt 1 ]; then
  # Second arugment is the reference directory with the expected SINGE output
  refdir=$2
else
  echo $usage
  exit 1
fi

# Set optional relative and absolute tolerance for comparing adjacency matrix values
rtol=""
if [ $# -gt 2 ]; then
  echo Setting relative tolerance: $3
  rtol=--rtol=$3
fi
atol=""
if [ $# -gt 3 ]; then
  echo Setting absolute tolerance: $4
  atol=--atol=$4
fi

# Set optional dataset name
dataset=X_SCODE_data
if [ $# -gt 4 ]; then
  echo Setting dataset name: $5
  dataset=$5
fi

# Return 0 unless any individual test fails
# Continue running all tests even if one fails
exit_status=0

echo Comparing SINGE_Gene_Influence.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Gene_Name $outdir/SINGE_Gene_Influence.txt $refdir/SINGE_Gene_Influence.txt
cat csvdiff.out
comparison=$(cat csvdiff.out)
rm csvdiff.out
if [[ "$comparison" != 'files are identical' ]] ; then
  exit_status=1
fi

# csvdiff requires a unique key in each row
# Provide the Regulator and Target columns together as the index
echo Comparing SINGE_Ranked_Edge_List.txt
csvdiff --style=summary --sep='	' --significance=5 --output=csvdiff.out Regulator,Target $outdir/SINGE_Ranked_Edge_List.txt $refdir/SINGE_Ranked_Edge_List.txt
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
    filename=AdjMatrix_data1_${dataset}pmat_ID_${id}_lambda_0p01_replicate_${rep}.mat
    python tests/compare_adj_matrices.py $outdir/$filename $refdir/$filename $rtol $atol
    return_code=$?
    if [[ $return_code -ne 0 ]] ; then
      exit_status=1
    fi
  done
done

exit $exit_status
