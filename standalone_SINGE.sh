#!/bin/bash
# Bash script to run compiled MATLAB code
# Usage:
# bash standalone_SINGE.sh Data gene_list outdir hyperparameter_file runtime_dir
#
# Inputs:
# Data: Path to single-cell expression data file
# gene_list: File path to list of genes in the dataset
# outdir: Directory path for storing temporary files and final ranked lists of gene interactions and influential genes
# hyperparameter_file: file containing list of hyperparameter combinations for SINGE
# runtime_dir: path to MATLAB R2018a runtime library directory (Download from https://www.mathworks.com/products/compiler/matlab-runtime.html)
# 
# Example:
# bash standalone_SINGE.sh data1/X_SCODE_data data1/tf.mat Output data1/default_hyperparameters.txt PATH_TO_RUNTIME
data=$1
gene_list=$2
outdir=$3
hypefile=$4
runtime=$5
while read arg||[ -n "$arg" ]; do 
    bash run_SINGE_GLG_Test.sh $runtime $data --outdir $outdir $arg
done < $hypefile

bash run_SINGE_Aggregate.sh $runtime $data $gene_list $outdir
