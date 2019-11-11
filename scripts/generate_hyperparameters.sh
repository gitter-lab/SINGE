#!/bin/bash
numreplicates=10
pzr=$(head -n 1 probzeroremoval.txt)
prs=$(head -n 1 probremovesample.txt)
DATE=`date +%m/%d/%Y`
DATEname=`date +%Y%m%d`
echo $DATE
export family=$1
listname="hyperparameters_$DATEname.txt"
rm $listname
touch $listname
ID=0
for replicate in $(seq 1 $numreplicates)
do
	while read lambda; do
		while read dT num_lags; do
			while IFS='' read -r kernel; do
				echo "--lambda $lambda --dT $dT --num-lags $num_lags --kernel-width $kernel --ID $ID --replicate $replicate --family $family --date $DATE --prob-zero-removal $pzr --prob-remove-sample $prs">>$listname
				ID=$((ID+1))
			done < kernel.txt
		done < time.txt 
	done < lambda.txt 
done
