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
laml=maf
library(maftools)
unique(laml@data$Tumor_Sample_Barcode)
getSampleSummary(laml) 
getGeneSummary(laml) 
getFields(laml)   

tmp=laml@data

laml@data$t_vaf = (laml@data$t_alt_count/(laml@data$t_alt_count+laml@data$t_ref_count))
mut=laml@data[,c("Hugo_Symbol","Chromosome",
                 "Start_Position","Tumor_Seq_Allele1","Tumor_Seq_Allele2","Variant_Classification",
                 "Tumor_Sample_Barcode","t_vaf")]
mut$pos=paste(mut$Chromosome,mut$Start_Position,sep=':')
g_f=as.data.frame(table(unique(mut[,c("Hugo_Symbol","Tumor_Sample_Barcode")])[,1]))
colnames(g_f)=c('SYMBOL','Freq')
library(clusterProfiler)
library(org.Hs.eg.db)
df <- bitr(g_f[g_f$Freq>1,1], fromType = "SYMBOL",
           toType = c( "ENTREZID" ,"GENENAME"),
           OrgDb = org.Hs.eg.db)
head(df)
df=merge(df,g_f,by='SYMBOL') 

tail(sort(table(mut$Hugo_Symbol)))
save(mut,file = 'metabric_mut_positions.Rdata')

png('plotmafSummary_metabric.png',res = 150,width = 1080,height = 1080)
plotmafSummary(maf = laml, rmOutlier = TRUE,showBarcodes = F,
               addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
dev.off()


## ---- fig.align='left',fig.height=5,fig.width=10, fig.align='left'-------
#We will draw oncoplots for top ten mutated genes.
png('oncoplot_top30_metabric.png',res = 150,width = 1080,height = 1080)
oncoplot(maf = laml, top = 30, fontSize = 12 ,showTumorSampleBarcodes = F )
dev.off()
 
if(F){
  lapply(unique(laml@data$Tumor_Sample_Barcode), function(x){ 
    x=unique(laml@data$Tumor_Sample_Barcode)[3]
    tmp=laml@data
    if(nrow(tmp[tmp$Tumor_Sample_Barcode==as.character(x),])>2){
      het = inferHeterogeneity(maf = laml, tsb = as.character(x),
                               vafCol = 't_vaf')
      print(het$clusterMeans) 
    } 
  }) 
  
}


#We will run mutExclusive on top 10 mutated genes. 
somaticInteractions(maf = laml, top = 25, pvalue = c(0.05, 0.1))
oncostrip(maf = laml, genes = c( 'TP53', 'CDH1'))
oncostrip(maf = laml, genes = c( 'TMEM191C', 'MUC3A')) 


