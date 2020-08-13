#!/bin/bash
# Compare the SINGE output with the reference output
# for the branching dataset
# This script must be called from the base directory of the repository
# Must have already run SINGE on the example branching data
# The SINGE output directory is provided as an argument
# Must run inside the conda environment specified by environment.yml or have
# those Python packages available
# Only checks the third hyperparameter combination and the adjacency matrices
# not the gene scores or ranked edge list

usage="Usage: $(basename $0) output-directory [rtol] [atol]"

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

# Set optional relative and absolute tolerance for comparing adjacency matrix values
rtol=""
if [ $# -gt 1 ]; then
  echo Setting relative tolerance: $2
  rtol=--rtol=$2
fi
atol=""
if [ $# -gt 2 ]; then
  echo Setting absolute tolerance: $3
  atol=--atol=$3
fi

refdir=tests/reference/branching

# Return 0 unless any individual test fails
# Continue running all tests even if one fails
exit_status=0

echo Comparing sparse adjacency matrices
for id in 542
do
  for rep in 1
  do
    for branch in 1 2 3
    do
      filename=AdjMatrix_data1_X_SCODE_datapmat_ID_${id}p${branch}_lambda_0p01_replicate_${rep}.mat
      python tests/compare_adj_matrices.py $outdir/$filename $refdir/$filename $rtol $atol
      return_code=$?
      if [[ $return_code -ne 0 ]] ; then
        exit_status=1
      fi
    done
  done
done

exit $exit_status
