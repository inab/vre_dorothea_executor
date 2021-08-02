if (!require("librarian"))
  install.packages("librarian")
librarian::shelf(dplyr, tibble, ggplot2, viper, dorothea, cran_repo = "https://cloud.r-project.org/")

message("STARTING DoRothEA PROCESS")

message("Reading input arguments:")

args <- commandArgs(trailingOnly = TRUE)
dorothea_file <- args[1]
confidence_level <- unlist(strsplit(args[2], " "))
minsize <- as.numeric(args[3])
method <- args[4]

message(paste("\t- expression matrix:", dorothea_file, sep = " "))
message(paste("\t- confidence level:", args[2], sep = " "))
message(paste("\t- minimum size:", minsize, sep = " "))
message(paste("\t- method:", method, sep = " "))

message("Calculating DoRothEA matrix")

dorothea_data <- as.matrix(read.csv(dorothea_file, row.names = 1))

if (ncol(dorothea_data) == 1 & method != "none") {
  message("Changing method to none, as there is only one condition/sample")
  method <- "none"
}

file_csv <- paste0("dorothea_scores_",
                   paste0(confidence_level, collapse = ""), ".csv")

message("Loading DoRothEA regulons")

data(dorothea_hs, package = "dorothea")
regulons <- dorothea_hs %>%
  dplyr::filter(confidence %in% confidence_level)

message("RUNNING DoRothEA")

tf_activities_stat <- dorothea::run_viper(
  dorothea_data,
  regulons,
  options = list(
    minsize = minsize,
    method = method,
    eset.filter = FALSE,
    cores = 1,
    verbose = FALSE,
    nes = TRUE
  )
)

colnames(tf_activities_stat) <- colnames(dorothea_data)

write.csv(tf_activities_stat, file_csv, quote = F)

message(paste(
  "DoRothEA ended successfully; see results",
  normalizePath(file_csv),
  sep = " "
))

message("FINISHING DoRothEA PROCESS")