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
options(stringsAsFactors = F)
wkdir=getwd()
# 从 brca_metabric 文件夹读取 临床信息文本文件，到R里面。
if(F){
  clin=read.table(file.path(wkdir,'brca_metabric','data_clinical_patient.txt'),
                  header = T,sep='\t')
  summary(clin)
  save(clin,file=file.path(wkdir,'data','metabric_clinical.Rdata'))
  
}
load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
summary(clin)
dim(clin)
clin[1:4,1:4]
table(clin$CLAUDIN_SUBTYPE)
# 可以看到，有529病人并没有分子分型信息。


