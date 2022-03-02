###########################################################################################
# Script for the heatmap for DESEq2 results
#
# Generated by: Dilek Cansu GURER, Dec 2021
# Usage: Rscript heatmap.R
###########################################################################################

# Drawing heat map of 1000 first DEGs.
# Convert all samples to rlog
ddsMat_rlog <- rlog(ddsMat, blind = FALSE)

# Gather 1000 significant genes and make matrix
mat <- assay(ddsMat_rlog[row.names(results_sig)])[1:1000, ]

# Choose which column variables you want to annotate the columns by.
annotation_col = data.frame(
  Group = factor(colData(ddsMat_rlog)$condition), 
  Replicate = factor(colData(ddsMat_rlog)$Replicate),
  row.names = colData(ddsMat_rlog)$sampleid
)

# Specify colors you want to annotate the columns by.
ann_colors = list(
  Group = c(A_DMSO = "lightblue", B_CP = "darkorange"),
  Replicate = c(Rep1 = "darkred", Rep2 = "forestgreen", Rep3 = "yellow")
)

# Make Heatmap with pheatmap function
plot <- pheatmap(mat = mat, 
                 color = colorRampPalette(brewer.pal(9, "RdBu"))(255), 
                 scale = "row", # Scale genes to Z-score (how many standard deviations)
                 annotation_col = annotation_col, # Add multiple annotations to the samples
                 annotation_colors = ann_colors,# Change the default colors of the annotations
                 fontsize = 6.5, # Make fonts smaller
                 cellwidth = 55, # Make the cells wider
                 show_colnames = F,
                 show_rownames = F)

# Save heatmap as .tiff file with 300 dpi resolution.
tiff("heatmap_300_RdBu.tiff", width = 3200, height = 2000, units = "px", res = 300)
print(plot)
dev.off()