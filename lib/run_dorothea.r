library(dorothea)
library(dplyr)
library(tibble)
library(ggplot2)
library(viper)

message("STARTING DOROTHEA PROCESS")

message("Reading input arguments:")
args = commandArgs(trailingOnly = TRUE)
dorothea_file = args[1]
confidence_level = unlist(strsplit(args[2], " "))
minsize = as.numeric(args[3])
method = args[4]

message(dorothea_file)
message(confidence_level)
message(minsize)
message(method)

#file =  unlist(strsplit(dorothea_file, split = "/"))
#file = file[length(file)]
#message(file)

message("Creating output file")
file_csv = paste0("dorothea_scores_",  paste0(confidence_level, collapse = ""), ".csv")
message(file_csv)
message(method)
message("Calculating dorothea matrix")

dorothea_matrix <- as.matrix(read.csv(dorothea_file, row.names = 1))
if ( ncol(dorothea_matrix) == 1 & method != "none" ){
  message("Changing method to none, as there is only one condition/sample")
  method = "none"
}

#message(head(dorothea_matrix))
#message(class(dorothea_matrix[,1]))
#dorothea_matrix = cbind(dorothea_matrix, dorothea_matrix[,1]*1.5)
#colnames(dorothea_matrix) = c("t", "m")
#write.csv(dorothea_matrix, "data_test.csv", quote=F)
message("Loading dorothea regulons")
data(dorothea_hs, package = "dorothea")
regulons <- dorothea_hs %>%
  dplyr::filter(confidence %in% confidence_level)

message("Running dorothea")
tf_activities_stat <- dorothea::run_viper(dorothea_matrix, regulons,
                                          options =  list(minsize = minsize,
                                            method = method,
                                            eset.filter = FALSE, cores = 1,
                                            verbose = FALSE, nes = TRUE))

colnames(tf_activities_stat) = colnames(dorothea_matrix)
message("Writing output file")
write.csv(tf_activities_stat, file_csv, quote=F)

## FIGURES ##
#conditions = colnames(tf_activities_stat)
#message(conditions)
# Top N TFs based on the normalized enrichment scores in a bar plot per sample
#message("Creating bar plot for all conditions")
#tf_activities_stat <- tf_activities_stat %>%
#  as.data.frame() %>%
#  rownames_to_column(var = "GeneID")

# for(i in conditions){
#
#   aux <- tf_activities_stat[, c("GeneID", i)] %>%
#     dplyr::rename(NES = i) %>%
#     dplyr::top_n(topN, wt = abs(NES)) %>%
#     dplyr::arrange(NES) %>%
#     dplyr::mutate(GeneID = factor(GeneID))
#
#   topN_barplot <- ggplot(aux, aes(x = reorder(GeneID, NES), y = NES)) +
#     geom_bar(aes(fill = NES), stat = "identity") +
#     scale_fill_gradient2(low = "darkblue", high = "indianred",
#                          mid = "whitesmoke", midpoint = 0) +
#     theme_minimal() +
#     theme(axis.title = element_text(face = "bold", size = 12),
#           axis.text.x =
#             element_text(angle = 45, hjust = 1, size =10, face= "bold"),
#           axis.text.y = element_text(size =10, face= "bold"),
#           panel.grid.major = element_blank(),
#           panel.grid.minor = element_blank()) +
#     xlab("Transcription Factors") +
#     ylab("Normalized Enrichment scores (NES)")
#
#   dir.create("img", recursive = T)
#   file_png = paste0("img/top_", as.character(topN), "_", i, ".png")
#   ggsave(filename = file_png, plot = topN_barplot)
#
# }

message("FINISHING DOROTHEA PROCESS")
