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
# 同样的读取METABRIC的CNA信息到R里面，后续分析需要它
if(F){
  CNA=read.table('~/Downloads/data_CNA.txt',header = T,sep='\t')
  dim(CNA)
  CNA[1:4,1:4]
  length(unique(CNA$Hugo_Symbol))
  rownames(CNA)=CNA$Hugo_Symbol
  CNA=CNA[,-c(1,2)]
  save(CNA,file=file.path(wkdir,'data','metabric_CNA.Rdata'))
}
load(file=file.path(wkdir,'data','metabric_CNA.Rdata')) 
dim(CNA)
CNA[1:4,1:4]
tail(sort(ncol(CNA)-apply(CNA,1,function(x) sum(x==0))))
table(as.numeric(CNA['ERBB2',]))

load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
dim(clin)
clin[1:4,1:4]
clin$PATIENT_ID = gsub('-','.',clin$PATIENT_ID)
phe=clin[match(colnames(CNA),clin$PATIENT_ID),]
# 检查临床记录的HER2信息，和真实的CNA矩阵的拷贝数
table(phe$HER2_SNP6)
table(as.numeric(CNA['ERBB2',]))




