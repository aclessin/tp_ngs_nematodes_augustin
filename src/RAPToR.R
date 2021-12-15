library(RAPToR)
library(limma)
paths=c("SRR5564861","SRR5564862","SRR5564863","SRR5564855","SRR5564856","SRR5564857")
fullpaths=file.path("processed_data/salmon",paths,"quant.sf") #concaténation avec file.path très pratique
tx2gn <- read.table("data/tx2gn.csv", h=T, sep=',', as.is=T)
data=tximport(fullpaths,'salmon', tx2gene = tx2gn)#le round qui est après peut être remplacé par la fonction intégrée countsFromAbundance
colnames(data$abundance)=c("Alg1","Alg1","Alg1","WT","WT","WT")

data$normlog=normalizeBetweenArrays(data$abundance,method = "quantile")
data$normlog=log1p(data$normlog)

ref=prepare_refdata("Cel_larval_YA","wormRef",n.inter=600)

pseudoage_data=ae(data$normlog,refdata = ref$interpGE, ref.time_series = ref$time.series)

plot(pseudoage_data,labels=paths)
