#!/bin/bash

# Bash script to resume 1 Master and n slaves

proc=$1
outdir=$2
bin=$3

#if less than three arguments supplied display usage
 
if [ $# -le 2 ]
then
        echo "Usage: $0 cores input-dir output-dir binary+commands"
        echo 'Example Usage: '$0' 38 in-dir out-dir "./bash -c :"'
        exit 1
fi

screen -S master -d -m afl-fuzz -i- -o $outdir -M master -- $bin 

for ((i = 1; i <= $1; i++)); do
    screen -S slave-$i -d -m afl-fuzz -i- -o $outdir -S slave-$i -- $bin
done
