# 通过重分析METABRIC数据来理解乳腺癌的分子机制

数据来源于：http://www.cbioportal.org/data_sets.jsp 

下载属于METABRIC的数据集：[Breast Cancer (METABRIC, Nature 2012 & Nat Commun 2016)](http://www.cbioportal.org/study?id=brca_metabric#summary) 

也可以使用cbioportal的在线浏览器来了解基本项目信息：http://www.cbioportal.org/study?id=brca_metabric#summary 

### 下载的压缩包内容：

小文件如下：

```
─ [ 646]  brca_metabric
│   ├── [ 410]  LICENSE
│   ├── [ 136]  case_lists
│   │   ├── [ 20K]  cases_nat_comm_2016.txt
│   │   └── [ 16K]  cases_nature_2012.txt
│   ├── [265K]  data_clinical_patient.txt
│   ├── [102K]  data_clinical_sample.txt
│   ├── [116K]  data_gene_matrix.txt
│   ├── [1.2K]  data_gene_panel.txt
│   ├── [3.8M]  data_mutations_extended.txt
│   ├── [ 512]  meta_CNA.txt
│   ├── [ 143]  meta_clinical_patient.txt
│   ├── [ 141]  meta_clinical_sample.txt
│   ├── [ 322]  meta_expression.txt
│   ├── [ 146]  meta_gene_matrix.txt
│   ├── [ 292]  meta_mutations_extended.txt
│   ├── [ 380]  meta_study.txt
│   ├── [ 55K]  validation_error_file.txt
│   └── [ 42K]  validation_report.html
```

里面值得注意的就是那个  3.8M的文件：`  data_mutations_extended.txt`

还有一个 100M的 文件是 `data_CNA.txt` 和一个 500M的文件 `data_expression.txt`

### 记录一下GitHub小技巧

主要是是删除本地文件后提交到GitHub上面。

```
rm tmp.pdf 
git add -A 
git commit -a -m 'rm tmp'
git push -u origin master
```





### 检查全局突变情况

整理文章的突变信息，然后使用maftools即可出图，如下：

![](figures/oncoplot_top30_metabric.png)

可以看到，突变频率比较高的基因是： PIK3CA,TP53,MUC16,AHNAK2,SYNE1,KMT2C,GATA3,MAP3K1,CDH1 , 接下来就可以对这些基因进行针对性分析。

### 基因突变与否分组进行生存分析

取突变频率比较高的基因做生存分析，发现PIK3CA的确是突变频率非常高，但是与生存无关，如下所示：

![](figures/survival_based_on_PIK3CA_mutation.png)

然后就查阅文献发现有人研究了这一点：

发表于 Breast Cancer Research 2017文章是：[*PIK3CA* mutations are common in lobular carcinoma *in situ,* but are not a biomarker of progression](https://doi.org/10.1186/s13058-016-0789-y)  