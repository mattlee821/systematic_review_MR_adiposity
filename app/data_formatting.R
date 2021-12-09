library(dplyr)
# data extraction data ====
data <- read.csv("analysis/002_data.csv")

d1 <- select(data, c("author",
                     "year",
                     "title",
                     "exposure",
                     "outcome","outcome_info","outcome_group",
                     "MR_design","MR_method",
                     "effect_estimate", "estimate"))
write.csv(d1, "app/formatted_data_extraction.csv", row.names = FALSE)


# meta analysis data ====
data <- read.csv("../analysis/meta_analysis/results/meta_analysis_results.csv")
d1 <- select(data, c("exposure","exposure_units", 
                     "outcome", "outcome_units",
                     "re_effect","re_lower","re_upper","re_p",
                     "n"))
d1$exposure <- paste0(d1$exposure, " (", d1$exposure_units, ")")
d1$outcome <- paste0(d1$outcome, " (", d1$outcome_units, ")")
d1$outcome <- stringr::str_replace(d1$outcome, '\\(Case\\/control\\)', '')
d1 <- select(d1, c("exposure","outcome", 
                     "re_effect","re_lower","re_upper","re_p",
                     "n"))
d1 <- d1[order(d1$outcome),]
d1$re_effect <- round(d1$re_effect,2)
d1$re_lower <- round(d1$re_lower,2)
d1$re_upper <- round(d1$re_upper,2)
d1$re_p <- signif(d1$re_p,2)
write.csv(d1, "formatted_meta_analysis_results.csv", row.names = FALSE)
