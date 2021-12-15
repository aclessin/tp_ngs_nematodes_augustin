library(RAPToR)
library(limma)
library(tximport)

paths=c("SRR5564861","SRR5564862","SRR5564863","SRR5564855","SRR5564856","SRR5564857")
fullpaths=file.path("processed_data/salmon",paths,shell"quant.sf") #concaténation avec file.path très pratique
tx2gn <- read.table("data/tx2gn.csv", h=T, sep=',', as.is=T)
data=tximport(fullpaths,'salmon', tx2gene = tx2gn)#tx2gene c'est pour transformer les noms de transcripts en noms de gènes
colnames(data$abundance)=c("alg-1 (rep1)","alg-1(rep2)","alg-1 (rep3)","WT (rep1)","WT (rep2)","WT (rep3)")

colData=data.frame(paths,factor(c("Alg1","Alg1","Alg1","WT","WT","WT"),levels = c("WT", "Alg1")))
colnames(colData)=c("sample","treatment")
data$normlog=normalizeBetweenArrays(data$abundance,method = "quantile")
data$normlog=log1p(data$normlog)

ref=prepare_refdata("Cel_larv_YA","wormRef",n.inter=600)

pseudoage_data=ae(data$normlog,refdata = ref$interpGE, ref.time_series = ref$time.series)

plot(pseudoage_data, groups = colData$treatment, show.boot_estimates = T)

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

comparaison=refCompare(data$abundance,ref,pseudoage_data,colData$treatment)
plot(comparaison)
