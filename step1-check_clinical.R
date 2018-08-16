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
clin=read.table('brca_metabric/data_clinical_patient.txt',header = T,sep='\t')
summary(clin)
save(clin,file='metabric_clinical.Rdata')
load(file='metabric_clinical.Rdata')
dim(clin)
clin[1:4,1:4]



