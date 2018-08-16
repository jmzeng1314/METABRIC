## 
### ---------------
###
### Create: Jianming Zeng
### Date: 2018-08-10 17:07:49
### Email: jmzeng1314@163.com
### Blog: http://www.bio-info-trainee.com/
### Forum:  http://www.biotrainee.com/thread-1376-1-1.html
### CAFS/SUSTC/Eli Lilly/University of Macau
### Update Log: 2018-08-10  First version
###
### ---------------
rm(list = ls())
load(file='metabric_mutations.Rdata')
options(stringsAsFactors = F) 
dim(mut)
mut[1:4,1:4]
maf

suppressPackageStartupMessages(library("deconstructSigs"))
suppressPackageStartupMessages(library("BSgenome"))
suppressPackageStartupMessages(library("BSgenome.Hsapiens.UCSC.hg19"))
options(stringsAsFactors = F)
head(mut)
a=mut[mut$Variant_Type=='SNP',]
a=a[,c('Tumor_Sample_Barcode','Chromosome','Start_Position','Tumor_Seq_Allele1','Tumor_Seq_Allele2')]
colnames(a)=c( "Sample","chr", "pos","ref",  "alt")
head(a)
a$chr=as.character(a$chr)
a$chr=paste0('chr',a$chr)
a$ref=as.character(a$ref)
a$alt=as.character(a$alt)
a$Sample=as.character(a$Sample)
a=a[nchar(a$ref)==1 & nchar(a$alt)==1,]
plot(table(a$Sample),las=2)
sigs.input <- mut.to.sigs.input(mut.ref = a, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt",
                                bsg = BSgenome.Hsapiens.UCSC.hg19)
class(sigs.input)
head(t(sigs.input))
w=lapply(unique(a$Sample), function(i){
  ## signatures.cosmic signatures.nature2013
  sample_1 = whichSignatures(tumor.ref = sigs.input, 
                             signatures.ref = signatures.cosmic, 
                             sample.id =  i, 
                             contexts.needed = TRUE,
                             tri.counts.method = 'default')
  return(sample_1$weights)
})
w=do.call(rbind,w)
library(pheatmap)
pheatmap(t(w),cluster_rows = F,
         cluster_cols = T,show_colnames = F,
         filename = 'signatures.cosmic.heatmap.png')
pheatmap(w,cluster_rows = T,cluster_cols = F)

if(F){
  # Determine the signatures contributing to the two example samples
  lapply(unique(a$Sample), function(i){
    ## signatures.cosmic signatures.nature2013
    sample_1 = whichSignatures(tumor.ref = sigs.input, 
                               signatures.ref = signatures.cosmic, 
                               sample.id =  i, 
                               contexts.needed = TRUE,
                               tri.counts.method = 'default')
    pdf(paste0(i,'.sig.pdf'))
    plotSignatures(sample_1, sub = i)
    dev.off()
  })
  
}


a$Sample='all_signatures.cosmic'
i='all_signatures.cosmic'
sigs.input <- mut.to.sigs.input(mut.ref = a, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt",
                                bsg = BSgenome.Hsapiens.UCSC.hg19)
class(sigs.input)
head(t(sigs.input))

sample_1 = whichSignatures(tumor.ref = sigs.input, 
                           signatures.ref = signatures.cosmic , 
                           sample.id =  i, 
                           contexts.needed = TRUE,
                           tri.counts.method = 'default')
pdf(paste0(i,'.sig.pdf'))
plotSignatures(sample_1, sub = i)
dev.off()



