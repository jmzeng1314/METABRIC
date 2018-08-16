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

