#!/usr/bin/env python3

"""
Segregate SNPs into separate BED files based on QTL name (column 8).

Usage:
    python segregate_qtl.py <snps_in_qtl.bed> [output_directory]

Author: Your Name
Year: 2026
"""

import sys
import os
from collections import defaultdict


if len(sys.argv) < 2:
    print("Usage: python segregate_qtl.py <snps_in_qtl.bed> [output_directory]")
    sys.exit(1)

input_file = sys.argv[1]
output_dir = sys.argv[2] if len(sys.argv) > 2 else os.path.dirname(input_file)

if not os.path.exists(input_file):
    print("File not found:", input_file)
    sys.exit(1)

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

qtl_dict = defaultdict(list)
total_lines = 0
skipped_lines = 0

print(f"Reading: {input_file}")

with open(input_file, 'r') as bed:
    for line in bed:
        total_lines += 1
        parts = line.strip().split('\t')

        if len(parts) >= 8:
            qtl_name = parts[7]
            qtl_dict[qtl_name].append(line)
        else:
            skipped_lines += 1

print(f"Total lines read: {total_lines}")
print(f"Lines skipped (fewer than 8 columns): {skipped_lines}")
print(f"Unique QTLs found: {len(qtl_dict)}")

for qtl, lines in qtl_dict.items():
    safe_qtl = ''.join(c if c.isalnum() or c in ('_', '-') else '_' for c in qtl)
    output_path = os.path.join(output_dir, f"{safe_qtl}.bed")

    with open(output_path, 'w') as out:
        out.writelines(lines)

    print(f"Wrote {len(lines)} lines to: {output_path}")

print("Done.")

