#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin/

Names="SRR5564863
SRR5564855"

for SRR in $Names
do
    parallel-fastq-dump -s $SRR --threads 6 --split-3 --gzip --outdir data/
done