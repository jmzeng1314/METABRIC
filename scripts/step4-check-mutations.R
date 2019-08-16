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
# 同样的把somatic突变信息文件，读入到R，后续使用
if(F){
  mut=read.table(file.path(wkdir,'brca_metabric','data_mutations_extended.txt'),
                 header = T,sep='\t',fill = T,quote = '')
  dim(mut)
  mut[1:4,1:4]
  length(unique(mut$Hugo_Symbol)) 
  library(maftools)
  maf=read.maf(file.path(wkdir,'brca_metabric','data_mutations_extended.txt'))
  save(mut,maf,file=file.path(wkdir,'data','metabric_mutations.Rdata'))
}
load(file=file.path(wkdir,'data','metabric_mutations.Rdata'))
dim(mut)
mut[1:4,1:4]
maf
colnames(mut)
tmp=as.data.frame(table(unique(mut[,c("Hugo_Symbol","Tumor_Sample_Barcode" )])[,1]))
# 很简单就得到的每个基因的突变频率，排名较高的有 PIK3CA 和 TP53，符合逻辑。
metebric_mut_freq=tmp[order(tmp$Freq,decreasing = T),]
head(metebric_mut_freq)
save(metebric_mut_freq,
     file = file.path(wkdir,'data','metebric_mut_freq.Rdata'))
 



