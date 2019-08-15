#!/bin/bash
Data=$1
outdir=$3
gene_list=$2
hypefile=hyperparameters.txt
while read arg||[ -n "$arg" ]; do 
    ./run_GLG_Instance.sh v94 $Data --outdir $outdir $arg
done < $hypefile

./run_Aggregate.sh v94 $gene_list $Data $outdir
