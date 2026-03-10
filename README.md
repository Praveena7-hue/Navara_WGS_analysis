# Navara_WGS_analysis
Reproducible WGS analysis workflow for rice including alignment, variant calling (GATK4), functional annotation (SnpEff), and genomic overlap of SNPs with curated QTL intervals.
## Objectives
- Perform SNPs and INDELs calling from WGS data
- Functionally annotate variants
- Identify SNPs located within reported QTL genomic intervals
- Provide reproducible commands and software versions used in the study
- ## Software Used
- GATK4
- BWA
- SnpEff
Exact versions are provided in `software_versions.txt`.

## Reproducibility
All commands used for variant filtration are provided in pipeline.sh.
The command used to generate the dendrogram plot from SNP data is available in dendrogram.R.
The script qtl_overlap.sh was used to overlap the annotated VCF file with QTL regions.
The scripts segregate_qtl.py and variant_effect_qtl.py were used to segregate QTL-associated variants and to determine the effects of these variants, respectively.
