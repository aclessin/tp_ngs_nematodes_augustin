library("tximport")
library("DESeq2")
library("GenomicAlignments")
paths=c("SRR5564861","SRR5564862","SRR5564863","SRR5564855","SRR5564856","SRR5564857")
fullpaths=file.path("processed_data/salmon",paths,"quant.sf") #concaténation avec file.path très pratique
tx2gn <- read.table("data/tx2gn.csv", h=T, sep=',', as.is=T)

data=tximport(fullpaths,'salmon', tx2gene = tx2gn)#le round qui est après peut être remplacé par la fonction intégrée countsFromAbundance


par(mfrow=c(1,2),pty='s')
plot(log1p(data$counts[,1]),log1p(data$counts[,4]),xlab="log(abondance) WT1",ylab='log(abondance mut1')
plot(log1p(data$counts[,1]),log1p(data$counts[,2]),xlab="log(abondance) WT1",ylab='log(abondance WT2')


colData=data.frame(paths,factor(c("Alg1","Alg1","Alg1","WT","WT","WT"),levels = c("WT", "Alg1")))
colnames(colData)=c("sample","treatment")
dp=DESeqDataSetFromMatrix(round(data$counts),colData = colData,design=~treatment)
res=DESeq(dp,test="LRT", reduced=~1)
resW=DESeq(dp,test="Wald")
resta=results(res)
restaW=results(resW)
#on peut comparer les résultats du test de wald et de la comparaison de vraisemblance

forGOup=resta$padj < 0.05 & resta$log2FoldChange > 1.5# on trie les p-values significatives et les log fold change> 1.5 parce qu'on considère qu'en dessous de 1.5, même si c'est significatif ça n'a pas ou peu d'effet biologique
table(forGOup)

forGOWup=restaW$padj < 0.05 & resta$log2FoldChange > 1.5
table(forGOWup)

forGOdown=resta$padj < 0.05 & resta$log2FoldChange < -1.5
table(forGOdown)

forGOWdown=restaW$padj < 0.05 & resta$log2FoldChange < -1.5
table(forGOWdown)



genesofinterestup=na.omit(rownames(resta)[forGOup])#LRT
genesofinterestWup=na.omit(rownames(restaW)[forGOWup])#Wald test
genesofinterestdown=na.omit(rownames(resta)[forGOdown])
genesofinterestWdown=na.omit(rownames(restaW)[forGOWdown])



par(mfrow=c(1,2),pty='s')
plotMA(restaW,ylim=c(-12,12))
plotMA(resta,ylim=c(-12,12))




GOup = file("results/fGOup.data", "w")#création d'un fichier en mode écriture
GOWup = file("results/fGOWup.data", "w")
GOdown = file("results/fGOdown.data", "w")
GOWdown = file("results/fGOWdown.data", "w")


cat(genesofinterestup,sep='\n', file = GOup)#écriture du fichier
cat(genesofinterestWup,sep='\n', file = GOWup)
cat(genesofinterestdown,sep='\n', file = GOdown)
cat(genesofinterestWdown,sep='\n', file = GOWdown)