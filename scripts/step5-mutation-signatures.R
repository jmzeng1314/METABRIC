## 
### ---------------
###
### Create: Jianming Zeng 
### Email: jmzeng1314@163.com
### Blog: http://www.bio-info-trainee.com/
### Forum:  http://www.biotrainee.com/thread-1376-1-1.html
### CAFS/SUSTC/Eli Lilly/University of Macau
### Update Log: 2018-08-10  First version
### Update Log: 2019-08-16  second version codes (R version 3.5.1 (2018-07-02))
###
### ---------------

rm(list = ls())
wkdir=getwd()
options(stringsAsFactors = F)
load(file=file.path(wkdir,'data','metabric_mutations.Rdata'))
options(stringsAsFactors = F) 
dim(mut)
mut[1:4,1:4]
maf

suppressPackageStartupMessages(library("deconstructSigs"))
suppressPackageStartupMessages(library("BSgenome"))
# 一定要选择正确的参考基因组,人类的GRCh37就使用hg19
suppressPackageStartupMessages(library("BSgenome.Hsapiens.UCSC.hg19"))
options(stringsAsFactors = F)
head(mut)
# 这里仅仅是使用SNP信息，构建一个矩阵供  mut.to.sigs.input 函数使用。
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
# 直接使用 mut.to.sigs.input 处理构建好的突变矩阵即可
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
         filename = file.path(wkdir,'figures','signatures.cosmic.heatmap.png'))
pheatmap(w,cluster_rows = T,cluster_cols = F)

# 也可以选择对每个样本进行绘图，当然，没什么必要。
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

## 使用 deconstructSigs 来对突变数据找signature时候，有一个参数可以选择
# 这里就不演示了，我们使用默认的是

## 然后我们把所有突变合并后找signature，前面演示的是分开样本找signature。
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

save(sigs.input,w,
     file = file.path(wkdir,'data','metebric_signature_output.Rdata'))






