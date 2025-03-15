import pandas as pd
import numpy as np
import csv

counts = pd.read_csv("counts.txt", sep = " ")
counts_fixed = counts.insert(1, "DESCRIPTION", np.nan)
counts.to_csv('fixed_counts.txt', sep='\t', index=False)

gmt_file = 'c7.all.v2024.1.Hs.symbols.gmt.txt'

# Read file as a list of rows to identify inconsistencies
with open(gmt_file, 'r') as file:
    reader = csv.reader(file, delimiter='\t')
    rows = [row for row in reader]

# Convert to DataFrame
gmt_df = pd.DataFrame(rows)
expression_genes = set(counts['NAME'])
gmt_genes = set(gmt_df.iloc[:, 2:].stack()) 

# Find missing genes in the expression data
missing_genes = gmt_genes - expression_genes

filtered_gene_data = gmt_df.iloc[:, 2:].applymap(lambda gene: gene if gene not in missing_genes else None)

# Step 3: Shift non-NaN values upwards in each row to fill gaps
filtered_gene_data = filtered_gene_data.apply(lambda row: row.dropna().reset_index(drop=True), axis=1)

# Step 4: Sort each row alphabetically
filtered_gene_data = filtered_gene_data.apply(lambda row: row.sort_values().reset_index(drop=True), axis=1)

cleaned_gmt_df = pd.concat([gmt_df.iloc[:, :2], filtered_gene_data], axis=1)

cleaned_gmt_df.to_csv('filtered.gmt', sep='\t', index=False, header=False, na_rep='')