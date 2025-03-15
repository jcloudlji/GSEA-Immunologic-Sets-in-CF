library(Seurat)
library(ggplot2)
library(patchwork)
library(dplyr)

# Load in the object 
object <- LoadSeuratRds(file = 'filtered_object.Rds')

# Obtain a sparse matrix of the counts per each gene (its structure is: Genes (rows) x Cells (columns))
counts_sparse <- object@assays$RNA@data

# Convert from sparse matrix to regular matrix
counts_matrix <- as.matrix(counts_sparse)

# Convert to a dataframe 
counts_df <- as.data.frame(counts_matrix)

names <- rownames(counts_df)

rownames(counts_df) <- seq_along(names)

add_column(counts_df, DESCRIPTION = NA, .after = "NAME")

write.table(counts_df, "counts.txt", na = "NA")