#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin

Names="SRR5564861
SRR5564862
SRR5564863
SRR5564855
SRR5564856
SRR5564857"

for seq in $Names
do
  salmon quant \
  --libType A\
  --index processed_data/Salmonindex\
  --mates1 processed_data/paired/${seq}_1.fq.gz \
  --mates2 processed_data/paired/${seq}_2.fq.gz \
  --threads 3 \
  --output processed_data/salmon/$seq
done