rm(list=ls())
# packages ====
library(meta)
library(dplyr)
library(grid)
library(plyr)

# load all of the data frames ====
setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/analysis/meta_analysis/data_for_analysis/")
list_files <- list.files("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/analysis/meta_analysis/data_for_analysis/")
list <- list()
for (i in 1:length(list_files)){
  list[[i]] <- (read.csv(list_files[i], header=T))
}
names(list) <- list_files
data <- ldply(list, data.frame)
a <- select(data, .id, author, year, doi, MR_design, exposure, exposure_definition, outcome, outcome_info, exposure_units, outcome_units, effect_estimate, estimate, se, ci_lower, ci_upper, p, exposure_n_current, exposure_n_og, outcome_n_case_current, outcome_n_control_current, ID_analysis)
a$.id2 <- paste(a$exposure, " on ", a$outcome, sep ="")

# organise units ====
## exposure units
a$exposure_units <- gsub("kg/m2", "SD", a$exposure_units)
a$exposure_units <- gsub("1SD", "SD", a$exposure_units)
a$exposure_units <- gsub("SD inverse rank normal transform", "SD", a$exposure_units)
a$exposure_units[c(46, 48, 53, 60)] <- "SD"

## outcome units
a$outcome_units <- gsub("case/control", "Case/control", a$outcome_units)
a$outcome_units[1] <- "Case/control"
a$outcome_units <- gsub("mmHg", "mm/Hg", a$outcome_units)
a$outcome_units <- gsub("mm Hg", "mm/Hg", a$outcome_units)
a$outcome_units <- gsub("mmhg", "mm/Hg", a$outcome_units)
a$outcome_units[c(39,40)] <- "Case/control"
a$outcome_units[43] <- "mmol/L"
a$outcome_units <- gsub("mmol/l", "mmol/L", a$outcome_units)
a$outcome_units[c(53,60)] <- "SD"

## effect estimate
a$effect_estimate <- gsub("Odds ratio", "OR", a$effect_estimate)
a$effect_estimate <- gsub("Beta", "beta", a$effect_estimate)
a$effect_estimate[20] <- "OR"
a$effect_estimate[43] <- "beta"

# format estimates ====
b <- subset(a, effect_estimate == "OR")
b$formatted_estimate <- log(b$estimate)
b$formatted_ci_lower <- log(b$ci_lower)
b$formatted_ci_upper <- log(b$ci_upper)
c <- subset(a, effect_estimate == "beta")
d <- c[!is.na(c$se), ]
c <- c[is.na(c$se), ]
d$ci_lower <- d$estimate - 1.96 * d$se
d$ci_upper <- d$estimate + 1.96 * d$se
c <- bind_rows(c,d)
c$formatted_estimate <- c$estimate
c$formatted_ci_lower <- c$ci_lower
c$formatted_ci_upper <- c$ci_upper
a <- bind_rows(b,c)
rm(b,c,d)

# change spellings ====
a$author <- gsub("Kivima ̈ki", "Kivimaki", a$author)

# data for analysis ====
a$.id <- as.factor(a$.id)
nlevels(a$.id)

## join QA results
quality_assessment <- read.csv("../../quality_assessment/quality_assessment_results.csv", header = T)
quality_assessment <- quality_assessment[,c(1:5,18)]
quality_assessment$QA[quality_assessment$Total < 36] <- "Medium"
quality_assessment$QA[quality_assessment$Total > 28] <- "Low"
quality_assessment$QA[quality_assessment$Total < 20] <- "High"
quality_assessment <- quality_assessment[,c("doi", ".id", "QA")]
a <- left_join(a, quality_assessment, by = c("doi", ".id") )

## binary data 
data_binary <- subset(a, outcome_units == "Case/control")
data_binary <- droplevels(data_binary)
nlevels(data_binary$.id)
list_binary <- split(data_binary, with(data_binary, .id, drop = TRUE))

## continuous data
data_continuous <- subset(a, outcome_units != "Case/control")
data_continuous <- droplevels(data_continuous)
nlevels(data_continuous$.id)
list_continuous <- split(data_continuous, with(data_continuous, .id, drop = TRUE))

# binary analysis ====
list2env(list_binary, envir=.GlobalEnv)

## brain_alzheimers_BMI.csv ====
a <- brain_alzheimers_BMI.csv
b <- "1_BMI_on_Alzheimers"
c <- "BMI on Alzheimer's disease"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b, ".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1],
                    n = results$k,
                    studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                    fe_effect = exp(results$TE.fixed),
                    fe_lower = exp(results$lower.fixed),
                    fe_upper = exp(results$upper.fixed),
                    fe_p = results$pval.fixed,
                    re_effect = exp(results$TE.random),
                    re_lower = exp(results$lower.random),
                    re_upper = exp(results$upper.random),
                    re_p = results$pval.random,
                    q = results$Q,
                    q_df = results$df.Q,
                    q_p = results$pval.Q,
                    tau2 = results$tau2,
                    tau2_se = results$se.tau2,
                    tau = results$tau,
                    h = results$H,
                    i1 = results$I2)
rm(brain_alzheimers_BMI.csv)

## brain_stroke_hemorrhagic_BMI.csv ====
a <- brain_stroke_hemorrhagic_BMI.csv
b <- "2_BMI_on_hemorrhagic_stroke"
c <- "BMI on hemorrhagic stroke"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(brain_stroke_hemorrhagic_BMI.csv)

## brain_stroke_ischemic_BMI.csv ====
a <- brain_stroke_ischemic_BMI.csv
b <- "3_BMI_on_ischemic_stroke"
c <- "BMI on ischemic stroke"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(brain_stroke_ischemic_BMI.csv)

## cancer_breast_cancer_birthweight_ER.csv ====
a <- cancer_breast_cancer_birthweight_ER.csv
b <- "4_Birthweight_on ER-_breast_cancer"
c <- "Birthweight on ER- breast cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_breast_cancer_birthweight_ER.csv)

## cancer_breast_cancer_birthweight.csv ====
a <- cancer_breast_cancer_birthweight.csv
b <- "5_Birthweight_on_breast_cancer"
c <- "Birthweight on breast cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_breast_cancer_birthweight.csv)

## cancer_colon_cancer_birthweight.csv ====
a <- cancer_colon_cancer_birthweight.csv
b <- "6_Birthweight_on_colon_cancer"
c <- "Birthweight on colon cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_colon_cancer_birthweight.csv)

## cancer_colorectal_cancer_BMI.csv ====
a <- cancer_colorectal_cancer_BMI.csv
b <- "7_BMI_on_colorectal_cancer"
c <- "BMI on colorectal cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_colorectal_cancer_BMI.csv)

## cancer_colorectal_cancer_WHR.csv ====
a <- cancer_colorectal_cancer_WHR.csv
b <- "8_WHR_on_colorectal_cancer"
c <- "WHR on colorectal cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_colorectal_cancer_WHR.csv)

## cancer_endometrial_cancer_BMI.csv ====
a <- cancer_endometrial_cancer_BMI.csv
b <- "9_BMI_on_endometrial_cancer"
c <- "BMI on endometrial cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_endometrial_cancer_BMI.csv)

## cancer_lung_cancer_BMI_lung_cancer.csv ====
a <- cancer_lung_cancer_BMI_lung_cancer.csv
b <- "10_BMI_on_lung_cancer"
c <- "BMI on lung cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_lung_cancer_BMI_lung_cancer.csv)

## cancer_ovarian_cancer_BMI_ovarian_cancer.csv ====
a <- cancer_ovarian_cancer_BMI_ovarian_cancer.csv
b <- "11_BMI_on_ovarian_cancer"
c <- "BMI on ovarian cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_ovarian_cancer_BMI_ovarian_cancer.csv)

## cancer_prostate_cancer_BMI_prostate_cancer.csv ====
a <- cancer_prostate_cancer_BMI_prostate_cancer.csv
b <- "12_BMI_on_prostate_cancer"
c <- "BMI on prostate cancer"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cancer_prostate_cancer_BMI_prostate_cancer.csv)

## cardiovascular_coronary_artery_disease_WHR.csv ====
a <- cardiovascular_coronary_artery_disease_WHR.csv
b <- "13_WHR_on_CAD"
c <- "WHR on CAD"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cardiovascular_coronary_artery_disease_WHR.csv)

## cardiovascular_coronary_artery_disease_WHRadjBMI.csv ====
a <- cardiovascular_coronary_artery_disease_WHRadjBMI.csv
b <- "14_WHRadjBMI_on_CAD"
c <- "WHRadjBMI on CAD"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cardiovascular_coronary_artery_disease_WHRadjBMI.csv)

## cardiovascular_hypertension.csv ====
a <- cardiovascular_hypertension.csv
b <- "15_BMI_on_hypertension"
c <- "BMI on hypertension"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cardiovascular_hypertension.csv)

## cardiovascular_venous_thromboembolism.csv ====
a <- cardiovascular_venous_thromboembolism.csv
b <- "17_BMI_on_venous_thromboembolism"
c <- "BMI on venous thromboembolism"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cardiovascular_venous_thromboembolism.csv)

## mental_health_depression_BMI.csv  ====
a <- mental_health_depression_BMI.csv
b <- "18_BMI_on_depression"
c <- "BMI on depression"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(mental_health_depression_BMI.csv)


## metabolic_type2_diabetes_BMI.csv ====
a <- metabolic_type2_diabetes_BMI.csv
b <- "27_BMI_on_type2_diabetes"
c <- "BMI on type 2 diabetes"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_type2_diabetes_BMI.csv)

## metabolic_type2_diabetes_WHRadjBMI.csv ====
a <- metabolic_type2_diabetes_WHRadjBMI.csv
b <- "28_WHRadjBMI_on_type2_diabetes"
c <- "WHRadjBMI on type 2 diabetes"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_type2_diabetes_WHRadjBMI.csv)

## reproductive_PCOS_BMI.csv ====
a <- reproductive_PCOS_BMI.csv
b <- "29_BMI_on_PCOS"
c <- "BMI on PCOS"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(reproductive_PCOS_BMI.csv)

## respiratory_asthma_BMI_asthma.csv ====
a <- respiratory_asthma_BMI_asthma.csv
b <- "30_BMI_on_asthma"
c <- "BMI on asthma"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(respiratory_asthma_BMI_asthma.csv)

## skeletal_arthritis_BMI.csv ====
a <- skeletal_arthritis_BMI.csv
b <- "31_BMI_on_arthritis"
c <- "BMI on arthritis"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = exp(results$TE.fixed),
                     fe_lower = exp(results$lower.fixed),
                     fe_upper = exp(results$upper.fixed),
                     fe_p = results$pval.fixed,
                     re_effect = exp(results$TE.random),
                     re_lower = exp(results$lower.random),
                     re_upper = exp(results$upper.random),
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(skeletal_arthritis_BMI.csv)

# continuous outcomes ====
list2env(list_continuous, envir=.GlobalEnv)

## cardiovascular_SBP_BMI.csv ====
a <- cardiovascular_SBP_BMI.csv
b <- "16_BMI_on_SBP"
c <- "BMI on Systolic blood pressure"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(cardiovascular_SBP_BMI.csv)

## metabolic_cholesterol.csv ====
a <- metabolic_cholesterol.csv
b <- "19_BMI_on_cholesterol"
c <- "BMI on cholesterol"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_cholesterol.csv)

## metabolic_fasting_glucose_BMI.csv ====
a <- metabolic_fasting_glucose_BMI.csv
b <- "20_BMI_on_fasting_glucose"
c <- "BMI on fasting glucose"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], results$studlab[4], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], a$doi[4], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_fasting_glucose_BMI.csv)

## metabolic_HbA1c.csv ====
a <- metabolic_HbA1c.csv
b <- "21_BMI_on_HbA1c"
c <- "BMI on HbA1c"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_HbA1c.csv)

## metabolic_HDL_BMI_1.csv ====
a <- metabolic_HDL_BMI_1.csv
b <- "22_BMI_on_HDL_mmol"
c <- "BMI on HDL mmol"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_HDL_BMI_1.csv)

## metabolic_HDL_BMI_2.csv  ====
a <- metabolic_HDL_BMI_2.csv
b <- "23_BMI_on_HDL_SD"
c <- "BMI on HDL SD"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_HDL_BMI_2.csv)

## metabolic_HOMA_IR_BMI.csv ====
a <- metabolic_HOMA_IR_BMI.csv
b <- "24_BMI_on_HOMA_IR"
c <- "BMI on HOMA IR"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, adhoc.hakn = "ci", title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_HOMA_IR_BMI.csv)

## metabolic_LDL_BMI_1.csv  ====
a <- metabolic_LDL_BMI_1.csv
b <- "25_BMI_on_LDL_mmol"
c <- "BMI on LDL mmol"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], results$studlab[3], sep = " & "), doi = paste(a$doi[1], a$doi[2], a$doi[3], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_LDL_BMI_1.csv)

## metabolic_LDL_BMI_2.csv  ====
a <- metabolic_LDL_BMI_2.csv
b <- "26_BMI_on_LDL_SD"
c <- "BMI on LDL SD"
### meta-analyse
results <- metagen(data = a, TE = formatted_estimate, pval = p, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf(paste("../../../figures/meta_analysis_results_figures/", b,".pdf", sep = ""), height = 4, width = 10)
forest(results, studlab = T, comb.fixed = F, comb.random = T, leftcols = c("studlab", "doi"))
grid.text(c, .5, 0.8, gp=gpar(cex=1.4))
dev.off()
### table
table1 <- data.frame(title = results$title, exposure = a$exposure[1], exposure_units = a$exposure_units[1], outcome = a$outcome[1], outcome_units = a$outcome_units[1], 
                     n = results$k,
                     studies = paste(results$studlab[1], results$studlab[2], sep = " & "), doi = paste(a$doi[1], a$doi[2], sep = " & "),
                     fe_effect = results$TE.fixed,
                     fe_lower = results$lower.fixed,
                     fe_upper = results$upper.fixed,
                     fe_p = results$pval.fixed,
                     re_effect = results$TE.random,
                     re_lower = results$lower.random,
                     re_upper = results$upper.random,
                     re_p = results$pval.random,
                     q = results$Q,
                     q_df = results$df.Q,
                     q_p = results$pval.Q,
                     tau2 = results$tau2,
                     tau2_se = results$se.tau2,
                     tau = results$tau,
                     h = results$H,
                     i1 = results$I2)
table <- rbind(table, table1)
rm(metabolic_LDL_BMI_2.csv)

# results table ====
write.csv(table, "../meta_analysis_results.csv", row.names = F)

# continuous overall forestplot analysis ====
data_continuous <- bind_rows(list_continuous, .id = "column_label")
data_continuous$label_ID <- c("BMI (SD) on Systolic blood pressure (mm/Hg)", "BMI (SD) on Systolic blood pressure (mm/Hg)", "BMI (SD) on Systolic blood pressure (mm/Hg)",
                              "BMI (SD) on total cholesterol (mmol/L)", "BMI (SD) on total cholesterol (mmol/L)",
                              "BMI (SD) on fasting glucose (mmol/L)", "BMI (SD) on fasting glucose (mmol/L)", "BMI (SD) on fasting glucose (mmol/L)", "BMI (SD) on fasting glucose (mmol/L)",
                              "BMI (SD) on haemoglobin A1C (%)", "BMI (SD) on haemoglobin A1C (%)",
                              "BMI (SD) on HDL (mmol/L)", "BMI (SD) on HDL (mmol/L)", "BMI (SD) on HDL (mmol/L)",
                              "BMI (SD) on HDL (SD)", "BMI (SD) on HDL (SD)",
                              "BMI (SD) on HOMA IR (SD)", "BMI (SD) on HOMA IR (SD)",
                              "BMI (SD) on LDL (mmol/L)", "BMI (SD) on LDL (mmol/L)", "BMI (SD) on LDL (mmol/L)",
                              "BMI (SD) on LDL (SD)", "BMI (SD) on LDL (SD)")

results <- metagen(data = data_continuous, byvar = label_ID, TE = formatted_estimate, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "MD", hakn = F, title = c)
### plots
pdf("../../../figures/meta_analysis_results_figures/continuous_outcomes.pdf", height = 13, width = 8)
forest(results, byvar = results$label_ID, studlab = T, comb.fixed = F, comb.random = T, overall = F, overall.hetstat = F, leftcols = c("studlab", "QA"),
       bylab = results$label_ID, rightcols = c("effect", "ci", "w.random"))
dev.off()

# binary overall forestplot analysis ====
data_binary$label_ID <- c("BMI (SD) on Alzheimer's disease", "BMI (SD) on Alzheimer's disease",
                          "BMI (SD) on hemorrhagic stroke", "BMI (SD) on hemorrhagic stroke",
                          "BMI (SD) on ischemic stroke", "BMI (SD) on ischemic stroke",
                          "Birthweight (SD) on ER- breast cancer", "Birthweight (SD) on ER- breast cancer",
                          "Birthweight (SD) on breast cancer", "Birthweight (SD) on breast cancer",
                          "Birthweight (SD) on colon cancer", "Birthweight (SD) on colon cancer",
                          "BMI (SD) on colorectal cancer", "BMI (SD) on colorectal cancer", "BMI (SD) on colorectal cancer",
                          "WHR (SD) on colorectal cancer", "WHR (SD) on colorectal cancer",
                          "BMI (SD) on endometrial cancer", "BMI (SD) on endometrial cancer", "BMI (SD) on endometrial cancer",
                          "BMI (SD) on lung cancer", "BMI (SD) on lung cancer",
                          "BMI (SD) on ovarian cancer", "BMI (SD) on ovarian cancer",
                          "BMI (SD) on prostate cancer", "BMI (SD) on prostate cancer",
                          "WHR (SD) on coronary artery disease", "WHR (SD) on coronary artery disease",
                          "WHRadjBMI (SD) on coronary artery disease", "WHRadjBMI (SD) on coronary artery disease",
                          "BMI (SD) on hypertension", "BMI (SD) on hypertension",
                          "BMI (SD) on venous thromboembolism", "BMI (SD) on venous thromboembolism",
                          "BMI (SD) on depression", "BMI (SD) on depression", "BMI (SD) on depression",
                          "BMI (SD) on type 2 diabetes", "BMI (SD) on type 2 diabetes",
                          "WHRadjBMI (SD) on type 2 diabetes", "WHRadjBMI (SD) on type 2 diabetes",
                          "BMI (SD) on polycystic ovary syndrome", "BMI (SD) on polycystic ovary syndrome",
                          "BMI (SD) on asthma", "BMI (SD) on asthma",
                          "BMI (SD) on arthritis", "BMI (SD) on arthritis")

a <- c("BMI (SD) on Alzheimer's disease", "BMI (SD) on Alzheimer's disease",
       "BMI (SD) on hemorrhagic stroke", "BMI (SD) on hemorrhagic stroke",
       "BMI (SD) on ischemic stroke", "BMI (SD) on ischemic stroke",
       "Birthweight (SD) on ER- breast cancer", "Birthweight (SD) on ER- breast cancer", 
       "Birthweight (SD) on breast cancer", "Birthweight (SD) on breast cancer",
       "Birthweight (SD) on colon cancer", "Birthweight (SD) on colon cancer",
       "BMI (SD) on colorectal cancer", "BMI (SD) on colorectal cancer", "BMI (SD) on colorectal cancer",
       "WHR (SD) on colorectal cancer", "WHR (SD) on colorectal cancer",
       "BMI (SD) on endometrial cancer", "BMI (SD) on endometrial cancer", "BMI (SD) on endometrial cancer",
       "BMI (SD) on lung cancer", "BMI (SD) on lung cancer",
       "BMI (SD) on ovarian cancer", "BMI (SD) on ovarian cancer")
data_binary1 <- data_binary[data_binary$label_ID %in% a,] 
a <- c("BMI (SD) on prostate cancer", "BMI (SD) on prostate cancer",
       "WHR (SD) on coronary artery disease", "WHR (SD) on coronary artery disease",
                                 "WHRadjBMI (SD) on coronary artery disease", "WHRadjBMI (SD) on coronary artery disease",
                                 "BMI (SD) on hypertension", "BMI (SD) on hypertension",
                                 "BMI (SD) on venous thromboembolism", "BMI (SD) on venous thromboembolism",
                                 "BMI (SD) on depression", "BMI (SD) on depression", "BMI (SD) on depression",
                                 "BMI (SD) on type 2 diabetes", "BMI (SD) on type 2 diabetes",
                                 "WHRadjBMI (SD) on type 2 diabetes", "WHRadjBMI (SD) on type 2 diabetes",
                                 "BMI (SD) on polycystic ovary syndrome", "BMI (SD) on polycystic ovary syndrome",
                                 "BMI (SD) on asthma", "BMI (SD) on asthma",
                                 "BMI (SD) on arthritis", "BMI (SD) on arthritis")
data_binary2 <- data_binary[data_binary$label_ID %in% a,] 
  
results1 <- metagen(data = data_binary1, byvar = label_ID, TE = formatted_estimate, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
results2 <- metagen(data = data_binary2, byvar = label_ID, TE = formatted_estimate, level.ci = 0.95, 
                   studlab = paste(author, year, sep = " et al. "),
                   lower = formatted_ci_lower, upper = formatted_ci_upper,
                   method.tau = "PM",
                   sm = "OR", hakn = F, title = c)
### plots
pdf("../../../figures/meta_analysis_results_figures/binary_outcomes1.pdf", height = 15, width = 8)
forest(results1, byvar = results$label_ID, studlab = T, comb.fixed = F, comb.random = T, overall = F, overall.hetstat = F, leftcols = c("studlab", "QA"),
       bylab = results$label_ID, rightcols = c("effect", "ci", "w.random"))
dev.off()

pdf("../../../figures/meta_analysis_results_figures/binary_outcomes2.pdf", height = 15, width = 8)
forest(results2, byvar = results$label_ID, studlab = T, comb.fixed = F, comb.random = T, overall = F, overall.hetstat = F, leftcols = c("studlab", "QA"),
       bylab = results$label_ID, rightcols = c("effect", "ci", "w.random"))
dev.off()






