#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin/data

for reads in *.gz
do
    fastqc $reads
done