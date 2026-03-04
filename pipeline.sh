#!/usr/bin/env bash

# ============================================================
# GATK4 Variant Calling Pipeline
# Based on GenCore NYU GATK4 Workflow
# ============================================================

set -e
set -o pipefail

# -----------------------------
# Usage
# -----------------------------
if [ $# -lt 4 ]; then
  echo "Usage: bash pipeline.sh <sample_name> <reference.fa> <R1.fastq> <R2.fastq>"
  exit 1
fi

SAMPLE=$1
REF=$2
R1=$3
R2=$4

echo "Starting pipeline for sample: $SAMPLE"

# ============================================================
# 1. Alignment
# ============================================================

bwa mem \
  -K 100000000 \
  -Y \
  -R "@RG\tID:${SAMPLE}\tLB:${SAMPLE}\tPL:ILLUMINA\tPM:HISEQ\tSM:${SAMPLE}" \
  $REF \
  $R1 \
  $R2 \
  > ${SAMPLE}.aligned_reads.sam


# ============================================================
# 2. Mark Duplicates + Sorting (MarkDuplicatesSpark)
# ============================================================

gatk MarkDuplicatesSpark \
  -I ${SAMPLE}.aligned_reads.sam \
  -M ${SAMPLE}.dedup_metrics.txt \
  -O ${SAMPLE}.sorted_dedup_reads.bam


# ============================================================
# 3. Alignment & Insert Size Metrics
# ============================================================

picard CollectAlignmentSummaryMetrics \
  R=$REF \
  I=${SAMPLE}.sorted_dedup_reads.bam \
  O=${SAMPLE}.alignment_metrics.txt

picard CollectInsertSizeMetrics \
  INPUT=${SAMPLE}.sorted_dedup_reads.bam \
  OUTPUT=${SAMPLE}.insert_metrics.txt \
  HISTOGRAM_FILE=${SAMPLE}.insert_size_histogram.pdf

samtools depth -a ${SAMPLE}.sorted_dedup_reads.bam \
  > ${SAMPLE}.depth_out.txt


# ============================================================
# 4. Variant Calling
# ============================================================

gatk HaplotypeCaller \
  -R $REF \
  -I ${SAMPLE}.sorted_dedup_reads.bam \
  -O ${SAMPLE}.raw_variants.vcf


# ============================================================
# 5. Separate SNPs & Indels
# ============================================================

gatk SelectVariants \
  -R $REF \
  -V ${SAMPLE}.raw_variants.vcf \
  -select-type SNP \
  -O ${SAMPLE}.raw_snps.vcf

gatk SelectVariants \
  -R $REF \
  -V ${SAMPLE}.raw_variants.vcf \
  -select-type INDEL \
  -O ${SAMPLE}.raw_indels.vcf


# ============================================================
# 6. Hard Filtering
# ============================================================

gatk VariantFiltration \
  -R $REF \
  -V ${SAMPLE}.raw_snps.vcf \
  -O ${SAMPLE}.filtered_snps.vcf \
  -filter-name "QD_filter" -filter "QD < 2.0"

gatk VariantFiltration \
  -R $REF \
  -V ${SAMPLE}.raw_indels.vcf \
  -O ${SAMPLE}.filtered_indels.vcf \
  -filter-name "QD_filter" -filter "QD < 2.0" \
  -filter-name "FS_filter" -filter "FS > 200.0" \
  -filter-name "SOR_filter" -filter "SOR > 10.0"

  #--------------------------------------------------------
  #Annotate vcf
  #---------------------------------------------------------
  java -jar snpEff.jar -v \        
<snpeff_db> \
        filtered_snps_final.vcf > $filtered_snps_final.ann.vcf

echo "Pipeline completed for $SAMPLE"
