#!/bin/bash
data=$1
gene_list=$2
outdir=$3
hypefile=$4
while read arg||[ -n "$arg" ]; do 
    ./run_SINGE_GLG_Test.sh /usr/local/MATLAB/MATLAB_Runtime/v94 $data -outdir $outdir $arg
done < $hypefile

./run_SINGE_Aggregate.sh /usr/local/MATLAB/MATLAB_Runtime/v94 $gene_list $data $outdir
