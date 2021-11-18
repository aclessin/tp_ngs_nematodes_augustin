#! /bin/bash


cd ~/mydatalocal/tp_ngs_nematodes_augustin
#unzip data/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz

Names="SRR5564861
SRR5564862
SRR5564863
SRR5564855
SRR5564856
SRR5564857"

salmon index --threads 3 --transcripts data/Caenorhabditis_elegans.WBcel235.cdna.all.fa --index processed_data/Salmonindex
