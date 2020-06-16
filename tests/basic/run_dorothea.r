library(dorothea)
library(dplyr)
library(tibble)
library(ggplot2)

writeLines("Reading arguments")
args = commandArgs(trailingOnly = TRUE)
dorothea_file = args[1]
confidence_level = unlist(strsplit(args[2], ","))
minsize = as.numeric(args[3])
topN = as.numeric(args[4])
method = "scale"

if (dorothea_file == "dorothea_example.csv"){ method = "none" }

writeLines("Creating output file names")
dir.create("results", recursive = T)
file_csv = paste0("dorothea_scores_",  paste0(confidence_level, collapse = ""), ".csv")

writeLines("Reading files")
dorothea_matrix <- as.matrix(read.csv(dorothea_file, row.names = 1))

writeLines("Calculating dorothea")
data(dorothea_hs, package = "dorothea")
regulons <- dorothea_hs %>%
  dplyr::filter(confidence %in% confidence_level)

tf_activities_stat <- dorothea::run_viper(dorothea_matrix, regulons,
                                          options =  list(minsize = minsize,
                                            method = method,
                                            eset.filter = FALSE, cores = 1,
                                            verbose = FALSE, nes = TRUE))

write.csv(tf_activities_stat, file_csv, quote=F)

## FIGURES ##
conditions = colnames(tf_activities_stat)

# Top N TFs based on the normalized enrichment scores in a bar plot per sample
writeLines("Creating bar plot for all conditions")
tf_activities_stat <- tf_activities_stat %>%
  as.data.frame() %>%
  rownames_to_column(var = "GeneID")

for(i in condition){

  aux <- tf_activities_stat[, c("GeneID", i)] %>%
    dplyr::rename(NES = "t") %>%
    dplyr::top_n(topN, wt = abs(NES)) %>%
    dplyr::arrange(NES) %>%
    dplyr::mutate(GeneID = factor(GeneID))

  topN_barplot <- ggplot(aux, aes(x = reorder(GeneID, NES), y = NES)) +
    geom_bar(aes(fill = NES), stat = "identity") +
    scale_fill_gradient2(low = "darkblue", high = "indianred",
                         mid = "whitesmoke", midpoint = 0) +
    theme_minimal() +
    theme(axis.title = element_text(face = "bold", size = 12),
          axis.text.x =
            element_text(angle = 45, hjust = 1, size =10, face= "bold"),
          axis.text.y = element_text(size =10, face= "bold"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    xlab("Transcription Factors") +
    ylab("Normalized Enrichment scores (NES)")

  dir.create("img", recursive = T)
  file_png = paste0("img/top_", as.character(top_n), "_", i, ".png"))
  ggsave(filename = file_png, plot = topN_barplot)

}

writeLines("Finished")
