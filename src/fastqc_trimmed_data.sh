#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin/processed_data/paired

for reads in *.gz
do
    fastqc $reads --threads 1
done