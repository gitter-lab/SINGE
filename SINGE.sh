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
runtime=$1
mode=$2
data=$3
gene_list=$4
outdir=$5
hypefile=$6
shopt -s nocasematch
mode1=standalone
mode2=GLG
mode3=Aggregate
echo "SINGE operating in " $mode "mode"
if [[ $mode == $mode1 ]]; then 
	echo $mode1 "mode running GLG tests"
	while read arg||[ -n $arg ]; do 
	    bash run_SINGE_GLG_Test.sh $runtime $data --outdir $outdir $arg
	done < $hypefile
elif [[ $mode == $mode2 ]]; then 
	echo $mode2 "mode running"
	hypenum=$7
	echo hypenum: $hypenum
	arg=$(sed "$hypenum q;d" $hypefile)
	echo arg: $arg
	bash run_SINGE_GLG_Test.sh $runtime $data --outdir $outdir $arg
fi

if [[ $mode == $mode3 ]]||[[ $mode == $mode1 ]]; then 
	echo $mode3 "mode running"
	bash run_SINGE_Aggregate.sh $runtime $data $gene_list $outdir
fi
