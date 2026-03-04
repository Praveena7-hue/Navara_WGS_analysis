from collections import Counter
import os

# File path to your .bed file
bed_file = "path/filename"
effect_index = 1  # In A|effect|MODIFIER|..., the effect is at index 1

if not os.path.exists(bed_file):
    print(f"File not found: {bed_file}")
    exit()

effect_counter = Counter()
line_count = 0

with open(bed_file, 'r') as f:
    for line in f:
        line_count += 1
        parts = line.strip().split('\t')
        if len(parts) >= 4:
            annotations = parts[3].split(',')
            for ann in annotations:
                fields = ann.split('|')
                if len(fields) > effect_index:
                    effect = fields[effect_index]
                    effect_counter[effect] += 1

# Print results
print(f" Parsed {line_count} lines from {os.path.basename(bed_file)}")
print(f"\n Variant Effect Type Counts:\n")
for effect, count in effect_counter.most_common():
    print(f"  - {effect}: {count}")

print("\n Done.")
