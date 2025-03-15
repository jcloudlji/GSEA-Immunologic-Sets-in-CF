library(Seurat)
library(ggplot2)
library(patchwork)
library(dplyr)
library(MuDataSeurat)

object <- LoadSeuratRds(file = 'object.Rds')

object <- subset(object, subset = lab == "UCLA")

# Normalize counts
NormalizeData(object)

# Get the normalized (or log-normalized) expression data from your assay, e.g. "RNA"
expr <- GetAssayData(object, slot = "data")

# Get the group (type) for each cell from the metadata
groups <- object@meta.data$type

# Calculate average expression for each gene in the "CO" group
avg_expr_CO <- rowMeans(expr[, groups == "CO", drop = FALSE], na.rm = TRUE)
# Calculate average expression for each gene in the "CF" group
avg_expr_CF <- rowMeans(expr[, groups == "CF", drop = FALSE], na.rm = TRUE)

# Identify genes where the difference in average expression is essentially zero
tolerance <- 1e-6
keep_genes <- abs(avg_expr_CO - avg_expr_CF) > tolerance

object_filtered <- subset(object, features = names(keep_genes)[keep_genes])

SaveSeuratRds(object_filtered, file = 'filtered_object.Rds')
