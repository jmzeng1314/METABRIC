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

library(survival)
library(survminer)

load(file='metabric_clinical.Rdata')
dim(clin)
clin[1:4,1:4]
# 终点事件(outcome event)又称失效事件(failure event) 或死亡事件(death event)  
# 这种分组资料的生存分析常采用寿命表法(life-table method)
# 生存分析也经常采用Kaplan-Meier曲线及log-rank检验
table(clin$VITAL_STATUS)
table(clin$OS_STATUS)
clin=clin[clin$OS_STATUS %in% c('DECEASED','LIVING'),]
phe=clin
phe$event=ifelse(phe$OS_STATUS=='DECEASED',1,0)
phe$time=as.numeric(phe$OS_MONTHS)
colnames(phe)
# 利用ggsurvplot快速绘制漂亮的生存曲线图
sfit <- survfit(Surv(time, event)~ER_IHC, data=phe)
sfit
summary(sfit)
ggsurvplot(sfit, conf.int=F, pval=TRUE)

ggsurvplot(sfit,
           risk.table =TRUE,pval =TRUE,
           conf.int =TRUE,xlab ="Time in months", 
           ggtheme =theme_light(), 
           ncensor.plot = TRUE)

###################################################
##First do survival analysis based on mutations####
###################################################
load(file='metabric_mutations.Rdata')
options(stringsAsFactors = F) 
dim(mut)
mut[1:4,1:4] 
tail(sort(table(mut$Hugo_Symbol)))
phe$gene=ifelse(phe$PATIENT_ID %in% mut[mut$Hugo_Symbol=='PIK3CA',]$Tumor_Sample_Barcode,
                'mut','widetype')
sfit <- survfit(Surv(time, event)~gene, data=phe)
sfit
summary(sfit)
ggsurvplot(sfit, conf.int=F, pval=TRUE)







