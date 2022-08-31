library(dplyr)
library(stringr)

# data extraction data ====
data <- read.csv("../analysis/002_data_extraction_formatted.csv")
data$exposure <- str_replace(data$exposure, "fat-free mass", "fat free mass")
data$exposure <- str_replace(data$exposure, "body non-fat mass", "non-fat mass")
data$exposure <- str_replace(data$exposure, "Obesity class 1", "obesity")
data$exposure <- as.factor(data$exposure)
a <- levels(data$exposure)
data$exposure <- factor(data$exposure, levels=c(sort(a, decreasing=F)))
levels(data$exposure)

data$outcome <- str_replace(data$outcome, "alzheimer’s disease", "Alzheimer's disease")
data$outcome <- str_replace(data$outcome, "alzheimer's disease", "Alzheimer's disease")
data$outcome <- str_replace(data$outcome, "Alzheimers disease", "Alzheimer's disease")
data$outcome <- str_replace(data$outcome, "apoA-IV", "apoA4")
data$outcome <- str_replace(data$outcome, "emplyment", "employment")
data$outcome <- str_replace(data$outcome, "parkinson's disease", "Parkinson’s disease")
data$outcome <- str_replace(data$outcome, "parkinson’s disease", "Parkinson’s disease")
data$outcome <- str_replace(data$outcome, "vitamin D", "25(OH)D")
data$outcome <- as.factor(data$outcome)
a <- levels(data$outcome)
data$outcome <- factor(data$outcome, levels=c(sort(a, decreasing=F)))
levels(data$outcome)

data$outcome_group <- as.factor(data$outcome_group)
a <- levels(data$outcome_group)
data$outcome_group <- factor(data$outcome_group, levels=c(sort(a[a!="other"], decreasing=F), "other"))
levels(data$outcome_group)

table(data$effect_estimate)
data$effect_estimate <- str_replace(data$effect_estimate, "Not clear", "Not discussed")
data$effect_estimate <- str_replace(data$effect_estimate, "Not clear", "Not discussed")
data$effect_estimate <- str_replace(data$effect_estimate, "Adjusted RR", "RR (adjusted)")
data$effect_estimate <- str_replace(data$effect_estimate, "beta", "Beta")
data$effect_estimate <- str_replace(data$effect_estimate, "Change in mm Hg per increase in 10% BMI", "Beta")
data$effect_estimate <- str_replace(data$effect_estimate, "Coefficient", "Beta")
data$effect_estimate <- str_replace(data$effect_estimate, "Hazard ratio", "HR")
data$effect_estimate <- str_replace(data$effect_estimate, "Hazard Ratio", "HR")
data$effect_estimate <- str_replace(data$effect_estimate, "Difference in mean", "Mean difference")
data$effect_estimate <- str_replace(data$effect_estimate, "Odds ratio", "OR")
data$effect_estimate <- str_replace(data$effect_estimate, "OR compared with reference of 0-4 alleles", "OR compared to reference group")
data$effect_estimate <- str_replace(data$effect_estimate, "OR per 1kg/m2 increase in BMI", "OR")
data$effect_estimate <- str_replace(data$effect_estimate, "OR, adjusted for birth weight, smoking and education", "OR")

table(data$estimate)
data$estimate <- str_replace(data$estimate, "Not clear", "Not discussed")
data$estimate <- str_replace(data$estimate, "Not reported for meta-analysis between FHS batches", "Not discussed")
data$estimate <- str_replace(data$estimate, "effect of the GRS on BMI increases slowly from age 25 to 50 years, followed by a slow decrease", "Not discussed")
data$estimate <- str_replace(data$estimate, "subjects with more effect alleles have higher fitted BMI values across their lifetime", "Not discussed")
data$estimate <- str_replace(data$estimate, "Reference", "Reference group")

data <- data[order(data$outcome, data$exposure),]

d1 <- select(data, c("author",
                     "year",
                     "title",
                     "exposure",
                     "outcome","outcome_info","outcome_group",
                     "MR_design","MR_method",
                     "effect_estimate", "estimate"))
write.csv(d1, "formatted_data_extraction.csv", row.names = F)

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
