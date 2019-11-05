#!/bin/bash
# Bash script to run compiled MATLAB code
# Usage:
# bash SINGE.sh runtime_dir mode Data gene_list outdir [hyperparameter_file] [hyperparameter_number]
#
# Inputs:
# runtime_dir: path to MATLAB R2018a runtime library directory (download from https://www.mathworks.com/products/compiler/matlab-runtime.html)
# mode: standalone, GLG, or Aggregate
# Data: Path to single-cell expression data file
# gene_list: File path to list of genes in the dataset
# outdir: Directory path for storing temporary files and final ranked lists of gene interactions and influential genes
# hyperparameter_file: file containing list of hyperparameter combinations for SINGE (standalone and GLG modes)
# hyperparameter_number: hyperparameter index to use from the hyperparameter_file (Aggregate mode only)
# 
# Example:
# bash SINGE.sh PATH_TO_RUNTIME standalone data1/X_SCODE_data.mat data1/tf.mat Output data1/default_hyperparameters.txt

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
validMode=0
echo "SINGE operating in" $mode "mode"
if [[ $mode == $mode1 ]]; then 
	validMode=1
	echo $mode1 "mode running GLG tests"
	#nargs=`{ cat $hypefile; echo ''; } | wc -l`
	nargs=`grep -c "" $hypefile`
	#echo $nargs
	for hypenum in `seq 1 $nargs`; do
	    echo hypenum: $hypenum
	    arg=$(sed "$hypenum q;d" $hypefile)
	    echo arg: $arg
	    bash run_SINGE_GLG_Test.sh $runtime $data --outdir $outdir $arg
	done
elif [[ $mode == $mode2 ]]; then 
	validMode=1
	echo $mode2 "mode running"
	hypenum=$7
	echo hypenum: $hypenum
	arg=$(sed "$hypenum q;d" $hypefile)
	echo arg: $arg
	bash run_SINGE_GLG_Test.sh $runtime $data --outdir $outdir $arg
fi

if [[ $mode == $mode3 ]]||[[ $mode == $mode1 ]]; then 
	validMode=1
	echo $mode3 "mode running"
	bash run_SINGE_Aggregate.sh $runtime $data $gene_list $outdir
fi

if [[ $validMode == 0 ]]; then 
	echo Invalid SINGE mode. Please use one of the following modes: $mode1, $mode2, $mode3
fi
