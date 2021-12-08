rm(list=ls())
# packages ====
# install.packages('readxl')
library(ggplot2)
library(cowplot)
library(dplyr)
library(data.table)

# ====
setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/systematic_review_MR_adiposity/")

# data ====
data <- read.csv("analysis/data.csv")
nlevels(data$outcome_group)
table(data$outcome_group)

# anthropometric outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "anthropometric")))

# subset for data
anthropometric <- droplevels(anthropometric)
# create data frames for each outcome for the group
table(anthropometric$outcome)
for(i in levels(anthropometric$outcome)) {
  nam <- paste("anthropometric", i, sep = "_")
  assign(nam, anthropometric[anthropometric$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`anthropometric_fasting insulin`, anthropometric_HCadjBMI, anthropometric_WCadjBMI, anthropometric_WHRadjBMI)
# examine outcomes to see if they have the same exposure from a different study (i.e. remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome)
rm(`anthropometric_adipose tissue volume`, `anthropometric_birth length`, `anthropometric_birth weight`, anthropometric_BMI, `anthropometric_body fat`, anthropometric_HC, `anthropometric_head circumference`, anthropometric_height, `anthropometric_leg fat`, `anthropometric_trunk fat`, anthropometric_weight, anthropometric_WHR)
# separate out exposures
anthropometric_WC <- droplevels(anthropometric_WC)
for(i in levels(anthropometric_WC$exposure)) {
  nam <- paste("anthropometric_WC", i, sep = "_")
  assign(nam, anthropometric_WC[anthropometric_WC$exposure==i,])
}
rm(i, nam)
# remove data frames with one result
rm(`anthropometric_WC_BMI increasing and WHR decreasing`, `anthropometric_WC_BMI increasing and WHR increasing`)
# remove data frames where exposure or outcome is sliglthy different
rm(anthropometric_WC_BMI)
# save data frames and check manually for meta-analysis criteria
write.csv(anthropometric_WC_WHRadjBMI, "analysis/meta_analysis/manual_check/anthropometric_WC_WHRadjBMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))






# brain outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "brain")))

# subset for data
brain <- droplevels(brain)
# create data frames for each outcome for the group
table(brain$outcome)
for(i in levels(brain$outcome)) {
  nam <- paste("brain", i, sep = "_")
  assign(nam, brain[brain$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`brain_bipolar disorder`, `brain_cognitive ability`, `brain_grey matter volume`, brain_migraine, brain_schizophrenia)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`brain_amyotrophic lateral sclerosis`, brain_dementia)
# separate out exposures
`brain_alzheimer's disease` <- droplevels(`brain_alzheimer's disease`)
for(i in levels(`brain_alzheimer's disease`$exposure)) {
  nam <- paste("brain_alzheimer's disease", i, sep = "_")
  assign(nam, `brain_alzheimer's disease`[`brain_alzheimer's disease`$exposure==i,])
}
`brain_multiple sclerosis` <- droplevels(`brain_multiple sclerosis`)
for(i in levels(`brain_alzheimer's disease`$exposure)) {
  nam <- paste("brain_multiple sclerosis", i, sep = "_")
  assign(nam, `brain_multiple sclerosis`[`brain_multiple sclerosis`$exposure==i,])
}
`brain_parkinson's disease` <- droplevels(`brain_parkinson's disease`)
for(i in levels(`brain_parkinson's disease`$exposure)) {
  nam <- paste("brain_parkinson's disease", i, sep = "_")
  assign(nam, `brain_parkinson's disease`[`brain_parkinson's disease`$exposure==i,])
}
brain_stroke <- droplevels(brain_stroke)
for(i in levels(brain_stroke$exposure)) {
  nam <- paste("brain_stroke", i, sep = "_")
  assign(nam, brain_stroke[brain_stroke$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(`brain_alzheimer's disease`, `brain_multiple sclerosis`, `brain_parkinson's disease`, brain_stroke)
# remove data frames with one result
rm(`brain_stroke_birth weight`)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
rm(brain_stroke_WHR, brain_stroke_WHRadjBMI)
`brain_multiple sclerosis_BMI` <- `brain_multiple sclerosis_BMI`[c(1,2,4),]
# separate out specific outcomes for brain_stroke_BMI
brain_stroke_BMI <- droplevels(brain_stroke_BMI)
for(i in levels(brain_stroke_BMI$outcome_info)) {
  nam <- paste("brain_stroke_BMI", i, sep = "_")
  assign(nam, brain_stroke_BMI[brain_stroke_BMI$outcome_info==i,])
}
rm(i, nam)
# remove master brain_stroke_BMI and data frames with 1 result
rm(brain_stroke_BMI, `brain_stroke_BMI_all cause`, brain_stroke_BMI_cardsiometabolic, `brain_stroke_BMI_incident all cause`, `brain_stroke_BMI_incident ischemic`, `brain_stroke_BMI_incident hemorrhagic`, 
   `brain_stroke_BMI_ischemic cardiometabolic`, `brain_stroke_BMI_ischemic large artery`, `brain_stroke_BMI_ischemic small vessel`, `brain_stroke_BMI_ischemic, all`, `brain_stroke_BMI_large vessel disease`, `brain_stroke_BMI_small vessel disease`)
# save data frames and check manually for meta-analysis criteria
write.csv(`brain_alzheimer's disease_BMI`, "analysis/meta_analysis/manual_check/brain_alzheimers_BMI.csv", 
            row.names = FALSE)
write.csv(`brain_multiple sclerosis_BMI`, "analysis/meta_analysis/manual_check/brain_multiple_scelrosis_BMI.csv", 
            row.names = FALSE)
write.csv(brain_stroke_BMI_hemorrhagic, "analysis/meta_analysis/manual_check/brain_stroke_hemorrhagic_BMI.csv", 
            row.names = FALSE)
write.csv(brain_stroke_BMI_ischemic, "analysis/meta_analysis/manual_check/brain_stroke_ischemic_BMI.csv", 
            row.names = FALSE)
write.csv(brain_stroke_BMI_stroke, "analysis/meta_analysis/manual_check/brain_stroke_stroke_BMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))

# cancer outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "cancer")))

# subset for data
cancer <- droplevels(cancer)
# create data frames for each outcome for the group
table(cancer$outcome)
for(i in levels(cancer$outcome)) {
  nam <- paste("cancer", i, sep = "_")
  assign(nam, cancer[cancer$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`cancer_cervical cancer`, `cancer_clear cell cancer`, `cancer_gastric cancer`, `cancer_low malignant potential tumours`, `cancer_lymphoid cancer`, `cancer_other smoking cancer`,
   `cancer_stomach and esophageal cancer`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`cancer_Barrett’s esophagus`, `cancer_cancer mortality`, `cancer_cancer risk`, `cancer_esophageal adenocarcinoma`, cancer_glioma, cancer_meningioma, `cancer_multiple myeloma`, 
   `cancer_rectal cancer`, `cancer_renal cell carcinoma`, `cancer_testicular cancer`, `cancer_upper-aerodigestive cancer`)
# separate out exposures
`cancer_any cancer` <- droplevels(`cancer_any cancer`)
for(i in levels(`cancer_any cancer`$exposure)) {
  nam <- paste("cancer_any_cancer", i, sep = "_")
  assign(nam, `cancer_any cancer`[`cancer_any cancer`$exposure==i,])
}
`cancer_breast cancer` <- droplevels(`cancer_breast cancer`)
for(i in levels(`cancer_breast cancer`$exposure)) {
  nam <- paste("cancer_breast_cancer", i, sep = "_")
  assign(nam, `cancer_breast cancer`[`cancer_breast cancer`$exposure==i,])
}
`cancer_colon cancer` <- droplevels(`cancer_colon cancer`)
for(i in levels(`cancer_colon cancer`$exposure)) {
  nam <- paste("cancer_colon_cancer", i, sep = "_")
  assign(nam, `cancer_colon cancer`[`cancer_colon cancer`$exposure==i,])
}
`cancer_colorectal cancer` <- droplevels(`cancer_colorectal cancer`)
for(i in levels(`cancer_colorectal cancer`$exposure)) {
  nam <- paste("cancer_colorectal_cancer", i, sep = "_")
  assign(nam, `cancer_colorectal cancer`[`cancer_colorectal cancer`$exposure==i,])
}
`cancer_endometrial cancer` <- droplevels(`cancer_endometrial cancer`)
for(i in levels(`cancer_endometrial cancer`$exposure)) {
  nam <- paste("cancer_endometrial_cancer", i, sep = "_")
  assign(nam, `cancer_endometrial cancer`[`cancer_endometrial cancer`$exposure==i,])
}
`cancer_kidney cancer` <- droplevels(`cancer_kidney cancer`)
for(i in levels(`cancer_kidney cancer`$exposure)) {
  nam <- paste("cancer_kidney_cancer", i, sep = "_")
  assign(nam, `cancer_kidney cancer`[`cancer_kidney cancer`$exposure==i,])
}
`cancer_lung cancer` <- droplevels(`cancer_lung cancer`)
for(i in levels(`cancer_lung cancer`$exposure)) {
  nam <- paste("cancer_lung_cancer", i, sep = "_")
  assign(nam, `cancer_lung cancer`[`cancer_lung cancer`$exposure==i,])
}
`cancer_other cancer` <- droplevels(`cancer_other cancer`)
for(i in levels(`cancer_other cancer`$exposure)) {
  nam <- paste("cancer_other_cancer", i, sep = "_")
  assign(nam, `cancer_other cancer`[`cancer_other cancer`$exposure==i,])
}
`cancer_ovarian cancer` <- droplevels(`cancer_ovarian cancer`)
for(i in levels(`cancer_ovarian cancer`$exposure)) {
  nam <- paste("cancer_ovarian_cancer", i, sep = "_")
  assign(nam, `cancer_ovarian cancer`[`cancer_ovarian cancer`$exposure==i,])
}
`cancer_pancreatic cancer` <- droplevels(`cancer_pancreatic cancer`)
for(i in levels(`cancer_pancreatic cancer`$exposure)) {
  nam <- paste("cancer_pancreatic_cancer", i, sep = "_")
  assign(nam, `cancer_pancreatic cancer`[`cancer_pancreatic cancer`$exposure==i,])
}
`cancer_prostate cancer` <- droplevels(`cancer_prostate cancer`)
for(i in levels(`cancer_prostate cancer`$exposure)) {
  nam <- paste("cancer_prostate_cancer", i, sep = "_")
  assign(nam, `cancer_prostate cancer`[`cancer_prostate cancer`$exposure==i,])
}
`cancer_skin cancer` <- droplevels(`cancer_skin cancer`)
for(i in levels(`cancer_skin cancer`$exposure)) {
  nam <- paste("cancer_skin_cancer", i, sep = "_")
  assign(nam, `cancer_skin cancer`[`cancer_skin cancer`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(cancer, `cancer_any cancer`, `cancer_breast cancer`, `cancer_colon cancer`, `cancer_colorectal cancer`, `cancer_endometrial cancer`, `cancer_kidney cancer`,
   `cancer_lung cancer`, `cancer_other cancer`, `cancer_ovarian cancer`, `cancer_pancreatic cancer`, `cancer_prostate cancer`, `cancer_skin cancer`)
# remove data frames with one result
rm(cancer_colorectal_cancer_WHRadjBMI, cancer_lung_cancer_WHRadjBMI, cancer_other_cancer_BMI, cancer_other_cancer_WHRadjBMI, cancer_prostate_cancer_WHRadjBMI, cancer_skin_cancer_WHRadjBMI)
# remove data frames with only one study ID
rm(cancer_breast_cancer_WHR, cancer_colorectal_cancer_obesity, cancer_endometrial_cancer_WHRadjBMI, `cancer_lung_cancer_birth weight`, `cancer_ovarian_cancer_birth weight`, 
   cancer_ovarian_cancer_WHR, cancer_pancreatic_cancer_WHR, `cancer_prostate_cancer_birth weight`, cancer_prostate_cancer_WHR)
# separate out specific outcomes and save for manual checking where needed
cancer_any_cancer_BMI <- droplevels(cancer_any_cancer_BMI)
for(i in levels(cancer_any_cancer_BMI$outcome_info)) {
  nam <- paste("cancer_any_cancer_BMI", i, sep = "_")
  assign(nam, cancer_any_cancer_BMI[cancer_any_cancer_BMI$outcome_info==i,])
}
rm(cancer_any_cancer_BMI, `cancer_any_cancer_BMI_any non-skin cancer`, `cancer_any_cancer_BMI_non-melanoma skin cancer`)
write.csv(`cancer_any_cancer_BMI_any cancer`, "analysis/meta_analysis/manual_check/cancer_any_cancer_BMI.csv", 
            row.names = FALSE)
rm(`cancer_any_cancer_BMI_any cancer`)
write.csv(cancer_any_cancer_WHRadjBMI, "analysis/meta_analysis/manual_check/cancer_any_cancer_WHRadjBMI.csv", 
            row.names = FALSE)
rm(cancer_any_cancer_WHRadjBMI)
`cancer_breast_cancer_birth weight` <- droplevels(`cancer_breast_cancer_birth weight`)
for(i in levels(`cancer_breast_cancer_birth weight`$outcome_info)) {
  nam <- paste("cancer_breast_cancer_birth weight", i, sep = "_")
  assign(nam, `cancer_breast_cancer_birth weight`[`cancer_breast_cancer_birth weight`$outcome_info==i,])
}
rm(`cancer_breast_cancer_birth weight`, `cancer_breast_cancer_birth weight_ER+`)
write.csv(`cancer_breast_cancer_birth weight_breast cancer`, "analysis/meta_analysis/manual_check/cancer_breast_cancer_birthweight.csv", 
            row.names = FALSE)
write.csv(`cancer_breast_cancer_birth weight_ER-`, "analysis/meta_analysis/manual_check/cancer_breast_cancer_birthweight_ER.csv", 
            row.names = FALSE)
rm(`cancer_breast_cancer_birth weight_breast cancer`, `cancer_breast_cancer_birth weight_ER-`)
cancer_breast_cancer_BMI <- droplevels(cancer_breast_cancer_BMI)
for(i in levels(cancer_breast_cancer_BMI$outcome_info)) {
  nam <- paste("cancer_breast_cancer_BMI", i, sep = "_")
  assign(nam, cancer_breast_cancer_BMI[cancer_breast_cancer_BMI$outcome_info==i,])
}
rm(cancer_breast_cancer_BMI, cancer_breast_cancer_BMI_BRCA1, `cancer_breast_cancer_BMI_BRCA1/2`, cancer_breast_cancer_BMI_BRCA2, `cancer_breast_cancer_BMI_ER- survival`,
   `cancer_breast_cancer_BMI_ER/PR-`, `cancer_breast_cancer_BMI_ER/PR+`, `cancer_breast_cancer_BMI_ER+`, `cancer_breast_cancer_BMI_ER+ survival`, `cancer_breast_cancer_BMI_ever HRT`,
   `cancer_breast_cancer_BMI_never HRT`, `cancer_breast_cancer_BMI_PR-`, `cancer_breast_cancer_BMI_PR+`)
write.csv(`cancer_breast_cancer_BMI_breast cancer`, "analysis/meta_analysis/manual_check/cancer_breast_cancer_BMI.csv", 
            row.names = FALSE)
write.csv(`cancer_breast_cancer_BMI_ER-`, "analysis/meta_analysis/manual_check/cancer_breast_cancer_BMI_ER.csv", 
            row.names = FALSE)
write.csv(cancer_breast_cancer_BMI_postmenopausal, "analysis/meta_analysis/manual_check/cancer_breast_cancer_BMI_postmenopausal.csv", 
            row.names = FALSE)
write.csv(cancer_breast_cancer_BMI_premenopausal, "analysis/meta_analysis/manual_check/cancer_breast_cancer_BMI_premenopausal.csv", 
            row.names = FALSE)
write.csv(cancer_breast_cancer_WHRadjBMI, "analysis/meta_analysis/manual_check/cancer_breast_cancer_WHRadjBMI.csv", 
            row.names = FALSE)
rm(`cancer_breast_cancer_BMI_breast cancer`, `cancer_breast_cancer_BMI_ER-`, cancer_breast_cancer_BMI_postmenopausal, cancer_breast_cancer_BMI_premenopausal, cancer_breast_cancer_WHRadjBMI)
write.csv(cancer_colon_cancer_BMI, "analysis/meta_analysis/manual_check/cancer_colon_cancer_BMI.csv", 
            row.names = FALSE)
rm(cancer_colon_cancer_BMI)
write.csv(`cancer_colorectal_cancer_birth weight`, "analysis/meta_analysis/manual_check/cancer_colon_cancer_birthweight.csv", 
            row.names = FALSE)
rm(`cancer_colorectal_cancer_birth weight`)
write.csv(cancer_colorectal_cancer_BMI, "analysis/meta_analysis/manual_check/cancer_colorectal_cancer_BMI.csv", 
            row.names = FALSE)
rm(cancer_colorectal_cancer_BMI)
write.csv(cancer_colorectal_cancer_WHR, "analysis/meta_analysis/manual_check/cancer_colorectal_cancer_WHR.csv", 
            row.names = FALSE)
rm(cancer_colorectal_cancer_WHR)
write.csv(cancer_endometrial_cancer_BMI, "analysis/meta_analysis/manual_check/cancer_endometrial_cancer_BMI.csv", 
            row.names = FALSE)
rm(cancer_endometrial_cancer_BMI)
write.csv(cancer_kidney_cancer_BMI, "analysis/meta_analysis/manual_check/cancer_kidney_cancer_BMI.csv", 
            row.names = FALSE)
rm(cancer_kidney_cancer_BMI)
write.csv(cancer_pancreatic_cancer_BMI, "analysis/meta_analysis/manual_check/cancer_pancreatic_cancer_BMI.csv", 
            row.names = FALSE)
rm(cancer_pancreatic_cancer_BMI)
rm(cancer_skin_cancer_BMI) # remove data frames where outcomes are slightly different
cancer_ovarian_cancer_BMI <- droplevels(cancer_ovarian_cancer_BMI)
for(i in levels(cancer_ovarian_cancer_BMI$outcome_info)) {
  nam <- paste("cancer_ovarian_cancer_BMI", i, sep = "_")
  assign(nam, cancer_ovarian_cancer_BMI[cancer_ovarian_cancer_BMI$outcome_info==i,])
}
rm(cancer_ovarian_cancer_BMI, `cancer_ovarian_cancer_BMI_high grade serous`, `cancer_ovarian_cancer_BMI_high-grade ovary/tubal`, `cancer_ovarian_cancer_BMI_high-grade peritoneal`,
   `cancer_ovarian_cancer_BMI_invasive low-grade and borderline`, `cancer_ovarian_cancer_BMI_low grade`, `cancer_ovarian_cancer_BMI_mucinous (invasive and borderline)`,
   `cancer_ovarian_cancer_BMI_non-high grade serous`, cancer_ovarian_cancer_BMI_serous)
write.csv(`cancer_ovarian_cancer_BMI_clear cell`, "analysis/meta_analysis/manual_check/cancer_ovarian_cancer_BMI_clear_cell.csv", 
            row.names = FALSE)
write.csv(cancer_ovarian_cancer_BMI_endometroid, "analysis/meta_analysis/manual_check/cancer_ovarian_cancer_BMI_endometroid.csv", 
            row.names = FALSE)
write.csv(`cancer_ovarian_cancer_BMI_ovarian cancer`, "analysis/meta_analysis/manual_check/cancer_ovarian_cancer_BMI_ovarian_cancer.csv", 
            row.names = FALSE)
rm(`cancer_ovarian_cancer_BMI_clear cell`, cancer_ovarian_cancer_BMI_endometroid, `cancer_ovarian_cancer_BMI_ovarian cancer`)
cancer_prostate_cancer_BMI <- droplevels(cancer_prostate_cancer_BMI)
for(i in levels(cancer_prostate_cancer_BMI$outcome_info)) {
  nam <- paste("cancer_prostate_cancer_BMI", i, sep = "_")
  assign(nam, cancer_prostate_cancer_BMI[cancer_prostate_cancer_BMI$outcome_info==i,])
}
rm(cancer_prostate_cancer_BMI, cancer_prostate_cancer_BMI_advanced, `cancer_prostate_cancer_BMI_high grade`, cancer_prostate_cancer_BMI_localised, `cancer_prostate_cancer_BMI_low grade`) # reuslts with 1 row
rm(cancer_prostate_cancer_BMI_aggressive) # results with one study id
write.csv(`cancer_prostate_cancer_BMI_prostate cancer`, "analysis/meta_analysis/manual_check/cancer_prostate_cancer_BMI_prostate_cancer.csv", 
            row.names = FALSE)
rm(`cancer_prostate_cancer_BMI_prostate cancer`)
cancer_lung_cancer_WHR <- droplevels(cancer_lung_cancer_WHR)
for(i in levels(cancer_lung_cancer_WHR$outcome_info)) {
  nam <- paste("cancer_lung_cancer_WHR", i, sep = "_")
  assign(nam, cancer_lung_cancer_WHR[cancer_lung_cancer_WHR$outcome_info==i,])
}
rm(cancer_lung_cancer_WHR, `cancer_lung_cancer_WHR_squamous cell`, `cancer_lung_cancer_WHR_ever smokers`, `cancer_lung_cancer_WHR_never smokers`, `cancer_lung_cancer_WHR_small cell`)
write.csv(cancer_lung_cancer_WHR_adenocarcinoma, "analysis/meta_analysis/manual_check/cancer_lung_cancer_WHR_adenocarcinoma.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_WHR_lung cancer`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_WHR_lung_cancer.csv", 
            row.names = FALSE)
rm(`cancer_lung_cancer_WHR_lung cancer`, cancer_lung_cancer_WHR_adenocarcinoma, `cancer_lung_cancer_WHR_squamous cell`)
cancer_lung_cancer_BMI <- droplevels(cancer_lung_cancer_BMI)
for(i in levels(cancer_lung_cancer_BMI$outcome_info)) {
  nam <- paste("cancer_lung_cancer_BMI", i, sep = "_")
  assign(nam, cancer_lung_cancer_BMI[cancer_lung_cancer_BMI$outcome_info==i,])
}
rm(cancer_lung_cancer_BMI, `cancer_lung_cancer_BMI_current smokers`, `cancer_lung_cancer_BMI_former smokers`, `cancer_lung_cancer_BMI_old onset`, `cancer_lung_cancer_BMI_other, not including: aquamous cell, adenocarcinoma, small cell`,
   cancer_lung_cancer_BMI_squamous, `cancer_lung_cancer_BMI_young onset`)
write.csv(cancer_lung_cancer_BMI_adenocarcinoma, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_adenocarcinoma.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_BMI_ever smokers`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_ever_smokers.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_BMI_lung cancer`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_lung_cancer.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_BMI_never smokers`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_never_smokers.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_BMI_small cell`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_small_cell.csv", 
            row.names = FALSE)
write.csv(`cancer_lung_cancer_BMI_squamous cell`, "analysis/meta_analysis/manual_check/cancer_lung_cancer_BMI_squamous_cell.csv", 
            row.names = FALSE)
rm(cancer_lung_cancer_BMI_adenocarcinoma, `cancer_lung_cancer_BMI_ever smokers`, `cancer_lung_cancer_BMI_lung cancer`, `cancer_lung_cancer_BMI_never smokers`, `cancer_lung_cancer_BMI_small cell`, `cancer_lung_cancer_BMI_squamous cell`)
rm(list=setdiff(ls(), c("data")))



# cardiovascular outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "cardiovascular")))

# subset for data
cardiovascular <- droplevels(cardiovascular)
# create data frames for each outcome for the group
table(cardiovascular$outcome)
for(i in levels(cardiovascular$outcome)) {
  nam <- paste("cardiovascular", i, sep = "_")
  assign(nam, cardiovascular[cardiovascular$outcome==i,])
}
rm(i, nam)

# remove outcomes with only 1 observation
rm(`cardiovascular_aortic stenosis`, `cardiovascular_deep vein thrombosis and pulmonary embolism`, `cardiovascular_Left ventricular mass`,
   `cardiovascular_mean arterial pressure`, `cardiovascular_peripheral arterial disease`, `cardiovascular_peripheral vascular disease`,
   `cardiovascular_pulse pressure`, `cardiovascular_pulse wave velocity`)

# remove outcomes with only 1 study
rm(cardiovascular_aneurysm, `cardiovascular_atrial fibrilation`, `cardiovascular_heart beat`, cardiovascular_hemorrhoids, `cardiovascular_hypertensive disease`,
   cardiovascular_IMT, `cardiovascular_left ventricular hypertrophy`, `cardiovascular_sudden cardiac arrest`, `cardiovascular_varicose veins`, `cardiovascular_vascular disease`)

# remove data frames and rows with no meta-analysable exposures (e.g. a data frame of 2 results but one is BMI and one is WHR)
rm(cardiovascular_smoking)
`cardiovascular_cardiovascular disease` <- `cardiovascular_cardiovascular disease`[-3,]
`cardiovascular_carotid IMT` <- `cardiovascular_carotid IMT`[-2]
`cardiovascular_venous thromboembolism` <- `cardiovascular_venous thromboembolism`[-1,]
cardiovascular_hypertension <- cardiovascular_hypertension[-c(1,11),]
`cardiovascular_myocardial infarction` <- `cardiovascular_myocardial infarction`[-c(6,7,8,9),]
`cardiovascular_heart failure` <- `cardiovascular_heart failure`[-1,]
`cardiovascular_deep vein thrombosis` <- `cardiovascular_deep vein thrombosis`[c(1,25),]

# separate data frames by exposure where appropriate
cardiovascular_arrhythmia <- droplevels(cardiovascular_arrhythmia)
for(i in levels(cardiovascular_arrhythmia$exposure)) {
  nam <- paste("cardiovascular_arrhythmia", i, sep = "_")
  assign(nam, cardiovascular_arrhythmia[cardiovascular_arrhythmia$exposure==i,])
}
cardiovascular_DBP <- droplevels(cardiovascular_DBP)
for(i in levels(cardiovascular_DBP$exposure)) {
  nam <- paste("cardiovascular_DBP", i, sep = "_")
  assign(nam, cardiovascular_DBP[cardiovascular_DBP$exposure==i,])
}
cardiovascular_SBP <- droplevels(cardiovascular_SBP)
for(i in levels(cardiovascular_SBP$exposure)) {
  nam <- paste("cardiovascular_SBP", i, sep = "_")
  assign(nam, cardiovascular_SBP[cardiovascular_SBP$exposure==i,])
}
`cardiovascular_coronary artery disease` <- droplevels(`cardiovascular_coronary artery disease`)
for(i in levels(`cardiovascular_coronary artery disease`$exposure)) {
  nam <- paste("cardiovascular_coronary_artery_disease", i, sep = "_")
  assign(nam, `cardiovascular_coronary artery disease`[`cardiovascular_coronary artery disease`$exposure==i,])
}
rm(cardiovascular_arrhythmia, cardiovascular_DBP, `cardiovascular_DBP_birth weight`, cardiovascular_DBP_WHR, cardiovascular_SBP, `cardiovascular_SBP_birth weight`,
   cardiovascular_SBP_WHR, `cardiovascular_coronary artery disease`, `cardiovascular_coronary_artery_disease_BMI increasing and WHR decreasing`,
   `cardiovascular_coronary_artery_disease_BMI increasing and WHR increasing`, `cardiovascular_coronary_artery_disease_hepatic fat`, 
   cardiovascular_coronary_artery_disease_WCadjBMI)

# remove data frames with one study ID or 1 result
rm(`cardiovascular_arrhythmia_birth weight`, cardiovascular_arrhythmia_BMI, `cardiovascular_arrhythmia_fat free mass`, `cardiovascular_arrhythmia_fat mass`,
   cardiovascular_arrhythmia_WHRadjBMI)

# save data frames
write.csv(`cardiovascular_cardiovascular disease`, "analysis/meta_analysis/manual_check/cardiovascular_cardiovascular_disease.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_carotid IMT`, "analysis/meta_analysis/manual_check/cardiovascular_carotid_IMT.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_venous thromboembolism`, "analysis/meta_analysis/manual_check/cardiovascular_venous_thromboembolism.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_heart rate`, "analysis/meta_analysis/manual_check/cardiovascular_heart_rate.csv", 
            row.names = FALSE)
write.csv(cardiovascular_hypertension, "analysis/meta_analysis/manual_check/cardiovascular_hypertension.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_myocardial infarction`, "analysis/meta_analysis/manual_check/cardiovascular_myocardial_infarction.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_heart failure`, "analysis/meta_analysis/manual_check/cardiovascular_heart_failure.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_deep vein thrombosis`, "analysis/meta_analysis/manual_check/cardiovascular_deep_vein_thrombosis.csv", 
            row.names = FALSE)
write.csv(cardiovascular_DBP_BMI, "analysis/meta_analysis/manual_check/cardiovascular_DBP_BMI.csv", 
            row.names = FALSE)
write.csv(cardiovascular_DBP_WHRadjBMI, "analysis/meta_analysis/manual_check/cardiovascular_DBP_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(cardiovascular_SBP_BMI, "analysis/meta_analysis/manual_check/cardiovascular_SBP_BMI.csv", 
            row.names = FALSE)
write.csv(cardiovascular_SBP_WHRadjBMI, "analysis/meta_analysis/manual_check/cardiovascular_SBP_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`cardiovascular_coronary_artery_disease_birth weight`, "analysis/meta_analysis/manual_check/cardiovascular_coronary_artery_disease_birth_weight.csv", 
            row.names = FALSE)
write.csv(cardiovascular_coronary_artery_disease_WHR, "analysis/meta_analysis/manual_check/cardiovascular_coronary_artery_disease_WHR.csv", 
            row.names = FALSE)
write.csv(cardiovascular_coronary_artery_disease_WHRadjBMI, "analysis/meta_analysis/manual_check/cardiovascular_coronary_artery_disease_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(cardiovascular_coronary_artery_disease_BMI, "analysis/meta_analysis/manual_check/cardiovascular_coronary_artery_disease_BMI.csv", 
            row.names = FALSE)

rm(`cardiovascular_cardiovascular disease`, `cardiovascular_carotid IMT`, `cardiovascular_venous thromboembolism`, `cardiovascular_heart rate`,
   cardiovascular_hypertension, `cardiovascular_myocardial infarction`, `cardiovascular_heart failure`, `cardiovascular_deep vein thrombosis`,
   cardiovascular_DBP_BMI, cardiovascular_DBP_WHRadjBMI, cardiovascular_SBP_BMI, cardiovascular_SBP_WHRadjBMI, `cardiovascular_coronary_artery_disease_birth weight`,
   cardiovascular_coronary_artery_disease_WHR, cardiovascular_coronary_artery_disease_WHRadjBMI, cardiovascular_coronary_artery_disease_BMI)

rm(list=setdiff(ls(), c("data")))





# gastrointestinal outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "gastrointestinal")))

# subset for data
gastrointestinal <- droplevels(gastrointestinal)
# create data frames for each outcome for the group
table(gastrointestinal$outcome)
for(i in levels(gastrointestinal$outcome)) {
  nam <- paste("gastrointestinal", i, sep = "_")
  assign(nam, gastrointestinal[gastrointestinal$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`gastrointestinal_acid reflux`, `gastrointestinal_crohn’s disease`, gastrointestinal_gallstones, `gastrointestinal_inflammatory bowel disease`, `gastrointestinal_ulcerative colitis`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`gastrointestinal_gallstone disease`, `gastrointestinal_Helicobacter pylori`, `gastrointestinal_peptic ulcer`)
# separate out exposures
`gastrointestinal_irritable bowel syndrome` <- droplevels(`gastrointestinal_irritable bowel syndrome`)
for(i in levels(`gastrointestinal_irritable bowel syndrome`$exposure)) {
  nam <- paste("gastrointestinal_irritable bowel syndrome", i, sep = "_")
  assign(nam, `gastrointestinal_irritable bowel syndrome`[`gastrointestinal_irritable bowel syndrome`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(gastrointestinal, `gastrointestinal_irritable bowel syndrome`)
# remove data frames with one result
rm(`gastrointestinal_irritable bowel syndrome_BMI`)
# save data frames and check manually for meta-analysis criteria
write.csv(`gastrointestinal_irritable bowel syndrome_WHRadjBMI`, "analysis/meta_analysis/manual_check/gastrointestinal_IBS_WHRadjBMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))







# hepatic outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "hepatic")))

# subset for data
hepatic <- droplevels(hepatic)
# create data frames for each outcome for the group
table(hepatic$outcome)
for(i in levels(hepatic$outcome)) {
  nam <- paste("hepatic", i, sep = "_")
  assign(nam, hepatic[hepatic$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(hepatic_AST, `hepatic_hepatocellular ballooning`, `hepatic_liver fibrosis`, `hepatic_lobular necroinflammation`, `hepatic_primary biliary cirrhosis`, `hepatic_primary sclerosing cholangitis`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`hepatic_chronic liver disease`, `hepatic_liver disease`, `hepatic_non-alcoholic fatty liver disease`)
# separate out exposures
hepatic_ALT <- droplevels(hepatic_ALT)
for(i in levels(hepatic_ALT$exposure)) {
  nam <- paste("hepatic_ALT", i, sep = "_")
  assign(nam, hepatic_ALT[hepatic_ALT$exposure==i,])
}
hepatic_GGT <- droplevels(hepatic_GGT)
for(i in levels(hepatic_GGT$exposure)) {
  nam <- paste("hepatic_GGT", i, sep = "_")
  assign(nam, hepatic_GGT[hepatic_GGT$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(hepatic, hepatic_ALT, hepatic_GGT, `hepatic_ALT_hepatic fat`)
# save data frames and check manually for meta-analysis criteria
write.csv(hepatic_ALT_BMI, "analysis/meta_analysis/manual_check/hepatic_ALT_BMI.csv", 
            row.names = FALSE)
write.csv(hepatic_GGT_BMI, "analysis/meta_analysis/manual_check/hepatic_GGT_BMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))


# immune outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "immune")))

# subset for data
immune <- droplevels(immune)
# create data frames for each outcome for the group
table(immune$outcome)
for(i in levels(immune$outcome)) {
  nam <- paste("immune", i, sep = "_")
  assign(nam, immune[immune$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`immune_allergic sensitisation`, `immune_celiac disease`, immune_IgE, immune_lupus)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`immune_allergic rhinitis`, immune_dermatophytosis, immune_psoriasis)
# separate out exposures
`immune_hay fever` <- droplevels(`immune_hay fever`)
for(i in levels(`immune_hay fever`$exposure)) {
  nam <- paste("immune_hay fever", i, sep = "_")
  assign(nam, `immune_hay fever`[`immune_hay fever`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(immune, `immune_hay fever`)
# remove data frames with one result
rm(`immune_hay fever_BMI`, `immune_hay fever_WHRadjBMI`)
# save data frames and check manually for meta-analysis criteria
## nothing left to save
rm(list=setdiff(ls(), c("data")))






# mental health outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "mental health")))

# subset for data
`mental health` <- droplevels(`mental health`)
# create data frames for each outcome for the group
table(`mental health`$outcome)
for(i in levels(`mental health`$outcome)) {
  nam <- paste("mental_health", i, sep = "_")
  assign(nam, `mental health`[`mental health`$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(mental_health_ADHD, `mental_health_anorexia nervosa`, `mental_health_attention/activity symptoms score`, `mental_health_being a nervous person`,
   `mental_health_being a worrier`, `mental_health_being tense/highly-strung`, `mental_health_body dissatisfaction`, `mental_health_bulimia nervosa`, `mental_health_burden of compulsions obsessions score`,
   mental_health_happiness, `mental_health_particular fears score`, `mental_health_post traumatic stress disorder`, mental_health_schizophrenia,
   `mental_health_SDQ emotional symptoms score`, `mental_health_self esteem: global self worth score`, `mental_health_suffering from nerves`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`mental_health_acute reaction to stress`, `mental_health_binge eating and overeating`, `mental_health_common mental health disorders`, `mental_health_food restriction`, mental_health_loneliness, 
   `mental_health_psychiatric disorder`, `mental_health_psychological distress`, `mental_health_weight and shape concerns`)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
rm(mental_health_anxiety)
# separate out exposures
mental_health_depression <- droplevels(mental_health_depression)
for(i in levels(mental_health_depression$exposure)) {
  nam <- paste("mental_health_depression", i, sep = "_")
  assign(nam, mental_health_depression[mental_health_depression$exposure==i,])
}
`mental_health_subjective wellbeing` <- droplevels(`mental_health_subjective wellbeing`)
for(i in levels(`mental_health_subjective wellbeing`$exposure)) {
  nam <- paste("mental_health_subjective wellbeing", i, sep = "_")
  assign(nam, `mental_health_subjective wellbeing`[`mental_health_subjective wellbeing`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(`mental health`, mental_health_depression, `mental_health_subjective wellbeing`)
# remove data frames with one result
rm(`mental_health_depression_birth weight`, `mental_health_depression_body fat mass`, `mental_health_depression_body fat percentage`, `mental_health_depression_body non-fat mass`,
   mental_health_depression_weight, `mental_health_subjective wellbeing_body fat percentage`, `mental_health_subjective wellbeing_WC`, `mental_health_subjective wellbeing_WHR`)
# remove data frames with only one study ID
rm(`mental_health_depression_fat mass`, `mental_health_depression_fat percentage`, `mental_health_depression_favourable adiposity`, `mental_health_depression_non-fat mass`)
# save data frames and check manually for meta-analysis criteria
write.csv(mental_health_depression_BMI, "analysis/meta_analysis/manual_check/mental_health_depression_BMI.csv", 
            row.names = FALSE)
write.csv(mental_health_depression_WHRadjBMI, "analysis/meta_analysis/manual_check/mental_health_depression_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`mental_health_subjective wellbeing_BMI`, "analysis/meta_analysis/manual_check/mental_health_wellbeing_BMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))



# metabolic outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "metabolic")))

# subset for data
metabolic <- droplevels(metabolic)
# create data frames for each outcome for the group
table(metabolic$outcome)
for(i in levels(metabolic$outcome)) {
  nam <- paste("metabolic", i, sep = "_")
  assign(nam, metabolic[metabolic$outcome==i,])
}
rm(i, nam)

# remove outcomes with only 1 observation
rm(`metabolic_137 metabolites`, metabolic_acetate, metabolic_acetoacetate, metabolic_adiponectin, metabolic_alanine, 
   `metabolic_beta hydroxy butyrate`, metabolic_bilirubin, `metabolic_cholesterol esterification`, metabolic_citrate,
   metabolic_cotinine, metabolic_creatinine, metabolic_ELVLDL, `metabolic_fatty acid chain length`, `metabolic_fetuin-A`,
   metabolic_fibrinogen, metabolic_glutamine, metabolic_glycerol, metabolic_glycine, `metabolic_glycoprotein acetyls`, 
   `metabolic_HDL particle size`, metabolic_histidine, metabolic_homocysteine, metabolic_hyperthyroidism, metabolic_hyperuricaemia,
   metabolic_hypothyroidism, metabolic_isoleucine, metabolic_lactate,
   `metabolic_LDL particle size`, metabolic_leucine, metabolic_LHDL, `metabolic_linoleic acid`, metabolic_LLDL,
   metabolic_LVLDL, metabolic_MHDL, metabolic_MLDL, metabolic_MVLDL, `metabolic_nicotine metabolite ratio`, `metabolic_non-HDL cholesterol`,
   metabolic_phenylalanine, metabolic_phosphatidylcholines, metabolic_phosphoglycerides, `metabolic_phospholipase activity`,
   metabolic_proinsulin, metabolic_pyruvate, `metabolic_ratio of double bonds to fatty acids`, `metabolic_ratio of methylene groups to fatty acids`,
   `metabolic_serum testosterone status`, metabolic_SHDL, metabolic_SLDL, metabolic_sphingomyelin, metabolic_SVLDL, 
   `metabolic_total fatty acids`, metabolic_tyrosine, metabolic_urea, metabolic_valine,
   `metabolic_VLDL particle size`, metabolic_VLHDL, metabolic_VLVLDL, metabolic_VSVLDL, metabolic_ALT, metabolic_diabetes,
   `metabolic_docosahexaenoic acid`, `metabolic_lipoprotein(a)`, metabolic_GGT, `metabolic_Hb concentration`)

# remove outcomes with only 1 study
rm(metabolic_AMY1, metabolic_AMY2, metabolic_anemia, metabolic_creatine, `metabolic_free T3`, `metabolic_free T4`,
   `metabolic_glucose deterioration`, `metabolic_metabolic syndrome`, metabolic_MUFA, metabolic_PUFA, `metabolic_saturated fatty acids`,
   metabolic_SHBG, metabolic_testosterone, `metabolic_vitamin D`, `metabolic_apoA-IV`, `metabolic_n-3 fatty acids`, `metabolic_n-6 fatty acids`, metabolic_IDL)

# remove data frames and rows with no meta-analysable exposures (e.g. a data frame of 2 results but one is BMI and one is WHR)
metabolic_albumin <- metabolic_albumin[-2,]
metabolic_cholesterol <- metabolic_cholesterol[-2,]
metabolic_dyslipidemia <- metabolic_dyslipidemia[-4,]
`metabolic_fasting glucose` <- `metabolic_fasting glucose`[-c(19,20,21,24),]
`metabolic_fasting insulin` <- `metabolic_fasting insulin`[-c(19,20,21,23),]
metabolic_glucose <- metabolic_glucose[-2,]
metabolic_HbA1c <- metabolic_HbA1c[-2,]
metabolic_HDL <- metabolic_HDL[-c(6,19,20,21,23),]
`metabolic_HOMA-IR` <- `metabolic_HOMA-IR`[-1,]
metabolic_IL6 <- metabolic_IL6[-2,]
metabolic_insulin <- metabolic_insulin[-2,]
metabolic_LDL <- metabolic_LDL[-c(17,18,19,21),]
metabolic_triglycerides <- metabolic_triglycerides[-c(21,22,23,25),]
`metabolic_two hour glucose` <- `metabolic_two hour glucose`[-c(1,9),]
`metabolic_type 1 diabetes` <- `metabolic_type 1 diabetes`[-9,]
`metabolic_uric acid` <- `metabolic_uric acid`[-c(11,12,14),]

# separate data frames by exposure where appropriate
metabolic_EGFR <- droplevels(metabolic_EGFR)
for(i in levels(metabolic_EGFR$exposure)) {
  nam <- paste("metabolic_EGFR", i, sep = "_")
  assign(nam, metabolic_EGFR[metabolic_EGFR$exposure==i,])
}
`metabolic_fasting glucose` <- droplevels(`metabolic_fasting glucose`)
for(i in levels(`metabolic_fasting glucose`$exposure)) {
  nam <- paste("metabolic_fasting glucose", i, sep = "_")
  assign(nam, `metabolic_fasting glucose`[`metabolic_fasting glucose`$exposure==i,])
}
`metabolic_fasting insulin` <- droplevels(`metabolic_fasting insulin`)
for(i in levels(`metabolic_fasting insulin`$exposure)) {
  nam <- paste("metabolic_fasting insulin", i, sep = "_")
  assign(nam, `metabolic_fasting insulin`[`metabolic_fasting insulin`$exposure==i,])
}
`metabolic_Gutt index` <- droplevels(`metabolic_Gutt index`)
for(i in levels(`metabolic_Gutt index`$exposure)) {
  nam <- paste("metabolic_Gutt index", i, sep = "_")
  assign(nam, `metabolic_Gutt index`[`metabolic_Gutt index`$exposure==i,])
}
metabolic_HDL <- droplevels(metabolic_HDL)
for(i in levels(metabolic_HDL$exposure)) {
  nam <- paste("metabolic_HDL", i, sep = "_")
  assign(nam, metabolic_HDL[metabolic_HDL$exposure==i,])
}
`metabolic_HOMA-B` <- droplevels(`metabolic_HOMA-B`)
for(i in levels(`metabolic_HOMA-B`$exposure)) {
  nam <- paste("metabolic_HOMA_B", i, sep = "_")
  assign(nam, `metabolic_HOMA-B`[`metabolic_HOMA-B`$exposure==i,])
}
`metabolic_HOMA-IR` <- droplevels(`metabolic_HOMA-IR`)
for(i in levels(`metabolic_HOMA-IR`$exposure)) {
  nam <- paste("metabolic_HOMA_IR", i, sep = "_")
  assign(nam, `metabolic_HOMA-IR`[`metabolic_HOMA-IR`$exposure==i,])
}
`metabolic_insulin secretion` <- droplevels(`metabolic_insulin secretion`)
for(i in levels(`metabolic_insulin secretion`$exposure)) {
  nam <- paste("metabolic_insulin_secretion", i, sep = "_")
  assign(nam, `metabolic_insulin secretion`[`metabolic_insulin secretion`$exposure==i,])
}
metabolic_LDL <- droplevels(metabolic_LDL)
for(i in levels(metabolic_LDL$exposure)) {
  nam <- paste("metabolic_LDL", i, sep = "_")
  assign(nam, metabolic_LDL[metabolic_LDL$exposure==i,])
}
metabolic_triglycerides <- droplevels(metabolic_triglycerides)
for(i in levels(metabolic_triglycerides$exposure)) {
  nam <- paste("metabolic_triglycerides", i, sep = "_")
  assign(nam, metabolic_triglycerides[metabolic_triglycerides$exposure==i,])
}
`metabolic_type 2 diabetes` <- droplevels(`metabolic_type 2 diabetes`)
for(i in levels(`metabolic_type 2 diabetes`$exposure)) {
  nam <- paste("metabolic_type2_diabetes", i, sep = "_")
  assign(nam, `metabolic_type 2 diabetes`[`metabolic_type 2 diabetes`$exposure==i,])
}
metabolic_urate <- droplevels(metabolic_urate)
for(i in levels(metabolic_urate$exposure)) {
  nam <- paste("metabolic_urate", i, sep = "_")
  assign(nam, metabolic_urate[metabolic_urate$exposure==i,])
}

# remove data frames with one study ID or 1 result
rm(metabolic_EGFR, `metabolic_fasting glucose`, `metabolic_fasting glucose_WHR`, `metabolic_fasting insulin`, `metabolic_fasting insulin_WHR`,
   `metabolic_Gutt index`, metabolic_HDL, `metabolic_HDL_birth weight`, `metabolic_HOMA-B`, `metabolic_HOMA-IR`, `metabolic_insulin secretion`,
   metabolic_LDL, `metabolic_LDL_birth weight`, metabolic_triglycerides, `metabolic_triglycerides_birth weight`, `metabolic_type 2 diabetes`,
   `metabolic_type2_diabetes_BMI increasing and WHR decreasing`, `metabolic_type2_diabetes_BMI increasing and WHR increasing`,
   `metabolic_type2_diabetes_hepatic fat`, metabolic_type2_diabetes_WC, metabolic_type2_diabetes_WHR, metabolic_urate,
   metabolic_urate_WHRadjBMI, metabolic_VLDL)

# save data frames
write.csv(`metabolic_25(OH)D`, "analysis/meta_analysis/manual_check/metabolic_25OHD.csv", 
            row.names = FALSE)
write.csv(metabolic_albumin, "analysis/meta_analysis/manual_check/metabolic_albumin.csv", 
            row.names = FALSE)
write.csv(metabolic_apoA1, "analysis/meta_analysis/manual_check/metabolic_apoA1.csv", 
            row.names = FALSE)
write.csv(metabolic_apoB, "analysis/meta_analysis/manual_check/metabolic_apoB.csv", 
            row.names = FALSE)
write.csv(metabolic_cholesterol, "analysis/meta_analysis/manual_check/metabolic_cholesterol.csv", 
            row.names = FALSE)
write.csv(metabolic_CRP, "analysis/meta_analysis/manual_check/metabolic_CRP.csv", 
            row.names = FALSE)
write.csv(metabolic_dyslipidemia, "analysis/meta_analysis/manual_check/metabolic_dyslipidemia.csv", 
            row.names = FALSE)
write.csv(metabolic_EGFR_BMI, "analysis/meta_analysis/manual_check/metabolic_EGFR_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_EGFR_WHRadjBMI, "analysis/meta_analysis/manual_check/metabolic_EGFR_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_fasting glucose_BMI`, "analysis/meta_analysis/manual_check/metabolic_fasting_glucose_BMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_fasting glucose_WHRadjBMI`, "analysis/meta_analysis/manual_check/metabolic_fasting_glucose_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_fasting insulin_BMI`, "analysis/meta_analysis/manual_check/metabolic_fasting_insulin_BMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_fasting insulin_WHRadjBMI`, "analysis/meta_analysis/manual_check/metabolic_fasting_insulin_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(metabolic_glucose, "analysis/meta_analysis/manual_check/metabolic_glucose.csv", 
            row.names = FALSE)
write.csv(`metabolic_Gutt index_BMI`, "analysis/meta_analysis/manual_check/metabolic_Gutt_index_BMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_Gutt index_WHR`, "analysis/meta_analysis/manual_check/metabolic_Gutt_index_WHR.csv", 
            row.names = FALSE)
write.csv(metabolic_HbA1c, "analysis/meta_analysis/manual_check/metabolic_HbA1c.csv", 
            row.names = FALSE)
write.csv(metabolic_HDL_BMI, "analysis/meta_analysis/manual_check/metabolic_HDL_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_HDL_WHRadjBMI, "analysis/meta_analysis/manual_check/metabolic_HDL_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(metabolic_HOMA_B_BMI, "analysis/meta_analysis/manual_check/metabolic_HOMA_B_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_HOMA_B_WHR, "analysis/meta_analysis/manual_check/metabolic_HOMA_B_WHR.csv", 
            row.names = FALSE)
write.csv(metabolic_HOMA_IR_BMI, "analysis/meta_analysis/manual_check/metabolic_HOMA_IR_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_HOMA_IR_WHR, "analysis/meta_analysis/manual_check/metabolic_HOMA_IR_WHR.csv", 
            row.names = FALSE)
write.csv(metabolic_IL6, "analysis/meta_analysis/manual_check/metabolic_IL6.csv", 
            row.names = FALSE)
write.csv(metabolic_insulin, "analysis/meta_analysis/manual_check/metabolic_insulin.csv", 
            row.names = FALSE)
write.csv(metabolic_insulin_secretion_BMI, "analysis/meta_analysis/manual_check/metabolic_insulin_secretion_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_insulin_secretion_WHR, "analysis/meta_analysis/manual_check/metabolic_insulin_secretion_WHR.csv", 
            row.names = FALSE)
write.csv(metabolic_LDL_BMI, "analysis/meta_analysis/manual_check/metabolic_LDL_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_LDL_WHRadjBMI, "analysis/meta_analysis/manual_check/metabolic_LDL_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(metabolic_leptin, "analysis/meta_analysis/manual_check/metabolic_leptin.csv", 
            row.names = FALSE)
write.csv(metabolic_triglycerides_BMI, "analysis/meta_analysis/manual_check/metabolic_triglycerides_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_triglycerides_WHRadjBMI, "analysis/meta_analysis/manual_check/metabolic_triglycerides_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_two hour glucose`, "analysis/meta_analysis/manual_check/metabolic_two_hour_glucose.csv", 
            row.names = FALSE)
write.csv(`metabolic_type 1 diabetes`, "analysis/meta_analysis/manual_check/metabolic_type1_diabetes.csv", 
            row.names = FALSE)
write.csv(`metabolic_type2_diabetes_birth weight`, "analysis/meta_analysis/manual_check/metabolic_type2_diabetes_birth_weight.csv", 
            row.names = FALSE)
write.csv(metabolic_type2_diabetes_BMI, "analysis/meta_analysis/manual_check/metabolic_type2_diabetes_BMI.csv", 
            row.names = FALSE)
write.csv(metabolic_type2_diabetes_WHRadjBMI, "analysis/meta_analysis/manual_check/metabolic_type2_diabetes_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(metabolic_urate_BMI, "analysis/meta_analysis/manual_check/metabolic_urate_BMI.csv", 
            row.names = FALSE)
write.csv(`metabolic_uric acid`, "analysis/meta_analysis/manual_check/metabolic_uric_acid.csv", 
            row.names = FALSE)

rm(`metabolic_25(OH)D`, metabolic_albumin, metabolic_apoA1, metabolic_apoB, metabolic_cholesterol, metabolic_CRP,
   metabolic_dyslipidemia, metabolic_EGFR_BMI, metabolic_EGFR_WHRadjBMI, `metabolic_fasting glucose_BMI`, `metabolic_fasting glucose_WHRadjBMI`,
   `metabolic_fasting insulin_BMI`, `metabolic_fasting insulin_WHRadjBMI`, metabolic_glucose, `metabolic_Gutt index_BMI`,
   `metabolic_Gutt index_WHR`,metabolic_HbA1c, metabolic_HDL_BMI, metabolic_HDL_WHRadjBMI, metabolic_HOMA_B_BMI, metabolic_HOMA_B_WHR,
   metabolic_HOMA_IR_BMI, metabolic_HOMA_IR_WHR, metabolic_IL6, metabolic_insulin, metabolic_insulin_secretion_BMI,
   metabolic_insulin_secretion_WHR, metabolic_LDL_BMI, metabolic_LDL_WHRadjBMI, metabolic_leptin, metabolic_triglycerides_BMI,
   metabolic_triglycerides_WHRadjBMI, `metabolic_two hour glucose`, `metabolic_type 1 diabetes`, `metabolic_type2_diabetes_birth weight`,
   metabolic_type2_diabetes_BMI, metabolic_type2_diabetes_WHRadjBMI, metabolic_urate_BMI, `metabolic_uric acid`)

rm(list=setdiff(ls(), c("data")))





# other outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "other")))

# subset for data
other <- droplevels(other)
# create data frames for each outcome for the group
table(other$outcome)
for(i in levels(other$outcome)) {
  nam <- paste("other", i, sep = "_")
  assign(nam, other[other$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`other_age-related macular degeneration`, `other_benign enlarged prostate`, `other_hygiene score`, `other_telomere length`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(other_cataract, `other_disease count`, other_hernia, `other_macular degeneration`, other_periodontitis, `other_physical activity`)
# separate out exposures
`other_methylation (cpg)` <- droplevels(`other_methylation (cpg)`)
for(i in levels(`other_methylation (cpg)`$exposure)) {
  nam <- paste("other_methylation_cpg", i, sep = "_")
  assign(nam, `other_methylation (cpg)`[`other_methylation (cpg)`$exposure==i,])
}
other_mortality <- droplevels(other_mortality)
for(i in levels(other_mortality$exposure)) {
  nam <- paste("other_mortality", i, sep = "_")
  assign(nam, other_mortality[other_mortality$exposure==i,])
}
other_sleep <- droplevels(other_sleep)
for(i in levels(other_sleep$exposure)) {
  nam <- paste("other_sleep", i, sep = "_")
  assign(nam, other_sleep[other_sleep$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(`other_methylation (cpg)`, other_mortality, other_sleep)
# remove data frames with one result
rm(other_methylation_cpg_obesity, other_sleep_WHRadjBMI)
# remove data frames with only one study ID
rm(other_methylation_cpg_adiponectin, `other_methylation_cpg_birth weight`, other_methylation_cpg_HC, `other_methylation_cpg_Obesity class 1`, other_methylation_cpg_WC)
# remove methylation data frame with only one study ID or only one result
rm(other_methylation_cpg_BMI)
# separate out specific outcomes 
other_mortality_BMI <- droplevels(other_mortality_BMI)
for(i in levels(other_mortality_BMI$outcome_info)) {
  nam <- paste("other_mortality_BMI", i, sep = "_")
  assign(nam, other_mortality_BMI[other_mortality_BMI$outcome_info==i,])
}
other_sleep_BMI <- droplevels(other_sleep_BMI)
for(i in levels(other_sleep_BMI$outcome_info)) {
  nam <- paste("other_sleep_BMI", i, sep = "_")
  assign(nam, other_sleep_BMI[other_sleep_BMI$outcome_info==i,])
}
rm(i, nam)
# remove master and data frames with 1 result and 1 study ID
rm(other)
rm(other_mortality_BMI, `other_mortality_BMI_all cancer`, `other_mortality_BMI_all cardiovascular`, `other_mortality_BMI_aortic aneurysm`, `other_mortality_BMI_bladder cancer`,
   `other_mortality_BMI_brain cancer`, `other_mortality_BMI_breast cancer premenopausal`, `other_mortality_BMI_breats cancer postmenopausal`, `other_mortality_BMI_colorectal cancer`,
   `other_mortality_BMI_coronary artery disease`, `other_mortality_BMI_endometrial cancer`, `other_mortality_BMI_esophageal cancer`, `other_mortality_BMI_external cause`,
   other_mortality_BMI_incident, `other_mortality_BMI_kidney cancer`, `other_mortality_BMI_liver cancer`, `other_mortality_BMI_lung cancer`, 
   `other_mortality_BMI_lymphatic cancer`, `other_mortality_BMI_malignant melanoma`, `other_mortality_BMI_other cancer not including: lung, colorectal, pancreatic, stomach, esophageal, malignant melanoma, kidney, bladder, brain, liver, lymphatic`,
   `other_mortality_BMI_other cardiovascular not including: coronary artery disease, stroke, aortic anurysm`, `other_mortality_BMI_ovarian cancer`, `other_mortality_BMI_pancreatic cancer`,
   `other_mortality_BMI_prostate cancer`, other_mortality_BMI_respiratory, `other_mortality_BMI_stomach cancer`, other_mortality_BMI_stroke)
rm(other_sleep_BMI, `other_sleep_BMI_daytime sleepiness`, other_sleep_BMI_insomnia, other_sleep_BMI_chronotype, `other_sleep_BMI_hours slept`, other_sleep_BMI_oversleeper, other_sleep_BMI_undersleeper)
# remove respiratory_asthma_BMI data frames with 1 study ID
# save data frames and check manually for meta-analysis criteria
write.csv(`other_mortality_BMI_all cause`, "analysis/meta_analysis/manual_check/other_mortality_BMI_all_cause.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))



# renal outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "renal")))

# subset for data
renal <- droplevels(renal)
# create data frames for each outcome for the group
table(renal$outcome)
for(i in levels(renal$outcome)) {
  nam <- paste("renal", i, sep = "_")
  assign(nam, renal[renal$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
# rm()
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(renal_macroalbuminuria, `renal_renal failure`)
# separate out exposures
`renal_renal disease` <- droplevels(`renal_renal disease`)
for(i in levels(`renal_renal disease`$exposure)) {
  nam <- paste("renal_renal disease", i, sep = "_")
  assign(nam, `renal_renal disease`[`renal_renal disease`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(renal, `renal_renal disease`)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
# separate out specific outcomes for brain_stroke_BMI
`renal_renal disease_BMI` <- droplevels(`renal_renal disease_BMI`)
for(i in levels(`renal_renal disease_BMI`$outcome_info)) {
  nam <- paste("renal_renal disease_BMI", i, sep = "_")
  assign(nam, `renal_renal disease_BMI`[`renal_renal disease_BMI`$outcome_info==i,])
}
rm(i, nam)
# remove master and data frames with 1 result
rm(`renal_renal disease_BMI`)
# remove data frames without multiple study IDs
rm(`renal_renal disease_BMI_diabetic kidney disease`, `renal_renal disease_BMI_end stage kidney disease`)
# save data frames and check manually for meta-analysis criteria
## nothing left to save
rm(list=setdiff(ls(), c("data")))



# reproductive outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "reproductive")))

# subset for data
reproductive <- droplevels(reproductive)
# create data frames for each outcome for the group
table(reproductive$outcome)
for(i in levels(reproductive$outcome)) {
  nam <- paste("reproductive", i, sep = "_")
  assign(nam, reproductive[reproductive$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`reproductive_uterine fibroids`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
# rm()
# separate out exposures
reproductive_menarche <- droplevels(reproductive_menarche)
for(i in levels(reproductive_menarche$exposure)) {
  nam <- paste("reproductive_menarche", i, sep = "_")
  assign(nam, reproductive_menarche[reproductive_menarche$exposure==i,])
}
reproductive_PCOS <- droplevels(reproductive_PCOS)
for(i in levels(reproductive_PCOS$exposure)) {
  nam <- paste("reproductive_PCOS", i, sep = "_")
  assign(nam, reproductive_PCOS[reproductive_PCOS$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(reproductive, reproductive_menarche, reproductive_PCOS)
# remove data frames with one result
rm(`reproductive_menarche_fat free mass`, reproductive_menarche_HC, `reproductive_menarche_sum of skinfolds`, `reproductive_menarche_total body fat`)
# save data frames and check manually for meta-analysis criteria
write.csv(reproductive_menarche_BMI, "analysis/meta_analysis/manual_check/reproductive_menarche_BMI.csv", 
            row.names = FALSE)
write.csv(reproductive_PCOS_BMI, "analysis/meta_analysis/manual_check/reproductive_PCOS_BMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))






# respiratory outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "respiratory")))

# subset for data
respiratory <- droplevels(respiratory)
# create data frames for each outcome for the group
table(respiratory$outcome)
for(i in levels(respiratory$outcome)) {
  nam <- paste("respiratory", i, sep = "_")
  assign(nam, respiratory[respiratory$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(respiratory_pneumonia)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(respiratory_FEV1, `respiratory_FEV1:FVC ratio`, respiratory_wheezing)
# separate out exposures
respiratory_asthma <- droplevels(respiratory_asthma)
for(i in levels(respiratory_asthma$exposure)) {
  nam <- paste("respiratory_asthma", i, sep = "_")
  assign(nam, respiratory_asthma[respiratory_asthma$exposure==i,])
}
`respiratory_chronic obstructive pulmonary disorder` <- droplevels(`respiratory_chronic obstructive pulmonary disorder`)
for(i in levels(`respiratory_chronic obstructive pulmonary disorder`$exposure)) {
  nam <- paste("respiratory_chronic obstructive pulmonary disorder", i, sep = "_")
  assign(nam, `respiratory_chronic obstructive pulmonary disorder`[`respiratory_chronic obstructive pulmonary disorder`$exposure==i,])
}
respiratory_FVC <- droplevels(respiratory_FVC)
for(i in levels(respiratory_FVC$exposure)) {
  nam <- paste("respiratory_FVC", i, sep = "_")
  assign(nam, respiratory_FVC[respiratory_FVC$exposure==i,])
}
respiratory_smoking <- droplevels(respiratory_smoking)
for(i in levels(respiratory_smoking$exposure)) {
  nam <- paste("respiratory_smoking", i, sep = "_")
  assign(nam, respiratory_smoking[respiratory_smoking$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(respiratory, respiratory_asthma, `respiratory_chronic obstructive pulmonary disorder`, respiratory_FVC, respiratory_smoking)
# remove data frames with one result
rm(`respiratory_asthma_birth weight`, `respiratory_chronic obstructive pulmonary disorder_WHRadjBMI`)
# remove data frames with only one study ID
rm(`respiratory_asthma_fat mass`, `respiratory_asthma_fat-free mass`, `respiratory_asthma_lean mass`, `respiratory_asthma_sum of skinfolds`, `respiratory_asthma_total body fat`, respiratory_asthma_WHR, 
   `respiratory_chronic obstructive pulmonary disorder_BMI`, `respiratory_chronic obstructive pulmonary disorder_WHR`)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
rm(respiratory_smoking_BMI)
# separate out specific outcomes for respiratory_asthma_BMI
respiratory_asthma_BMI <- droplevels(respiratory_asthma_BMI)
for(i in levels(respiratory_asthma_BMI$outcome_info)) {
  nam <- paste("respiratory_asthma_BMI", i, sep = "_")
  assign(nam, respiratory_asthma_BMI[respiratory_asthma_BMI$outcome_info==i,])
}
rm(i, nam)
# remove master respiratory_asthma_BMI and data frames with 1 result
rm(respiratory_asthma_BMI)
# remove respiratory_asthma_BMI data frames with 1 study ID
rm(respiratory_asthma_BMI_active, `respiratory_asthma_BMI_atopic, doctor diagnosed`, `respiratory_asthma_BMI_current, doctor diagnosed`, respiratory_asthma_BMI_current, 
   `respiratory_asthma_BMI_non-atopic, doctor diagnosed`, `respiratory_asthma_BMI_without wheezing`)
# save data frames and check manually for meta-analysis criteria
write.csv(respiratory_asthma_BMI_asthma, "analysis/meta_analysis/manual_check/respiratory_asthma_BMI_asthma.csv", 
            row.names = FALSE)
write.csv(respiratory_asthma_BMI_atopic, "analysis/meta_analysis/manual_check/respiratory_asthma_BMI_atopic.csv", 
            row.names = FALSE)
write.csv(`respiratory_asthma_BMI_non-atopic`, "analysis/meta_analysis/manual_check/respiratory_asthma_BMI_non_atopic.csv", 
            row.names = FALSE)
write.csv(respiratory_asthma_WHRadjBMI, "analysis/meta_analysis/manual_check/respiratory_asthma_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(respiratory_FVC_BMI, "analysis/meta_analysis/manual_check/respiratory_FVC_BMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))



# skeletal outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "skeletal")))

# subset for data
skeletal <- droplevels(skeletal)
# create data frames for each outcome for the group
table(skeletal$outcome)
for(i in levels(skeletal$outcome)) {
  nam <- paste("skeletal", i, sep = "_")
  assign(nam, skeletal[skeletal$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`skeletal_back pain`, `skeletal_joint pain`, `skeletal_prolapsed disk`, skeletal_sciatica)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(`skeletal_bone area`, `skeletal_bone mineral content`)
# separate out exposures
skeletal_arthritis <- droplevels(skeletal_arthritis)
for(i in levels(skeletal_arthritis$exposure)) {
  nam <- paste("skeletal_arthritis", i, sep = "_")
  assign(nam, skeletal_arthritis[skeletal_arthritis$exposure==i,])
}
`skeletal_bone mineral density` <- droplevels(`skeletal_bone mineral density`)
for(i in levels(`skeletal_bone mineral density`$exposure)) {
  nam <- paste("skeletal_bone mineral density", i, sep = "_")
  assign(nam, `skeletal_bone mineral density`[`skeletal_bone mineral density`$exposure==i,])
}
skeletal_osteoarthritis <- droplevels(skeletal_osteoarthritis)
for(i in levels(skeletal_osteoarthritis$exposure)) {
  nam <- paste("skeletal_osteoarthritis", i, sep = "_")
  assign(nam, skeletal_osteoarthritis[skeletal_osteoarthritis$exposure==i,])
}
skeletal_osteoporosis <- droplevels(skeletal_osteoporosis)
for(i in levels(skeletal_osteoporosis$exposure)) {
  nam <- paste("skeletal_osteoporosis", i, sep = "_")
  assign(nam, skeletal_osteoporosis[skeletal_osteoporosis$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(skeletal, skeletal_arthritis, `skeletal_bone mineral density`, skeletal_osteoarthritis, skeletal_osteoporosis)
# remove data frames with one result
rm(skeletal_osteoporosis_BMI)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
# remove data frames with only one study ID
rm(`skeletal_arthritis_birth weight`, 
   `skeletal_bone mineral density_body fat mass`, `skeletal_bone mineral density_body fat percentage`,
   `skeletal_osteoarthritis_birth weight`, skeletal_osteoarthritis_HC, skeletal_osteoarthritis_overweight, skeletal_osteoarthritis_WC, skeletal_osteoarthritis_WHR)
# save data frames and check manually for meta-analysis criteria
write.csv(skeletal_arthritis_BMI, "analysis/meta_analysis/manual_check/skeletal_arthritis_BMI.csv", 
            row.names = FALSE)
write.csv(skeletal_arthritis_WHRadjBMI, "analysis/meta_analysis/manual_check/skeletal_arthritis_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(`skeletal_bone mineral density_BMI`, "analysis/meta_analysis/manual_check/skeletal_BMD_BMI.csv", 
            row.names = FALSE)
write.csv(`skeletal_bone mineral density_fat mass`, "analysis/meta_analysis/manual_check/skeletal_BMD_fat_mass.csv", 
            row.names = FALSE)
write.csv(skeletal_osteoarthritis_BMI, "analysis/meta_analysis/manual_check/skeletal_osteoarthritis_BMI.csv", 
            row.names = FALSE)
write.csv(skeletal_osteoarthritis_WHRadjBMI, "analysis/meta_analysis/manual_check/skeletal_osteoarthritis_WHRadjBMI.csv", 
            row.names = FALSE)
write.csv(skeletal_osteoporosis_WHRadjBMI, "analysis/meta_analysis/manual_check/skeletal_osteoporosis_WHRadjBMI.csv", 
            row.names = FALSE)
rm(list=setdiff(ls(), c("data")))


# skin outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "skin")))

# subset for data
skin <- droplevels(skin)
# create data frames for each outcome for the group
table(skin$outcome)
for(i in levels(skin$outcome)) {
  nam <- paste("skin", i, sep = "_")
  assign(nam, skin[skin$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
# rm()
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(skin_psoriasis)
# save data frames and check manually for meta-analysis criteria
## nothing left to save
rm(list=setdiff(ls(), c("data")))






# social outcomes ====
## split into outcome based data frames
for(i in levels(data$outcome_group)) {
  nam <- paste(i)
  assign(nam, data[data$outcome_group==i,])
}
rm(i, nam)
rm(list=setdiff(ls(), c("data", "social")))

# subset for data
social <- droplevels(social)
# create data frames for each outcome for the group
table(social$outcome)
for(i in levels(social$outcome)) {
  nam <- paste("social", i, sep = "_")
  assign(nam, social[social$outcome==i,])
}
rm(i, nam)
# remove outcomes with only 1 observation
rm(`social_annual income`, `social_average social income`, `social_risk taking behaviour`, `social_satisfaction with family`, `social_satisfaction with finances`,
   `social_satisfaction with friends`, `social_satisfaction with health`, `social_satisfaction with work`, `social_social income`, `social_visits from friends and family`, `social_years employed`)
# remove all data frames where only one study id is present, and where there is not multiple studies with teh same exposure/outcome
rm(social_cohabitation, social_confide, `social_participation in activity`, `social_physical activity`)
# separate out exposures
social_education <- droplevels(social_education)
for(i in levels(social_education$exposure)) {
  nam <- paste("social_education", i, sep = "_")
  assign(nam, social_education[social_education$exposure==i,])
}
social_employment <- droplevels(social_employment)
for(i in levels(social_employment$exposure)) {
  nam <- paste("social_employment", i, sep = "_")
  assign(nam, social_employment[social_employment$exposure==i,])
}
social_income <- droplevels(social_income)
for(i in levels(social_income$exposure)) {
  nam <- paste("social_income", i, sep = "_")
  assign(nam, social_income[social_income$exposure==i,])
}
`social_socioeconomic status` <- droplevels(`social_socioeconomic status`)
for(i in levels(`social_socioeconomic status`$exposure)) {
  nam <- paste("social_socioeconomic status", i, sep = "_")
  assign(nam, `social_socioeconomic status`[`social_socioeconomic status`$exposure==i,])
}
rm(i, nam)
# remove master data frames
rm(social, social_education, social_employment, social_income, `social_socioeconomic status`)
# remove data frames and specific rows in data frames where exposure or outcome is sliglthy different
rm(social_employment_BMI)
# save data frames and check manually for meta-analysis criteria
write.csv(social_education_BMI, "analysis/meta_analysis/manual_check/social_education_BMI.csv", 
            row.names = FALSE)
write.csv(social_income_BMI, "analysis/meta_analysis/manual_check/social_income_BMI.csv", 
            row.names = FALSE)
write.csv(`social_socioeconomic status_BMI`, "analysis/meta_analysis/manual_check/social_SES_BMI.csv", 
            row.names = FALSE)
# ====
rm(list=ls())

