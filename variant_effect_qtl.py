#!/usr/bin/env python3

"""
Count SnpEff variant effect types from a QTL-overlapping BED file.

Usage:
    python variant_effect_qtl.py <snps_in_qtl.bed> [output.txt]


import sys
import os
from collections import Counter


if len(sys.argv) < 2:
    print("Usage: python variant_effect_qtl.py <snps_in_qtl.bed> [output.txt]")
    sys.exit(1)

bed_file = sys.argv[1]
output_file = sys.argv[2] if len(sys.argv) > 2 else None

if not os.path.exists(bed_file):
    print(f"File not found: {bed_file}")
    sys.exit(1)

effect_counter = Counter()
line_count = 0
effect_index = 1  # SnpEff ANN format: A|effect|impact|gene|...

with open(bed_file, 'r') as f:
    for line in f:
        line_count += 1
        parts = line.strip().split('\t')

        if len(parts) < 4:
            continue

        ann_field = parts[3]
        annotations = ann_field.split(',')

        for ann in annotations:
            fields = ann.split('|')
            if len(fields) > effect_index:
                effect = fields[effect_index]
                effect_counter[effect] += 1

# Prepare output
output_lines = []
output_lines.append(f"Parsed {line_count} lines from {os.path.basename(bed_file)}\n")
output_lines.append("Variant Effect Type Counts:\n")

for effect, count in effect_counter.most_common():
    output_lines.append(f"{effect}\t{count}")

result_text = "\n".join(output_lines)

if output_file:
    with open(output_file, 'w') as out:
        out.write(result_text)
    print(f"Results written to {output_file}")
else:
    print(result_text)

print("\nDone.")
