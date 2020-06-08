library(dorothea)
library(dplyr)
library(tibble)
library(ggplot2)

args = commandArgs(trailingOnly = TRUE)
dorothea_file = args[1]
confidence_level = unlist(strsplit(args[2], ","))
minsize = as.numeric(args[3])
efilter = as.logical(args[4])
top_n = as.numeric(args[5])

# output files names
file_csv = paste0("dorothea_scores_",  paste0(confidence_level, collapse = ""), ".csv")
file_png = paste0("top_", as.character(top_n), ".png")

dorothea_matrix <- as.matrix(read.csv(dorothea_file, row.names = 1))

# Calculate dorothea
data(dorothea_hs, package = "dorothea")
regulons <- dorothea_hs %>%
  dplyr::filter(confidence %in% confidence_level)

tf_activities_stat <- dorothea::run_viper(dorothea_matrix, regulons,
                                          options =  list(minsize = minsize, eset.filter = efilter,
                                          cores = 1, verbose = FALSE, nes = TRUE))

write.csv(tf_activities_stat, file_csv, quote=F)

# figures

tf_activities_stat_top25 <- tf_activities_stat %>%
  as.data.frame() %>%
  rownames_to_column(var = "GeneID") %>%
  dplyr::rename(NES = "t") %>%
  dplyr::top_n(top_n, wt = abs(NES)) %>%
  dplyr::arrange(NES) %>%
  dplyr::mutate(GeneID = factor(GeneID))

topN <- ggplot(tf_activities_stat_top25,aes(x = reorder(GeneID, NES), y = NES)) +
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
  xlab("Transcription Factors")

ggsave(filename = file_png, plot = topN)
