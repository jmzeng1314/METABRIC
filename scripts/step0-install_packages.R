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
#清空当前工作空间变量  
options()$repos  
#查看当前工作空间默认的下载包路径
options()$BioC_mirror 
#查看使用BioCManager下载包的默认路径
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/") 
# 指定使用BioCManager下载的路径
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")) 
# 指定使用install.packages下载包的路径
options()$repos 
options()$BioC_mirror


# https://bioconductor.org/packages/release/bioc/html/GEOquery.html
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager") 
#判断是否存在BiocManger包，没有的话下载该包

#BiocManager::install("KEGG.db",ask = F,update = F)
#BiocManager::install(c("GSEABase","GSVA","clusterProfiler" ),ask = F,update = F)
#BiocManager::install(c("GEOquery","limma","impute" ),ask = F,update = F)
#BiocManager::install(c("genefu","org.Hs.eg.db","hgu133plus2.db" ),ask = F,update = F)

#判断是否存在这些包，不存在的话安装这些包
if(!require("KEGG.db")) BiocManager::install("KEGG.db",ask = F,update = F)
if(!require("GSEABase")) BiocManager::install("GSEABase",ask = F,update = F)
if(!require("GSVA")) BiocManager::install("GSVA",ask = F,update = F)
if(!require("clusterProfiler")) BiocManager::install("clusterProfiler",ask = F,update = F)
if(!require("GEOquery")) BiocManager::install("GEOquery",ask = F,update = F)
if(!require("limma")) BiocManager::install("limma",ask = F,update = F)
if(!require("impute")) BiocManager::install("impute",ask = F,update = F)
if(!require("genefu")) BiocManager::install("genefu",ask = F,update = F)
if(!require("org.Hs.eg.db")) BiocManager::install("org.Hs.eg.db",ask = F,update = F)
if(!require("hgu133plus2.db")) BiocManager::install("hgu133plus2.db",ask = F,update = F)
if(!require("ConsensusClusterPlus")) BiocManager::install("ConsensusClusterPlus",ask = F,update = F)


# 如果万一是 R3.4 版本之前的，请使用下面代码下载该项目所需要的包
# source("https://bioconductor.org/biocLite.R") 
# library('BiocInstaller') 
# options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/") 
# BiocInstaller::biocLite("GEOquery")
# BiocInstaller::biocLite(c("limma"))
# BiocInstaller::biocLite(c("impute"))

options()$repos

#install.packages('WGCNA')
#install.packages(c("FactoMineR", "factoextra"))
#install.packages(c("ggplot2", "pheatmap","ggpubr"))

#判断是否存在这些包，不存在的话安装这些包
if(!require("WGCNA")) install.packages("WGCNA",update = F,ask = F)
if(!require("FactoMineR")) install.packages("FactoMineR",update = F,ask = F)
if(!require("factoextra")) install.packages("factoextra",update = F,ask = F)
if(!require("ggplot2")) install.packages("ggplot2",update = F,ask = F)
if(!require("pheatmap")) install.packages("pheatmap",update = F,ask = F)
if(!require("ggpubr")) install.packages("ggpubr",update = F,ask = F)

library("FactoMineR")
library("factoextra")

library(GSEABase)
library(GSVA)
library(clusterProfiler)
library(genefu)
library(ggplot2)
library(ggpubr)
library(hgu133plus2.db)
library(limma)
library(org.Hs.eg.db)
library(pheatmap)





 