#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin/

Names="SRR5564861
SRR5564862
SRR5564863
SRR5564855
SRR5564856
SRR5564857"

for SRR in $Names
do
    fastq-dump $SRR --split-3 --gzip --outdir data/
done