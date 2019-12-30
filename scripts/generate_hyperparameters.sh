#!/bin/bash

DATE=`date +%m/%d/%Y`
DATEname=`date +%Y%m%d`
echo $DATE

if [ $# -eq 0 ]
	then
		family=gaussian
		numreplicates=10
elif [ $# -eq 1 ]
	then
		family=$1
		numreplicates=10
else
	family=$1
	numreplicates=$2
fi

listname="hyperparameters_$DATEname.txt"
rm -f $listname
touch $listname
ID=0
lambda=[$(
while read lam
do
	echo -n "$lam,"
done < lambda.txt)
lambda=${lambda::-1}]

for replicate in $(seq 1 $numreplicates)
do
	while IFS='' read -r prs; do
		while IFS='' read -r pzr; do 
			while read dT num_lags; do
				while IFS='' read -r kernel; do
					echo "--lambda $lambda --dT $dT --num-lags $num_lags --kernel-width $kernel --ID $ID --replicate $replicate --family $family --date $DATE --prob-zero-removal $pzr --prob-remove-sample $prs">>$listname
					ID=$((ID+1))
				done < kernel.txt
			done < time.txt 
		done < probzeroremoval.txt
	done < probremovesample.txt
done
