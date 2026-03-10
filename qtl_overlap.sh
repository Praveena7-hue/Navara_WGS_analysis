#!/usr/bin/env bash

# QTL overlap using bedtools

bedtools intersect \
  -a variants.bed \
  -b qtl_regions.bed \
  -wa -wb \
  > overlapping_variants_qtl.bed

echo "QTL overlap completed."
