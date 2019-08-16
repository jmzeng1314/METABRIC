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
# 可以根据 somatic点突变和拷贝数变异来对病人进行分组后进行生存分析。
load(file = file.path(wkdir,'data','metabric_mut_positions.Rdata'))
load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
load(file=file.path(wkdir,'data','metabric_mutations.Rdata'))

library(survival)
library(survminer)
 
dim(clin)
clin[1:4,1:4]
# 终点事件(outcome event)又称失效事件(failure event) 或死亡事件(death event)  
# 这种分组资料的生存分析常采用寿命表法(life-table method)
# 生存分析也经常采用Kaplan-Meier曲线及log-rank检验
table(clin$VITAL_STATUS)
table(clin$OS_STATUS)
# 理论上这个时候需要区分 Died of Disease和Other Causes
phe=clin[clin$OS_STATUS %in% c('DECEASED','LIVING'),]
 
phe$event=ifelse(phe$OS_STATUS=='DECEASED',1,0)
phe$time=as.numeric(phe$OS_MONTHS)
colnames(phe)
# 利用ggsurvplot快速绘制漂亮的生存曲线图
sfit <- survfit(Surv(time, event)~ER_IHC, data=phe)
sfit
summary(sfit)
ggsurvplot(sfit, conf.int=F, pval=TRUE)
# 保存为图片，很有趣， 早期ER_IHC是可以区分生存的，但是到了10年（120个月）后，又逆转了。
# 真的是很有趣哦

# 值得一提的是，在文章：
#Comparison of the Performance of 6 Prognostic Signatures
#for Estrogen Receptor–Positive Breast Cancer
#A Secondary Analysis of a Randomized Clinical Trial
# 就是把病人区分为 0-5年， 5-10年，有兴趣的读者朋友也可以继续探索。
png(file=file.path(wkdir,'figures','survival_based_on_ER_IHC.png')
    ,res=200,width = 1080,height = 1080)
ggsurvplot(sfit,
           risk.table =TRUE,pval =TRUE,
           conf.int =TRUE,xlab ="Time in months", 
           ggtheme =theme_light(), 
           ncensor.plot = TRUE)
dev.off()
## 同理可以针对其它colnames(phe)变量来做生存分析，这里就不一一演示


# 后面的代码，做的事情太复杂，不一一注释解读了。
# 参考：https://mp.weixin.qq.com/s/efI8U2lb3UfMwLp94iqw1Q
# apply家族函数和for循环还是有区别的（批量生存分析出图bug）

###################################################
##First do survival analysis based on mutations####
###################################################
if(T){
  options(stringsAsFactors = F) 
  dim(mut)
  mut[1:4,1:4] 
  tail(sort(table(mut$Hugo_Symbol)))
  if(F){
    lapply(names(tail(sort(table(mut$Hugo_Symbol)))), function(gene){
      #gene='KMT2C'
      phe$gene=ifelse(phe$PATIENT_ID %in% mut[mut$Hugo_Symbol==gene,]$Tumor_Sample_Barcode,
                      'mut','widetype')
      sfit  <- survfit(Surv(time, event)~gene, data=phe)
      print(sfit)
      summary(sfit)
      png(file=file.path(wkdir,'figures',paste0('survival_based_on_',gene,'_mutation.png'))
          ,res=200,width = 1080,height = 1080)
      p <- ggsurvplot(sfit, conf.int=F, pval=TRUE)
      print(p$plot)
      dev.off()
    })
  }
  
  ## 批量生存分析 使用  logrank test 方法
  mySurv=with(phe,Surv(time, event))
  log_rank_p <- lapply(unique(mut$Hugo_Symbol), function(gene){
    # gene=exprSet[1,]
    phe$group=ifelse(phe$PATIENT_ID %in% mut[mut$Hugo_Symbol==gene,]$Tumor_Sample_Barcode,
                     'mut','widetype') 
    data.survdiff=survdiff(mySurv~group,data=phe)
    p.val = 1 - pchisq(data.survdiff$chisq, length(data.survdiff$n) - 1)
    return(p.val)
  })
  log_rank_p=unlist(log_rank_p)
  names(log_rank_p)=unique(mut$Hugo_Symbol)
  log_rank_p=sort(log_rank_p)
  head(log_rank_p)
  boxplot(log_rank_p)  
  table(log_rank_p<0.01)
  log_rank_p[log_rank_p<0.05]
  
  load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
  load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
  
  clin=clin[match(gsub('[.]','-',colnames(expr)),clin$PATIENT_ID),]
  expr=expr[,match(gsub('-','.',clin$PATIENT_ID),colnames(expr))]
  
  dim(expr)
  expr[1:4,1:4]
  dim(clin)
  clin[1:4,1:4]
  
  library(pheatmap)
  choose_gene=names(log_rank_p[log_rank_p<0.05])
  choose_gene = choose_gene[choose_gene %in% rownames(expr)]
  choose_matrix=expr[choose_gene,]
  choose_matrix[1:4,1:4]
  choose_matrix=t(scale(t(log2(choose_matrix+1)))) 
  ## http://www.bio-info-trainee.com/1980.html
  colnames(clin)
  annotation_col =  clin[,c("OS_STATUS" ,"ER_IHC","HER2_SNP6","THREEGENE")]
  rownames(annotation_col)=colnames(expr)
  pheatmap(choose_matrix,show_colnames = F, annotation_col = annotation_col , 
           filename = file.path(wkdir,'figures','mutation_logRank_genes.heatmap.png')  ) 
  
  library(ggfortify)
  df=as.data.frame(t(choose_matrix))
  df$group=clin$OS_STATUS
  png( file.path(wkdir,'figures','mutation_logRank_genes.pca.png'),res=120)
  autoplot(prcomp( df[,1:(ncol(df)-1)] ), data=df,colour = 'group')+theme_bw()
  dev.off()
  
  
}
mutation_log_rank_p=log_rank_p
###################################################
## Then do survival analysis based on Expression ##
###################################################
if(T){
  options(stringsAsFactors = F) 
  load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
  load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
  head(phe)
  dim(expr)
  expr[1:4,1:4]  
  head(phe$PATIENT_ID )
  pid=intersect( phe$PATIENT_ID , gsub('[.]','-',colnames(expr) ) ) 
  expr=expr[, pid]
  phe=phe[match(pid,phe$PATIENT_ID),]
  expr=na.omit(expr)
  dim(expr)
  expr[1:4,1:4]  
  str(expr) 
  ## 批量生存分析 使用  logrank test 方法
  mySurv=with(phe,Surv(time, event))
  log_rank_p <- lapply(rownames(expr), function(gene){
    gene=as.numeric(expr[gene,])
    phe$group=ifelse( gene > median(gene),
                     'high','low') 
    data.survdiff=survdiff(mySurv~group,data=phe)
    p.val = 1 - pchisq(data.survdiff$chisq, length(data.survdiff$n) - 1)
    return(p.val)
  })
  log_rank_p=unlist(log_rank_p)
  names(log_rank_p)= rownames(expr)
  log_rank_p=sort(log_rank_p)
  head(log_rank_p)
  boxplot(log_rank_p)  
  table(log_rank_p<0.01)
  log_rank_p[log_rank_p<0.05]
  
  load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
  load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
  
  clin=clin[match(gsub('[.]','-',colnames(expr)),clin$PATIENT_ID),]
  expr=expr[,match(gsub('-','.',clin$PATIENT_ID),colnames(expr))]
  
  dim(expr)
  expr[1:4,1:4]
  dim(clin)
  clin[1:4,1:4]
  
  library(pheatmap)
  choose_gene=names(log_rank_p[log_rank_p<0.05])
  choose_gene = choose_gene[choose_gene %in% rownames(expr)]
  choose_matrix=expr[choose_gene,]
  choose_matrix[1:4,1:4]
  choose_matrix=t(scale(t(log2(choose_matrix+1)))) 
  ## http://www.bio-info-trainee.com/1980.html
  colnames(clin)
  annotation_col =  clin[,c("OS_STATUS" ,"ER_IHC","HER2_SNP6","THREEGENE")]
  rownames(annotation_col)=colnames(expr)
  pheatmap(choose_matrix,show_colnames = F, annotation_col = annotation_col , 
           filename = file.path(wkdir,'figures','logRank_genes.heatmap.png')  ) 
  
  library(ggfortify)
  df=as.data.frame(t(choose_matrix))
  df$group=clin$OS_STATUS
  png( file.path(wkdir,'figures','logRank_genes.pca.png'),res=120)
  autoplot(prcomp( df[,1:(ncol(df)-1)] ), data=df,colour = 'group')+theme_bw()
  dev.off()
  
  
}
expression_log_rank_p=log_rank_p


###################################################
##First do survival analysis based on mutations####
###################################################
if(T){
  options(stringsAsFactors = F) 
  dim(mut)
  mut[1:4,1:4] 
  tail(sort(table(mut$Hugo_Symbol)))
  if(F){
    lapply(names(tail(sort(table(mut$Hugo_Symbol)))), function(gene){
      #gene='KMT2C'
      phe$gene=ifelse(phe$PATIENT_ID %in% mut[mut$Hugo_Symbol==gene,]$Tumor_Sample_Barcode,
                      'mut','widetype')
      sfit  <- survfit(Surv(time, event)~gene, data=phe)
      print(sfit)
      summary(sfit)
      png(file=file.path(wkdir,'figures',paste0('survival_based_on_',gene,'_mutation.png'))
          ,res=200,width = 1080,height = 1080)
      p <- ggsurvplot(sfit, conf.int=F, pval=TRUE)
      print(p$plot)
      dev.off()
    })
  }
  
  ## 批量生存分析 使用  logrank test 方法
  mySurv=with(phe,Surv(time, event))
  log_rank_p <- lapply(unique(mut$Hugo_Symbol), function(gene){
    # gene=exprSet[1,]
    phe$group=ifelse(phe$PATIENT_ID %in% mut[mut$Hugo_Symbol==gene,]$Tumor_Sample_Barcode,
                     'mut','widetype') 
    data.survdiff=survdiff(mySurv~group,data=phe)
    p.val = 1 - pchisq(data.survdiff$chisq, length(data.survdiff$n) - 1)
    return(p.val)
  })
  log_rank_p=unlist(log_rank_p)
  names(log_rank_p)=unique(mut$Hugo_Symbol)
  log_rank_p=sort(log_rank_p)
  head(log_rank_p)
  boxplot(log_rank_p)  
  table(log_rank_p<0.01)
  log_rank_p[log_rank_p<0.05]
  
  load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
  load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
  
  clin=clin[match(gsub('[.]','-',colnames(expr)),clin$PATIENT_ID),]
  expr=expr[,match(gsub('-','.',clin$PATIENT_ID),colnames(expr))]
  
  dim(expr)
  expr[1:4,1:4]
  dim(clin)
  clin[1:4,1:4]
  
  library(pheatmap)
  choose_gene=names(log_rank_p[log_rank_p<0.05])
  choose_gene = choose_gene[choose_gene %in% rownames(expr)]
  choose_matrix=expr[choose_gene,]
  choose_matrix[1:4,1:4]
  choose_matrix=t(scale(t(log2(choose_matrix+1)))) 
  ## http://www.bio-info-trainee.com/1980.html
  colnames(clin)
  annotation_col =  clin[,c("OS_STATUS" ,"ER_IHC","HER2_SNP6","THREEGENE")]
  rownames(annotation_col)=colnames(expr)
  pheatmap(choose_matrix,show_colnames = F, annotation_col = annotation_col , 
           filename = file.path(wkdir,'figures','logRank_genes.heatmap.png')  ) 
  
  library(ggfortify)
  df=as.data.frame(t(choose_matrix))
  df$group=clin$OS_STATUS
  png( file.path(wkdir,'figures','logRank_genes.pca.png'),res=120)
  autoplot(prcomp( df[,1:(ncol(df)-1)] ), data=df,colour = 'group')+theme_bw()
  dev.off()
  
  
}




 

