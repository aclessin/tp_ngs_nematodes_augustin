library(RAPToR)
library(limma)
library(tximport)

paths=c("SRR5564861","SRR5564862","SRR5564863","SRR5564855","SRR5564856","SRR5564857")
fullpaths=file.path("processed_data/salmon/",paths,"quant.sf") #concaténation avec file.path très pratique
tx2gn <- read.table("data/tx2gn.csv", h=T, sep=',', as.is=T)
data=tximport(fullpaths,'salmon', tx2gene = tx2gn)#tx2gene c'est pour transformer les noms de transcrits en noms de gènes
colnames(data$abundance)=c("alg-1 (rep1)","alg-1(rep2)","alg-1 (rep3)","WT (rep1)","WT (rep2)","WT (rep3)")

upgenes=read.table("results/fGOup.data",h=F,sep='\n',as.is=T)$V1
downgenes=read.table("results/fGOdown.data",h=F,sep='\n',as.is=T)$V1
colData=data.frame(paths,factor(c("Alg1","Alg1","Alg1","WT","WT","WT"),levels = c("WT", "Alg1")))
colnames(colData)=c("sample","treatment")
data$normlog=normalizeBetweenArrays(data$abundance,method = "quantile")
data$normlog=log1p(data$normlog)

ref=prepare_refdata("Cel_larv_YA","wormRef",n.inter=600)
pseudoage_data=ae(data$normlog,refdata = ref$interpGE, ref.time_series = ref$time.series)

colors = c("blue", "red")
plot(pseudoage_data, groups = colData$treatment,color = colors[colData$treatment], show.boot_estimates = T,xlim=c(41,47))
#plot des pseudoages obtenues avec raptor en fonction des traitements et réplicats


getrefTP <-function(ref, ae_obj, ret.idx = T){
  # function to get the indices/GExpr of the reference matching sample age estimates.
  idx <- sapply(ae_obj$age.estimates[,1],function(t) which.min(abs(ref$time.series - t)))
  if(ret.idx)
    return(idx)
  return(ref$interpGE[,idx])
}

refCompare <-function(samp, ref, ae_obj, fac){
  # function to compute the reference changes and the observed changes
  ovl <- format_to_ref(samp, getrefTP(ref, ae_obj, ret.idx = F))
  lm_samp <- lm(t(ovl$samp)~fac)
  lm_ref <- lm(t(ovl$ref)~fac)
  return(list(samp=lm_samp, ref=lm_ref, ovl_genelist=ovl$inter.genes))
}

comparaison=refCompare(log1p(data$abundance),ref,pseudoage_data,colData$treatment)#comparaison des diff muta/WT avec les diff d'expression attendues simplementavec la diff  d'age développementale
par(pty="s")
#colors = 2*(comparaison$ovl_genelist %in% upgenes + 0) + (comparaison$ovl_genelist %in% downgenes)+1# ça sert à rien 
colors=c(1,1,1,2,2,2)
plot(comparaison$ref$coefficients[2,],comparaison$samp$coefficients[2,],
     ylim=c(-5,5),xlim=c(-5,5),col=1,cex=0.8,pch=16,xlab='log2fold ref',ylab='log2fold sample',main="alg-1")

points(comparaison$ref$coefficients[2, comparaison$ovl_genelist %in% upgenes],
       comparaison$samp$coefficients[2,comparaison$ovl_genelist %in% upgenes],cex=0.8,col=3,pch=16)
points(comparaison$ref$coefficients[2, comparaison$ovl_genelist %in% downgenes],
       comparaison$samp$coefficients[2,comparaison$ovl_genelist %in% downgenes],cex=0.8,col=2,pch=16)
#abline(0,cor(comparaison$ref$coefficients[2,],comparaison$samp$coefficients[2,]),col=4,cex=5)
legend('bottomright',legend=c("upregulated","downregulated","not significant"),
       col=c(3,2,1), pch=16, lwd=2, lty=NA,x.intersp = 0.05, bty="n")
