import pandas as pd

# Load overlap file
df = pd.read_csv("overlapping_variants_qtl.bed", sep="\t", header=None)

# Rename columns
df.columns = ["chr", "start", "end", "var_id",
              "qtl_chr", "qtl_start", "qtl_end", "qtl_name"]

# Filter Yield QTL
yield_qtl = df[df["qtl_name"] == "QTL_yield"]

# Save output
yield_qtl.to_csv("yield_qtl_variants.bed", sep="\t", index=False)

print("Yield QTL variants extracted.")