rm(list=ls())
# packages ====
# install.packages('readxl')
library(readxl)
library(ggplot2)
library(cowplot)
library(dplyr)
library(data.table)
library(stringr)

setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/")

# data extraction ====
excel_sheets("analysis/data_extraction.xlsx") # how many sheets does Excel file have
header <- read_excel("analysis/data_extraction.xlsx", sheet = "Header")

data1 <- read_excel("analysis/data_extraction.xlsx", sheet = "Matt", skip = 3, col_names = names(header))
data2 <- read_excel("analysis/data_extraction.xlsx", sheet = "Luke", skip = 3, col_names = names(header))
data3 <- read_excel("analysis/data_extraction.xlsx", sheet = "Charlie", skip = 3, col_names = names(header))
data4 <- read_excel("analysis/data_extraction.xlsx", sheet = "Kaitlin", skip = 3, col_names = names(header))
data5 <- read_excel("analysis/data_extraction.xlsx", sheet = "Nance", skip = 3, col_names = names(header))
data6 <- read_excel("analysis/data_extraction.xlsx", sheet = "Si", skip = 3, col_names = names(header))
data7 <- read_excel("analysis/data_extraction.xlsx", sheet = "TomB", skip = 3, col_names = names(header))
data8 <- read_excel("analysis/data_extraction.xlsx", sheet = "Steph", skip = 3, col_names = names(header))
data9 <- read_excel("analysis/data_extraction.xlsx", sheet = "Wenxin", skip = 3, col_names = names(header))

# total papers extracted
total_papers_extracted <- nlevels(as.factor(data1$ID)) + nlevels(as.factor(data2$ID)) + nlevels(as.factor(data3$ID)) + nlevels(as.factor(data4$ID)) + nlevels(as.factor(data5$ID)) + nlevels(as.factor(data6$ID)) + nlevels(as.factor(data7$ID)) + nlevels(as.factor(data8$ID)) + nlevels(as.factor(data9$ID))

# how many should there be
n_1 <- length(list.files("step3/Papers_for_data_extraction/1-26_Matt/"))
n_2 <- length(list.files("step3/Papers_for_data_extraction/27-52_Luke//"))
n_3 <- length(list.files("step3/Papers_for_data_extraction/53-78_Charlie//"))
n_4 <- length(list.files("step3/Papers_for_data_extraction/79-104_Kaitlin//"))
n_5 <- length(list.files("step3/Papers_for_data_extraction/105-116_Nance//"))
n_6 <- length(list.files("step3/Papers_for_data_extraction/117-130_Si///"))
n_7 <- length(list.files("step3/Papers_for_data_extraction/131-156_TomB//"))
n_8 <- length(list.files("step3/Papers_for_data_extraction/157-167_Steph//"))
n_9 <- length(list.files("step3/Papers_for_data_extraction/168-179_Wenxin//"))
total_papers <- n_1 + n_2 + n_3 + n_4 + n_5 + n_6 + n_7 + n_8 + n_9

n_a_matt <- n_1 - nlevels(as.factor(data1$ID))
n_b_luke <- n_2 - nlevels(as.factor(data2$ID))
n_c_charlie <- n_3 - nlevels(as.factor(data3$ID))
n_d_kaitlin <- n_4 - nlevels(as.factor(data4$ID))
n_e_nance <- n_5 - nlevels(as.factor(data5$ID))
n_f_si <- n_6 - nlevels(as.factor(data6$ID))
n_g_tomb <- n_7 - nlevels(as.factor(data7$ID))
n_h_steph <- n_8 - nlevels(as.factor(data8$ID))
n_i_wenxin <- n_9 - nlevels(as.factor(data9$ID))

# how many missing
total_papers_missing <- total_papers - total_papers_extracted

# papers removed
removed_unavailable <- 25
removed_conference_abstract_full_available <- 23
removed_duplicates <- 23
removed_duplicates_biorxiv <- 18
removed_incorrect_exposure <- 15
remvoed_commentary <- 8
removed_erratum <- 3
removed_not_MR <- 4
removed_conference_proceeding <- 1
remvoed_language <- 1
preprint_published_not_MR <- 1
removed <- removed_unavailable + removed_conference_abstract_full_available +
  removed_duplicates + removed_incorrect_exposure + remvoed_commentary +
  removed_erratum + removed_not_MR + removed_conference_proceeding +
  remvoed_language + preprint_published_not_MR

# full text screen
full_text_screen <- 277

# how many papers available
full_text_screen - removed

# rm unnecessary variables
rm(list=ls(pattern="n_"))
rm(total_papers_missing)  

# how many rows of data
results_rows <- nrow(data1) + nrow(data2) + nrow(data3) + nrow(data4) + nrow(data5) + 
  nrow(data6) + nrow(data7) + nrow(data8) + nrow(data9) 



# data ====
data <- rbind(data1, data2, data3, data4, data5, data6, data7, data8, data9)
## convert multiple chr columns to factors ====
cols <- c("ID", "biorxiv", "published", "title", "year", "journal", "doi", "author", "author_name", "author_email", "author_address",
          "hypothesis",
          "MR_design",
          "outcome", "outcome_info", "outcome_group", "outcome_study", 
          "exposure", "exposure_study", "exposure_independence", "exposure_pleiotropy", "exposure_pvalue", "exposure_palindrome", "exposure_proxy", "exposure_HWE",
          "IV_single", "IV_multiple", "IV_GRS", "n_SNP_og", "n_SNP_difference_reason",
          "power_calculation", "power_calculation_how",
          "MR_method", "IV_strength", 
          "analysis_software", "analysis_programme",
          "replication_independent", "replication_subsetting",
          "multiple_testing",
          "exposure_units", "outcome_units",
          "effect_estimate")
data[cols] <- lapply(data[cols], factor)
data$ID_analysis <- 1:nrow(data)
write.csv(data, "analysis/data.csv", row.names = FALSE)
## exposure descriptives ====
exposure_percentages <- data %>%
  dplyr::group_by(exposure) %>%
  dplyr::summarise(n = n()) %>%
  mutate(freq = n / sum(n))

d1 <- select(data, ID, exposure)
d1 <- as.data.table(d1)
d1 <- unique(d1)
d1 <- dcast(d1, exposure ~ ., fun.agg = function(x) sum(!is.na(x)), 
            value.var = "ID")
colnames(d1)[2] <- "N"

## outcome descriptives ====
outcome_percentages <- data %>%
  dplyr::group_by(outcome) %>%
  dplyr::summarise(n = n()) %>%
  mutate(freq = n / sum(n))

outcome_percentages_group <- data %>%
  dplyr::group_by(outcome_group) %>%
  dplyr::summarise(n = n()) %>%
  mutate(freq = n / sum(n))


save.image("analysis/001_data_extraction.RData")

