rm(list=ls())
# load all of the data frames ====
setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/analysis/meta_analysis/data_for_analysis/")
list_files <- list.files("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/analysis/meta_analysis/data_for_analysis/")
list <- list()
for (i in 1:length(list_files)){
  list[[i]] <- (read.csv(list_files[i], header=T))
}
names(list) <- list_files
data <- ldply(list, data.frame)
a <- select(data, .id, author, year, doi, MR_design, exposure, exposure_definition, outcome, outcome_info, outcome_group, exposure_units, outcome_units, effect_estimate, estimate, se, ci_lower, ci_upper, p, exposure_n_current, exposure_n_og, outcome_n_case_current, outcome_n_control_current, ID_analysis)
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

# data for analysis ====
a$.id <- as.factor(a$.id)

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

## data 
list2env(list_binary, envir=.GlobalEnv)
list2env(list_continuous, envir=.GlobalEnv)

# data ====
setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/")
data <- read.csv("analysis/data.csv", stringsAsFactors = F)
rm(list=setdiff(ls(), c("data", "a")))
d1 <- anti_join(data, a, by = "ID_analysis")
a <- select(d1, author, year, doi, MR_design, exposure, exposure_definition, outcome, outcome_info, outcome_group, exposure_units, outcome_units, effect_estimate, estimate, se, ci_lower, ci_upper, p, exposure_n_current, exposure_n_og, outcome_n_case_current, outcome_n_control_current, ID_analysis)
data <- a
data$outcome_group <- as.factor(data$outcome_group)

# anthropometric outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam, data, d1, a)

# anthropometric ====
a <- anthropometric
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
anthropometric_pos_b <- subset(a, estimate > 0)
anthropometric_neg_b <- subset(a, estimate < 0)
anthropometric_zero_b <- subset(a, estimate == 0)

# brain ====
a <- brain
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
a$effect_estimate <- gsub("Beta", "beta", a$effect_estimate)
b <- subset(a, effect_estimate == "beta")
a <- subset(a, effect_estimate != "beta")
brain_pos_b <- subset(a, estimate > 1)
brain_neg_b <- subset(a, estimate < 1)
brain_zero_b <- subset(a, estimate == 1)

# cancer ====
a <- cancer
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
a$effect_estimate <- gsub("Hazard ratio", "HR", a$effect_estimate)
a$effect_estimate <- gsub("beta", "OR", a$effect_estimate)
a1 <- subset(a, effect_estimate == "log-OR")
a2 <- subset(a, effect_estimate == "HR")
a3 <- subset(a, effect_estimate == "Additive hazards model")
a <- subset(a, effect_estimate != "log-OR")
a <- subset(a, effect_estimate != "HR")
a <- subset(a, effect_estimate != "Additive hazards model")
cancer_pos_b <- subset(a, estimate > 1)
cancer_neg_b <- subset(a, estimate < 1)
cancer_zero_b <- subset(a, estimate == 1)

# cardiovascular ====
a <- cardiovascular
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
a$effect_estimate <- gsub("Change in mm Hg per increase in 10% BMI", "beta", a$effect_estimate)
a$effect_estimate <- gsub("Beta", "beta", a$effect_estimate)
a$effect_estimate <- gsub("Odds ratio", "OR", a$effect_estimate)
a$effect_estimate <- gsub("Mean difference", "beta", a$effect_estimate)
a$effect_estimate <- gsub("Hazard ratio", "HR", a$effect_estimate)

## continuous
continuous <- c("carotid IMT", "DBP", "heart beat", "heart rate", "IMT", "left ventricular hypertrophy", "Left ventricular mass", "mean arterial pressure",
                "pulse pressure", "pulse wave velocity", "SBP")
cardiovascular_continuous <- a[a$outcome %in% continuous, ]
table(cardiovascular_continuous$outcome)
table(cardiovascular_continuous$exposure)
table(cardiovascular_continuous$effect_estimate)
cardiovascular_continuous$effect_estimate <- gsub("OR", "beta", cardiovascular_continuous$effect_estimate)

cardiovascular_continuous_pos_b <- subset(cardiovascular_continuous, estimate > 0)
cardiovascular_continuous_neg_b <- subset(cardiovascular_continuous, estimate < 0)
cardiovascular_continuous_zero_b <- subset(cardiovascular_continuous, estimate == 0)


## binary 
continuous <- c("carotid IMT", "DBP", "heart beat", "heart rate", "IMT", "left ventricular hypertrophy", "Left ventricular mass", "mean arterial pressure",
                "pulse pressure", "pulse wave velocity", "SBP")
cardiovascular_binary <- a[!a$outcome %in% continuous, ]
a1 <- subset(cardiovascular_binary, effect_estimate == "Additive hazards model")
a2 <- subset(cardiovascular_binary, effect_estimate == "beta")
a3 <- subset(cardiovascular_binary, effect_estimate == "GRSA estimate")
a4 <- subset(cardiovascular_binary, effect_estimate == "HR")
a5 <- subset(cardiovascular_binary, effect_estimate == "log-OR")
a6 <- subset(cardiovascular_binary, effect_estimate == "OR")
a7 <- subset(cardiovascular_binary, effect_estimate == "RR")

cardiovascular_binary_pos_b <- subset(cardiovascular_binary, estimate > 1)
cardiovascular_binary_neg_b <- subset(cardiovascular_binary, estimate < 1)
cardiovascular_binary_zero_b <- subset(cardiovascular_binary, estimate == 1)

rm(a1,a2,a3,a4,a5,a6,a7)

# gastrointestinal ====
a <- gastrointestinal
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
table(a$outcome)

# hepatic ====
a <- hepatic
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
table(a$outcome)
nlevels(as.factor(hepatic$outcome))
## subset
include <- c("ALT", "AST", "GGT")
hepatic_markers <- a[a$outcome %in% include, ]

include <- c("ALT", "AST", "GGT")
hepatic_binary <- a[!a$outcome %in% include, ]
table(droplevels(hepatic_binary$outcome))

# immune ====
a <- immune
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)

# mental health ====
mental_health <- `mental health`
a <- mental_health
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset 
traits <- c("ADHD", "anorexia nervosa", "attention/activity symptoms score", "being a nervous person", "being a worrier", "being tense/highly-strung",
             "body dissatisfaction", "bulimia nervosa", "burden of compulsions obsessions score", "happiness", "particular fears score", 
             "post traumatic stress disorder", "schizophrenia", "SDQ emotional symptoms score", "self esteem: global self worth score",
             "suffering from nerves")
a1 <- a[a$outcome %in% traits, ]
a <- a[!a$outcome %in% traits, ]
mental_health_depression <- subset(a, outcome == "depression")
a <- subset(a, outcome != "depression")
rm(a1)

# metabolic ====
a <- metabolic
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
a$effect_estimate <- gsub("Hazard ratio", "HR", a$effect_estimate)
a$effect_estimate <- gsub("Beta", "beta", a$effect_estimate)
a$effect_estimate <- gsub("Odds ratio", "OR", a$effect_estimate)
a$effect_estimate <- gsub("OR, adjusted for birth weight, smoking and education", "OR", a$effect_estimate)

a1 <- subset(a, effect_estimate == "beta")
a2 <- subset(a, effect_estimate != "beta")

## subset 
traits <- c("137 metabolites", "anemia", "diabetes", "dyslipidemia", "EGFR", "fasting glucose", "fasting insulin", "Gutt index", 
            "hyperthyroidism", "hyperuricaemia", "hypothyroidism", "insulin secretion", "metabolic syndrome", "two hour glucose", "type 1 diabetes", "type 2 diabetes")
a3 <- a[a$outcome %in% traits, ]
a4 <- a[!a$outcome %in% traits, ]
a5 <- a4[,c(5,7,12:17)]
rm(a1,a2,a3,a4,a5)








# other ====
a <- other
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$effect_estimate)
a1 <- subset(a, outcome == "methylation (cpg)")
a <- subset(a, outcome != "methylation (cpg)")
a2 <- subset(a, outcome == "mortality")
a <- subset(a, outcome != "mortality")
rm(a1,a2)

# renal ====
a <- renal
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)

# reproductive ====
a <- reproductive
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)


# respiratory ====
a <- respiratory
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)
table(a$effect_estimate)
a$effect_estimate <- gsub("Beta", "beta", a$effect_estimate)
respiratory_smoking <- subset(a, outcome == "smoking")
respiratory_nonsmoking <- subset(a, outcome != "smoking")

# skeletal ====
a <- skeletal
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)

# skin ====
a <- skin
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)

# social ====
a <- social
a <- droplevels(a)
a$outcome <- as.factor(a$outcome)
a$doi <- as.factor(a$doi)
## subset for effect estimate type
table(a$outcome)
traits <- c("annual income", "average social income", "income", "social income")
social_income <- a[a$outcome %in% traits, ]
social_not_income <- a[!a$outcome %in% traits, ]


# save ====

save.image("analysis/narrative_synthesis.RData")
