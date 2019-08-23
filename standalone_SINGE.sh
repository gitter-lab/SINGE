#!/bin/bash
data=$1
gene_list=$2
outdir=$3
hypefile=$4
runtime=$5
while read arg||[ -n "$arg" ]; do 
    ./run_SINGE_GLG_Test.sh $runtime $data -outdir $outdir $arg
done < $hypefile

./run_SINGE_Aggregate.sh $runtime $gene_list $data $outdir
