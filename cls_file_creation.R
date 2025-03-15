# Load necessary libraries
 library(Seurat)

# Load the Seurat object from the file
object <- LoadSeuratRds("filtered_object.Rds")

# Check if 'type' column exists in metadata
if (!"type" %in% colnames(object@meta.data)) {
  stop("'type' column not found in Seurat object metadata")
}

# Extract the metadata column 'type' which contains the disease status
sample_types <- object@meta.data$type

# Check if the order of samples in the Seurat object matches the order in counts_df
if (!identical(colnames(object), colnames(counts_df))) {
  stop("The order of samples in the Seurat object does not match the order in counts_df.")
}

# Create the .cls file content
num_samples <- length(sample_types)
num_classes <- length(unique(sample_types))
class_labels <- unique(sample_types)

# First line: Number of samples, number of classes, and a placeholder (1)
first_line <- paste(num_samples, num_classes, 1, sep = " ")

# Second line: Class labels prefixed with a '#'
second_line <- paste("#", paste(class_labels, collapse = " "))

# Third line: Sample labels in the order of the Seurat object
third_line <- paste(sample_types, collapse = " ")

# Combine the lines into the .cls file content
cls_content <- paste(first_line, second_line, third_line, sep = "\n")

# Check cls_content before writing it to file
print(cls_content)

# Write the .cls file
writeLines(cls_content, "output_file.cls")