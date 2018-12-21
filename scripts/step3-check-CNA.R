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
wkdir=getwd()
options(stringsAsFactors = F)
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
load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
dim(CNA)
CNA[1:4,1:4]
tail(sort(ncol(CNA)-apply(CNA,1,function(x) sum(x==0))))
table(as.numeric(CNA['DISC1',]))






