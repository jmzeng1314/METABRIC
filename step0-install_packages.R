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

# https://github.com/jmzeng1314/biotrainee 

## 强调，不是所有的R包都需要安装成功的。
## 强调，不是所有的R包都需要安装成功的。
## 强调，不是所有的R包都需要安装成功的。
## 强调，不是所有的R包都需要安装成功的。
## 失败就失败，大不了从头再来，卸载R语言，从新开始。

## 强调，中国大陆的粉丝务必注意下载镜像。
## 强调，管是什么电脑，都请务必安装好R及Rstudio哦
# 所有的软件都安装在c盘哦，然后系统用户名最好是不要用中文，写代码最怕中文字符串哦！
# 生信0基础第一步，下载R和Rstudio并且安装在自己的电脑上面。官网链接是 
# - R: https://mirrors.tuna.tsinghua.edu.cn/CRAN/
# - RStudio：https://www.rstudio.com/products/rstudio/download/#download 
# 如果你的网络不好，可以从我整理的网盘下载，链接：https://share.weiyun.com/5hW6VAA  密码：3fuhrm

Sys.setenv(R_MAX_NUM_DLLS=999)


options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
if(! require("devtools")) install.packages("devtools")
if(! require("reshape2")) install.packages("reshape2")
if(! require("ggplot2")) install.packages("ggplot2")
if(! require("pheatmap")) install.packages("pheatmap")
if(! require("ggfortify")) install.packages("ggfortify")
if(! require("stringr")) install.packages("stringr")
if(! require("survival")) install.packages("survival")
if(! require("survminer")) install.packages("survminer")
if(! require("lars")) install.packages("lars")
if(! require("glmnet")) install.packages("glmnet")
if(! require("tableone")) install.packages("tableone")


library(devtools) 
source("http://bioconductor.org/biocLite.R") 
## 如果你的网络实在是太差，试试看：
# install.packages("BiocInstaller",repos="http://bioconductor.org/packages/3.7/bioc")  
## 很可惜你在中国大陆，不得不承受这个痛苦。

options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/") 
library('BiocInstaller')
if(! require('edgeR')){
  
  biocLite(c('airway','DESeq2','edgeR','limma'))
}

if(! require("CLL")) biocLite("CLL")
if(! require("org.Hs.eg.db")) biocLite('org.Hs.eg.db')
library(BiocInstaller)
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/")
if(! require("maftools")) biocLite("maftools")




