#!/bin/bash

# Bash script to start 1 Master and "n" slaves 

proc=$1
indir=$2
outdir=$3
bin=$4

#if less than four arguments supplied display usage

if [ $# -le 3 ]
then
        echo "Usage: $0 cores input-dir output-dir binary+commands"
        echo 'Example Usage: '$0' 38 in-dir out-dir "./bash -c :"'
        exit 1
fi

screen -S master -d -m afl-fuzz -i $indir -o $outdir -M master -- $bin

for ((i = 1; i <= $1; i++)); do
        screen -S slave-$i -d -m afl-fuzz -i $indir -o $outdir -S slave-$i -- $bin
done
