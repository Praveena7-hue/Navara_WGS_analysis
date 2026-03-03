############################################################
# Dendrogram Construction using SNPRelate
# Based on biallelic SNPs only
############################################################

library(SNPRelate)

# -----------------------------
# 1. Convert VCF to GDS
# -----------------------------
snpgdsVCF2GDS(
  vcf.fn = "merged.vcf",
  out.fn = "merged.gds",
  method = "biallelic.only",
  ignore.chr.prefix = "chr"
)

# -----------------------------
# 2. Open GDS file
# -----------------------------
genofile <- snpgdsOpen("merged.gds")

# -----------------------------
# 3. LD pruning (Recommended for clustering)
# -----------------------------
set.seed(1000)

snpset <- snpgdsLDpruning(
  genofile,
  ld.threshold = 0.2,
  autosome.only = FALSE
)

snpset.id <- unlist(snpset)

# -----------------------------
# 4. IBS Distance Matrix
# -----------------------------
ibs <- snpgdsIBS(
  genofile,
  snp.id = snpset.id,
  num.thread = 4
)

# -----------------------------
# 5. Hierarchical Clustering
# -----------------------------
hc <- hclust(
  as.dist(1 - ibs$ibs),
  method = "average"
)

# -----------------------------
# 6. Plot Dendrogram
# -----------------------------
pdf("Navara_Dendrogram.pdf", width = 10, height = 8)

plot(
  hc,
  main = "Dendrogram of Navara and Red Rice Varieties",
  xlab = "",
  sub = "",
  cex = 0.6
)

dev.off()

# -----------------------------
# 7. Close GDS file
# -----------------------------
snpgdsClose(genofile)
