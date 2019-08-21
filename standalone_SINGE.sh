#!/bin/bash
data=$1
gene_list=$2
outdir=$3
hypefile=$4
while read arg||[ -n "$arg" ]; do 
    ./run_SINGE_GLG_Test.sh v94 $data -outdir $outdir $arg
done < $hypefile

./run_SINGE_Aggregate.sh v94 $gene_list $data $outdir
