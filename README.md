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
All commands used in the filtration of variants are provided in `pipeline.sh`.
Command used to generate dendrogram plot for SNP data provided in 'dendrogram.R'
The commands used to overlap the QTL with annotated VCF, seggregate accordingly and the effect of the variants is given in 'segrgate_qtl.py' and variant_effect_qtl.py'
