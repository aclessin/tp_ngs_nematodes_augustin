#! /bin/bash

cd ~/mydatalocal/tp_ngs_nematodes_augustin

Names="SRR5564861
SRR5564862
SRR5564863
SRR5564855
SRR5564856
SRR5564857"
cd processed_data/
mkdir unpaired
mkdir paired
cd ..
for reads in $Names
do
  java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE data/${reads}_1.fastq.gz data/${reads}_2.fastq.gz processed_data/paired/${reads}_1.fq.gz \
  processed_data/unpaired/${reads}_1.fq.gz paired/${reads}_2.fq.gz processed_data/unpaired/${reads}_2.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36
done