#!/bin/bash

# This script is used after running afl-cmin on corpus to minimise
#cd <path to sync folder>
#ls master  slave-1 slave-2 slave-3
#mkdir queues
#cp out-dir/*/queue/* queues
#<path to afl root>afl-cmin -i queues/ -o queues_cmin -- ./binary

proc=$1
indir=$2
outdir=$3
bin=$4
pids=""
crashes=`ls $indir | wc -l`

# if less than four arguments supplied, display usage 
if [  $# -le 3 ]
then
        echo "Usage: $0 numberofprocesses inputdirectory outputdirectory binary+commands"
        echo 'Example Usage: '$0' 4 queues_cmin queues_out "./binary"'
        exit 1
fi

for f in `seq 1 $proc $crashes`
do
        for i in `seq 0 $(expr $proc - 1)`
        do
                file=`ls -Sr $indir | sed $(expr $i + $f)"q;d"`
                echo $file
                afl-tmin -i $indir/$file -o $outdir/$file -- $bin &
        done

  wait
done
