rm(list=ls())

# Packages ====
library(dplyr)
library(data.table)
library(kableExtra)

# data ====
load("../systematic_review_MR_adiposity/analysis/001_data_extraction.RData")

# exposure percentages ====
exposure_percentages$freq <- exposure_percentages$freq * 100
exposure_percentages$exposure <- gsub("body fat percentage", "BF", exposure_percentages$exposure)
exposure_percentages$freq <- round(exposure_percentages$freq,2)
colnames(exposure_percentages) <- c("Exposure", "N", "%")
exposure_percentages <- exposure_percentages[order(-exposure_percentages$`%`),]
write.table(exposure_percentages, "tables/exposure_percentages.txt", 
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
knitr::kable(
  (exposure_percentages[order(-exposure_percentages$n),]),
  longtable = T, booktabs = T,
  caption = 'Number and frequency of exposures used across all 2,214 Mendelian randomization analyses', row.names = F,
  digits = 2, format = "latex", 
  col.names = c("Exposure", "N", "%")) %>%
  kable_styling(latex_options = c("striped", "HOLD_position", "repeat_header"), position = "center") %>%
  kableExtra::footnote(general = "BMI = body mass index; WHR = waist hip ratio; WHRadjBMI = WHR adjusted for BMI; WC = waist circumference; WCadjBMI = WC adjusted for BMI; HC = hip circumference; HCadjBMI = HC adjusted for BMI; BF = body fat percentage.",
                       threeparttable = T, general_title = "", footnote_as_chunk = T)

# outcome percentages ====
outcome_percentages$freq <- outcome_percentages$freq * 100
outcome_percentages$freq <- round(outcome_percentages$freq,2)
colnames(outcome_percentages) <- c("Exposure", "N", "%")
outcome_percentages <- outcome_percentages[order(-outcome_percentages$`%`),]
write.table(outcome_percentages, "tables/outcome_percentages.txt", 
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
knitr::kable(
  head(outcome_percentages[order(-outcome_percentages$n),], 10),
  longtable = F, booktabs = T,
  caption = 'Number and frequency of the 10 most used outcomes across all 2214 MR analyses', row.names = F,
  digits = 2, format = "latex",
  col.names = c("Outcome", "N", "%")) %>%
  kable_styling(latex_options = c("striped", "HOLD_position", "repeat_header"), position = "center")

# outcome_percentages_group ====
outcome_percentages_group$freq <- outcome_percentages_group$freq * 100
outcome_percentages_group$freq <- round(outcome_percentages_group$freq,2)
colnames(outcome_percentages_group) <- c("Exposure", "N", "%")
outcome_percentages_group <- outcome_percentages_group[order(-outcome_percentages_group$`%`),]
write.table(outcome_percentages_group, "tables/outcome_percentages_group.txt", 
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
knitr::kable(
  (outcome_percentages_group[order(-outcome_percentages_group$n),]),
  longtable = F, booktabs = T,
  caption = 'Number and frequency of outcomes within each outcome category across all 2214 Mendelian randomization analyses', row.names = F,
  digits = 2, format = "latex",
  col.names = c("Group", "N", "%")) %>%
  kable_styling(latex_options = c("striped", "HOLD_position", "repeat_header"), position = "center") %>%
  kableExtra::footnote(general = "Outcome groups were assigned based on prior biological knowledge and aimed to collapse the large number of outcomes. This could be achieved differently for some outcomes, for example smoking could go in a 'respiratory' group or a 'behavioural' group. Where there were few outcomes to make a group, they were grouped into an 'other' group. This will include outcomes such as mortality, disease counts, epigenetic markers, etc.",
                       threeparttable = T, general_title = "", footnote_as_chunk = T)

# ====
studies <- read.table("../systematic_review_MR_adiposity/analysis/meta_analysis/results/study_freq.txt", header = T, sep = "\t")
knitr::kable(
  (studies[order(-studies$freq),]),
  longtable = F, booktabs = T,
  caption = 'Number of times an article was used in meta-analyses', row.names = F,
  digits = 2, format = "markdown",
  col.names = c("Article", "N")) %>%
  kable_styling(latex_options = c("striped", "HOLD_position", "repeat_header"), position = "center", font_size = 8)
