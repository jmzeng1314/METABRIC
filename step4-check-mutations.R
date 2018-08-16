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
options(stringsAsFactors = F)
if(F){
  mut=read.table('brca_metabric/data_mutations_extended.txt',
                 header = T,sep='\t',fill = T,quote = '')
  dim(mut)
  mut[1:4,1:4]
  length(unique(mut$Hugo_Symbol)) 
  library(maftools)
  maf=read.maf('brca_metabric/data_mutations_extended.txt')
  save(mut,maf,file='metabric_mutations.Rdata')
}
load(file='metabric_mutations.Rdata')
dim(mut)
mut[1:4,1:4]
maf




