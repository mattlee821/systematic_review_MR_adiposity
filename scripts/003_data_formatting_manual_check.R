rm(list=ls())
# load all of the data frames ====
setwd("/Users/ml16847/OneDrive - University of Bristol/001_projects/005_systematic_review/analysis/meta_analysis/manual_check/")
list_files <- list.files("/Users/ml16847/OneDrive - University of Bristol/001_projects/005_systematic_review/analysis/meta_analysis/manual_check/")
list <- list()
for (i in 1:length(list_files)){
  list[[i]] <- (read.csv(list_files[i], header=T))
}
names(list) <- list_files
list2env(list, envir=.GlobalEnv)

# make check data frame ====
data <- as.data.frame(list_files)
data$decision <- ""
data$reason <- ""
colnames(data)[1] <- "data_frame"
write.table(data, "../check_list.txt", 
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
rm(list, list_files, i)

# check each data frame for meta-analysis compatability - save and remove where appropriate ====
## MR method
## effect estimate
## exposure overlap
## outcome overlap
## exposure/outcome overlap

## 1 ====
a = 1
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(anthropometric_WC_WHRadjBMI.csv)

## 2 ====
a = 2
brain_alzheimers_BMI.csv <- brain_alzheimers_BMI.csv[-c(3,4),]
brain_alzheimers_BMI.csv <- brain_alzheimers_BMI.csv[-c(1),]
brain_alzheimers_BMI.csv <- brain_alzheimers_BMI.csv[-c(1),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(brain_alzheimers_BMI.csv, "../data_for_analysis/brain_alzheimers_BMI.csv", row.names = F)
rm(brain_alzheimers_BMI.csv)

## 3 ====
a = 3
brain_multiple_scelrosis_BMI.csv <- brain_multiple_scelrosis_BMI.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(brain_multiple_scelrosis_BMI.csv)

## 4 ====
a = 4
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(brain_stroke_hemorrhagic_BMI.csv, "../data_for_analysis/brain_stroke_hemorrhagic_BMI.csv", row.names = F)
rm(brain_stroke_hemorrhagic_BMI.csv)

## 5 ====
a = 5
brain_stroke_ischemic_BMI.csv <- brain_stroke_ischemic_BMI.csv[-c(5:18),]
brain_stroke_ischemic_BMI.csv <- brain_stroke_ischemic_BMI.csv[-c(2:3),]
brain_stroke_ischemic_BMI.csv <- brain_stroke_ischemic_BMI.csv[-c(2),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(brain_stroke_ischemic_BMI.csv, "../data_for_analysis/brain_stroke_ischemic_BMI.csv", row.names = F)
rm(brain_stroke_ischemic_BMI.csv)

## 6 ====
a = 6
brain_stroke_stroke_BMI.csv <- brain_stroke_stroke_BMI.csv[-c(2:3),]
brain_stroke_stroke_BMI.csv <- brain_stroke_stroke_BMI.csv[-c(2:3),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(brain_stroke_stroke_BMI.csv)

## 7 ====
a = 7
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_any_cancer_BMI.csv)

## 8 ====
a = 8
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_any_cancer_WHRadjBMI.csv)

## 9 ====
a = 9
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_breast_cancer_birthweight_ER.csv, "../data_for_analysis/cancer_breast_cancer_birthweight_ER.csv", row.names = F)
rm(cancer_breast_cancer_birthweight_ER.csv)

## 10 ====
a = 10
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_breast_cancer_birthweight.csv, "../data_for_analysis/cancer_breast_cancer_birthweight.csv", row.names = F)
rm(cancer_breast_cancer_birthweight.csv)

## 11 ====
a = 11
cancer_breast_cancer_BMI_ER.csv <- cancer_breast_cancer_BMI_ER.csv[c(2,4,8),]
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_breast_cancer_BMI_ER.csv)

## 12 ====
a = 12
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_breast_cancer_BMI_postmenopausal.csv)

## 13 ====
a = 13
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_breast_cancer_BMI_premenopausal.csv)

## 14 ====
a = 14
cancer_breast_cancer_BMI.csv <- cancer_breast_cancer_BMI.csv[-c(6,7,8,9,11),]
cancer_breast_cancer_BMI.csv <- cancer_breast_cancer_BMI.csv[-c(7:10),]
cancer_breast_cancer_BMI.csv <- cancer_breast_cancer_BMI.csv[-c(6),]
cancer_breast_cancer_BMI.csv <- cancer_breast_cancer_BMI.csv[-c(1,3),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cancer_breast_cancer_BMI.csv)

## 15 ====
a = 15
data[a,2] <- "N"
data[a,3] <- "not enough information (exposure/outcome study, sex, population)"
rm(cancer_breast_cancer_WHRadjBMI.csv)

## 16 ====
a = 16
cancer_colon_cancer_birthweight.csv <- cancer_colon_cancer_birthweight.csv[c(1,9),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_colon_cancer_birthweight.csv, "../data_for_analysis/cancer_colon_cancer_birthweight.csv", row.names = F)
rm(cancer_colon_cancer_birthweight.csv)

## 17 ====
a = 17
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_colon_cancer_BMI.csv)

## 18 ====
a = 18
cancer_colorectal_cancer_BMI.csv <- cancer_colorectal_cancer_BMI.csv[-c(14:16),]
cancer_colorectal_cancer_BMI.csv <- cancer_colorectal_cancer_BMI.csv[-c(6:12),]
cancer_colorectal_cancer_BMI.csv <- cancer_colorectal_cancer_BMI.csv[-c(1,3),]
cancer_colorectal_cancer_BMI.csv <- cancer_colorectal_cancer_BMI.csv[-2,]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_colorectal_cancer_BMI.csv, "../data_for_analysis/cancer_colorectal_cancer_BMI.csv", row.names = F)
rm(cancer_colorectal_cancer_BMI.csv)

## 19 ====
a = 19
cancer_colorectal_cancer_WHR.csv <- cancer_colorectal_cancer_WHR.csv[c(1,9),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_colorectal_cancer_WHR.csv, "../data_for_analysis/cancer_colorectal_cancer_WHR.csv", row.names = F)
rm(cancer_colorectal_cancer_WHR.csv)


## 20 ====
a = 20
cancer_endometrial_cancer_BMI.csv <- cancer_endometrial_cancer_BMI.csv[-2,]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_endometrial_cancer_BMI.csv, "../data_for_analysis/cancer_endometrial_cancer_BMI.csv", row.names = F)
rm(cancer_endometrial_cancer_BMI.csv)

## 21 ====
a = 21
cancer_kidney_cancer_BMI.csv <- cancer_kidney_cancer_BMI.csv[c(1,5),]
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(cancer_kidney_cancer_BMI.csv)

## 22 ====
a = 22
cancer_lung_cancer_BMI_adenocarcinoma.csv <- cancer_lung_cancer_BMI_adenocarcinoma.csv[-1,]
cancer_lung_cancer_BMI_adenocarcinoma.csv <- cancer_lung_cancer_BMI_adenocarcinoma.csv[-1,]
cancer_lung_cancer_BMI_adenocarcinoma.csv <- cancer_lung_cancer_BMI_adenocarcinoma.csv[c(1,3),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cancer_lung_cancer_BMI_adenocarcinoma.csv)

## 23 ====
a = 23
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cancer_lung_cancer_BMI_ever_smokers.csv)

## 24 ====
a = 24
cancer_lung_cancer_BMI_lung_cancer.csv <- cancer_lung_cancer_BMI_lung_cancer.csv[-c(2,3,4),]
cancer_lung_cancer_BMI_lung_cancer.csv <- cancer_lung_cancer_BMI_lung_cancer.csv[-1,]
cancer_lung_cancer_BMI_lung_cancer.csv <- cancer_lung_cancer_BMI_lung_cancer.csv[-c(2,3),]
cancer_lung_cancer_BMI_lung_cancer.csv <- cancer_lung_cancer_BMI_lung_cancer.csv[c(1,3,6),]
cancer_lung_cancer_BMI_lung_cancer.csv <- cancer_lung_cancer_BMI_lung_cancer.csv[-c(3),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_lung_cancer_BMI_lung_cancer.csv, "../data_for_analysis/cancer_lung_cancer_BMI_lung_cancer.csv", row.names = F)
rm(cancer_lung_cancer_BMI_lung_cancer.csv)

## 25 ====
a = 25
cancer_lung_cancer_BMI_never_smokers.csv <- cancer_lung_cancer_BMI_never_smokers.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_lung_cancer_BMI_never_smokers.csv)

## 26 ====
a = 26
cancer_lung_cancer_BMI_small_cell.csv <- cancer_lung_cancer_BMI_small_cell.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_lung_cancer_BMI_small_cell.csv)


## 27 ====
a = 27
cancer_lung_cancer_BMI_squamous_cell.csv <- cancer_lung_cancer_BMI_squamous_cell.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_lung_cancer_BMI_squamous_cell.csv)

## 28 ====
a = 28
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cancer_lung_cancer_WHR_adenocarcinoma.csv)

## 29 ====
a = 29
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cancer_lung_cancer_WHR_lung_cancer.csv)

## 30 ====
a = 30
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_ovarian_cancer_BMI_clear_cell.csv)

## 31 ====
a = 31
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cancer_ovarian_cancer_BMI_endometroid.csv)

## 32 ====
a = 32
cancer_ovarian_cancer_BMI_ovarian_cancer.csv <- cancer_ovarian_cancer_BMI_ovarian_cancer.csv[-6,]
cancer_ovarian_cancer_BMI_ovarian_cancer.csv <- cancer_ovarian_cancer_BMI_ovarian_cancer.csv[c(2,5),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_ovarian_cancer_BMI_ovarian_cancer.csv, "../data_for_analysis/cancer_ovarian_cancer_BMI_ovarian_cancer.csv", row.names = F)
rm(cancer_ovarian_cancer_BMI_ovarian_cancer.csv)

## 33 ====
a = 33
data[a,2] <- "N"
data[a,3] <- "incompatible covariates"
rm(cancer_pancreatic_cancer_BMI.csv)

## 34 ====
a = 34
cancer_prostate_cancer_BMI_prostate_cancer.csv <- cancer_prostate_cancer_BMI_prostate_cancer.csv[-c(1,2),]
cancer_prostate_cancer_BMI_prostate_cancer.csv <- cancer_prostate_cancer_BMI_prostate_cancer.csv[c(2,5),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cancer_prostate_cancer_BMI_prostate_cancer.csv, "../data_for_analysis/cancer_prostate_cancer_BMI_prostate_cancer.csv", row.names = F)
rm(cancer_prostate_cancer_BMI_prostate_cancer.csv)

## 35 ====
a = 35
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(cardiovascular_cardiovascular_disease.csv)

## 36 ====
a = 36
cardiovascular_carotid_IMT.csv <- cardiovascular_carotid_IMT.csv[-c(1,2),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(cardiovascular_carotid_IMT.csv)

## 37 ====
a = 37
cardiovascular_coronary_artery_disease_birth_weight.csv <- cardiovascular_coronary_artery_disease_birth_weight.csv[c(10,12),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cardiovascular_coronary_artery_disease_birth_weight.csv)

## 38 ====
a = 38
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-c(2:9,13,37,38,44),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-1,]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-c(7,32),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-c(1,2,3,5,6,28,29),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-c(2:18),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-c(8:12),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[c(1:8),]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-5,]
cardiovascular_coronary_artery_disease_BMI.csv <- cardiovascular_coronary_artery_disease_BMI.csv[-3,]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cardiovascular_coronary_artery_disease_BMI.csv)

## 39 ====
a = 39
cardiovascular_coronary_artery_disease_WHR.csv <- cardiovascular_coronary_artery_disease_WHR.csv[c(1,4),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cardiovascular_coronary_artery_disease_WHR.csv, "../data_for_analysis/cardiovascular_coronary_artery_disease_WHR.csv", row.names = F)
rm(cardiovascular_coronary_artery_disease_WHR.csv)

## 40 ====
a = 40
cardiovascular_coronary_artery_disease_WHRadjBMI.csv <- cardiovascular_coronary_artery_disease_WHRadjBMI.csv[-c(1,6),]
cardiovascular_coronary_artery_disease_WHRadjBMI.csv <- cardiovascular_coronary_artery_disease_WHRadjBMI.csv[-c(2,3),]
cardiovascular_coronary_artery_disease_WHRadjBMI.csv <- cardiovascular_coronary_artery_disease_WHRadjBMI.csv[-4,]
cardiovascular_coronary_artery_disease_WHRadjBMI.csv <- cardiovascular_coronary_artery_disease_WHRadjBMI.csv[-3,]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cardiovascular_coronary_artery_disease_WHRadjBMI.csv, "../data_for_analysis/cardiovascular_coronary_artery_disease_WHRadjBMI.csv", row.names = F)
rm(cardiovascular_coronary_artery_disease_WHRadjBMI.csv)

## 41 ====
a = 41
cardiovascular_DBP_BMI.csv <- cardiovascular_DBP_BMI.csv[-c(2,3),]
cardiovascular_DBP_BMI.csv <- cardiovascular_DBP_BMI.csv[-10,]
cardiovascular_DBP_BMI.csv <- cardiovascular_DBP_BMI.csv[-c(3:6),]
cardiovascular_DBP_BMI.csv <- cardiovascular_DBP_BMI.csv[-c(2,4,5),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(cardiovascular_DBP_BMI.csv)

## 42 ====
a = 42
cardiovascular_DBP_WHRadjBMI.csv <- cardiovascular_DBP_WHRadjBMI.csv[-c(2,3),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(cardiovascular_DBP_WHRadjBMI.csv)

## 43 ====
a = 43
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(cardiovascular_deep_vein_thrombosis.csv)

## 44 ====
a = 44
cardiovascular_heart_failure.csv <- cardiovascular_heart_failure.csv[c(2,3),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cardiovascular_heart_failure.csv)

## 45 ====
a = 45
data[a,2] <- "N"
data[a,3] <- "incompatible age range"
rm(cardiovascular_heart_rate.csv)

## 46 ====
a = 46
cardiovascular_hypertension.csv <- cardiovascular_hypertension.csv[-2,]
cardiovascular_hypertension.csv <- cardiovascular_hypertension.csv[-c(2:7),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cardiovascular_hypertension.csv, "../data_for_analysis/cardiovascular_hypertension.csv", row.names = F)
rm(cardiovascular_hypertension.csv)

## 47 ====
a = 47
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cardiovascular_myocardial_infarction.csv)

## 48 ====
a = 48
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(28,25,24,23,21,20,19,18,17,16),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(1),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(2,3),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(4:7),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(3,6,7,8,10,11),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[-c(2),]
cardiovascular_SBP_BMI.csv <- cardiovascular_SBP_BMI.csv[c(3,4,5),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cardiovascular_SBP_BMI.csv, "../data_for_analysis/cardiovascular_SBP_BMI.csv", row.names = F)
rm(cardiovascular_SBP_BMI.csv)

## 49 ====
a = 49
cardiovascular_SBP_WHRadjBMI.csv <- cardiovascular_SBP_WHRadjBMI.csv[-c(2,3),]
cardiovascular_SBP_WHRadjBMI.csv <- cardiovascular_SBP_WHRadjBMI.csv[-c(2),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(cardiovascular_SBP_WHRadjBMI.csv)

## 50 ====
a = 50
cardiovascular_venous_thromboembolism.csv <- cardiovascular_venous_thromboembolism.csv[-c(2),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(cardiovascular_venous_thromboembolism.csv, "../data_for_analysis/cardiovascular_venous_thromboembolism.csv", row.names = F)
rm(cardiovascular_venous_thromboembolism.csv)

## 51 ====
a = 51
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(gastrointestinal_IBS_WHRadjBMI.csv)

## 52 ====
a = 52
hepatic_ALT_BMI.csv <- hepatic_ALT_BMI.csv[c(1,14:19),]
hepatic_ALT_BMI.csv <- hepatic_ALT_BMI.csv[c(1,2,7),]
hepatic_ALT_BMI.csv <- hepatic_ALT_BMI.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible outcome measures"
rm(hepatic_ALT_BMI.csv)

## 53 ====
a = 53
data[a,2] <- "N"
data[a,3] <- "incompatible outcome measures"
rm(hepatic_GGT_BMI.csv)

## 54 ====
a = 54
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(2,3,7,25:29),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(4),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(5:10,12:18),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(3),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(6),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(1),]
mental_health_depression_BMI.csv <- mental_health_depression_BMI.csv[-c(1),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(mental_health_depression_BMI.csv, "../data_for_analysis/mental_health_depression_BMI.csv", row.names = F)
rm(mental_health_depression_BMI.csv)

## 55 ====
a = 55
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(mental_health_depression_WHRadjBMI.csv)

## 56 ====
a = 56
mental_health_wellbeing_BMI.csv <- mental_health_wellbeing_BMI.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(mental_health_wellbeing_BMI.csv)

## 57 ====
a = 57
data[a,2] <- "N"
data[a,3] <- "incompatibke MR method"
rm(metabolic_25OHD.csv)

## 58 ====
a = 58
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_albumin.csv)

## 59 ====
a = 59
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_apoA1.csv)

## 60 ====
a = 60
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_apoB.csv)

## 61 ====
a = 61
metabolic_cholesterol.csv <- metabolic_cholesterol.csv[-1,]
metabolic_cholesterol.csv <- metabolic_cholesterol.csv[-c(2:5),]
metabolic_cholesterol.csv <- metabolic_cholesterol.csv[-c(2),]
metabolic_cholesterol.csv <- metabolic_cholesterol.csv[-c(3),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_cholesterol.csv, "../data_for_analysis/metabolic_cholesterol.csv", row.names = F)
rm(metabolic_cholesterol.csv)

## 62 ====
a = 62
metabolic_CRP.csv <- metabolic_CRP.csv[-c(1,11,12),]
metabolic_CRP.csv <- metabolic_CRP.csv[-c(2:6),]
metabolic_CRP.csv <- metabolic_CRP.csv[-c(5),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_CRP.csv)

## 63 ====
a = 63
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(metabolic_dyslipidemia.csv)

## 64 ====
a = 64
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_EGFR_BMI.csv)

## 65 ====
a = 65
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_EGFR_WHRadjBMI.csv)

## 66 ====
a = 66
metabolic_fasting_glucose_BMI.csv <- metabolic_fasting_glucose_BMI.csv[-c(2,3),]
metabolic_fasting_glucose_BMI.csv <- metabolic_fasting_glucose_BMI.csv[-c(3:7),]
metabolic_fasting_glucose_BMI.csv <- metabolic_fasting_glucose_BMI.csv[-c(6),]
metabolic_fasting_glucose_BMI.csv <- metabolic_fasting_glucose_BMI.csv[-c(3),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_fasting_glucose_BMI.csv, "../data_for_analysis/metabolic_fasting_glucose_BMI.csv", row.names = F)
rm(metabolic_fasting_glucose_BMI.csv)

## 67 ====
a = 67
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_fasting_glucose_WHRadjBMI.csv)

## 68 ====
a = 68
metabolic_fasting_insulin_BMI.csv <- metabolic_fasting_insulin_BMI.csv[-c(2,3,5:10),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_fasting_insulin_BMI.csv)

## 69 ====
a = 69
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_fasting_insulin_WHRadjBMI.csv)

## 70 ====
a = 70
metabolic_glucose.csv <- metabolic_glucose.csv[-1,]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_glucose.csv)

## 71 ====
a = 71
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_Gutt_index_BMI.csv)

## 72 ====
a = 72
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_Gutt_index_WHR.csv)

## 73 ====
a = 73
metabolic_HbA1c.csv <- metabolic_HbA1c.csv[-c(3:7),]
metabolic_HbA1c.csv <- metabolic_HbA1c.csv[-c(1),]
metabolic_HbA1c.csv <- metabolic_HbA1c.csv[-c(2),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_HbA1c.csv, "../data_for_analysis/metabolic_HbA1c.csv", row.names = F)
rm(metabolic_HbA1c.csv)

## 74 ====
a = 74
metabolic_HDL_BMI.csv <- metabolic_HDL_BMI.csv[-c(3:7),]
metabolic_HDL_BMI.csv <- metabolic_HDL_BMI.csv[-c(1),]
metabolic_HDL_BMI.csv <- metabolic_HDL_BMI.csv[-c(2,4),]
metabolic_HDL_BMI_1.csv <- metabolic_HDL_BMI.csv[c(1,2,3),]
metabolic_HDL_BMI_2.csv <- metabolic_HDL_BMI.csv[c(4,5),]
data[a,2] <- "Y"
data[a,3] <- "compatible - split into two based on units"
write.csv(metabolic_HDL_BMI_1.csv, "../data_for_analysis/metabolic_HDL_BMI_1.csv", row.names = F)
write.csv(metabolic_HDL_BMI_2.csv, "../data_for_analysis/metabolic_HDL_BMI_2.csv", row.names = F)
rm(metabolic_HDL_BMI.csv, metabolic_HDL_BMI_1.csv, metabolic_HDL_BMI_2.csv)

## 75 ====
a = 75
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_HDL_WHRadjBMI.csv)

## 76 ====
a = 76
metabolic_HOMA_B_BMI.csv <- metabolic_HOMA_B_BMI.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible exposure units"
rm(metabolic_HOMA_B_BMI.csv)

## 77 ====
a = 77
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_HOMA_B_WHR.csv)

## 78 ====
a = 78
metabolic_HOMA_IR_BMI.csv <- metabolic_HOMA_IR_BMI.csv[-1,]
metabolic_HOMA_IR_BMI.csv <- metabolic_HOMA_IR_BMI.csv[-2,]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_HOMA_IR_BMI.csv, "../data_for_analysis/metabolic_HOMA_IR_BMI.csv", row.names = F)
rm(metabolic_HOMA_IR_BMI.csv)

## 79 ====
a = 79
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_HOMA_IR_WHR.csv)

## 80 ====
a = 80
metabolic_IL6.csv <- metabolic_IL6.csv[-c(3:7),]
metabolic_IL6.csv <- metabolic_IL6.csv[-c(1),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_IL6.csv)

## 81 ====
a = 81
data[a,2] <- "N"
data[a,3] <- "not enough informaton available"
rm(metabolic_insulin_secretion_BMI.csv)

## 82 ====
a = 82
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(metabolic_insulin_secretion_WHR.csv)

## 83 ====
a = 83
metabolic_insulin.csv <- metabolic_insulin.csv[-1,]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_insulin.csv)

## 84 ====
a = 84
metabolic_LDL_BMI.csv <- metabolic_LDL_BMI.csv[-1,]
metabolic_LDL_BMI.csv <- metabolic_LDL_BMI.csv[-7,]
metabolic_LDL_BMI.csv <- metabolic_LDL_BMI.csv[-c(2:6),]
metabolic_LDL_BMI_1.csv <- metabolic_LDL_BMI.csv[c(1,2,3),]
metabolic_LDL_BMI_2.csv <- metabolic_LDL_BMI.csv[c(4,5),]
data[a,2] <- "Y"
data[a,3] <- "compatible - split into two based on units"
write.csv(metabolic_LDL_BMI_1.csv, "../data_for_analysis/metabolic_LDL_BMI_1.csv", row.names = F)
write.csv(metabolic_LDL_BMI_2.csv, "../data_for_analysis/metabolic_LDL_BMI_2.csv", row.names = F)
rm(metabolic_LDL_BMI.csv, metabolic_LDL_BMI_1.csv, metabolic_LDL_BMI_2.csv)

## 85 ====
a = 85
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_LDL_WHRadjBMI.csv)

## 86 ====
a = 86
metabolic_leptin.csv <- metabolic_leptin.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_leptin.csv)

## 87 ====
a = 87
metabolic_triglycerides_BMI.csv <- metabolic_triglycerides_BMI.csv[-1,]
metabolic_triglycerides_BMI.csv <- metabolic_triglycerides_BMI.csv[-1,]
metabolic_triglycerides_BMI.csv <- metabolic_triglycerides_BMI.csv[-c(9:12),]
metabolic_triglycerides_BMI.csv <- metabolic_triglycerides_BMI.csv[-c(7,8),]
metabolic_triglycerides_BMI.csv <- metabolic_triglycerides_BMI.csv[-c(2:6),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_triglycerides_BMI.csv)

## 88 ====
a = 88
data[a,2] <- "N"
data[a,3] <- "incompatible effect estimate"
rm(metabolic_triglycerides_WHRadjBMI.csv)

## 89 ====
a = 89
metabolic_two_hour_glucose.csv <- metabolic_two_hour_glucose.csv[-c(2:6),]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_two_hour_glucose.csv)

## 90 ====
a = 90
data[a,2] <- "N"
data[a,3] <- "incompatible exposure"
rm(metabolic_type1_diabetes.csv)

## 91 ====
a = 91
metabolic_type2_diabetes_birth_weight.csv <- metabolic_type2_diabetes_birth_weight.csv[-2,]
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(metabolic_type2_diabetes_birth_weight.csv)

## 92 ====
a = 92
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(2,3,4,5,6,7,8,9,18,19,27),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(8),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(11),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(9),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(3,4),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(3),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(3,4,9,11),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(4),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(1,6),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(4),]
metabolic_type2_diabetes_BMI.csv <- metabolic_type2_diabetes_BMI.csv[-c(2),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_type2_diabetes_BMI.csv, "../data_for_analysis/metabolic_type2_diabetes_BMI.csv", row.names = F)
rm(metabolic_type2_diabetes_BMI.csv)

## 93 ====
a = 93
metabolic_type2_diabetes_WHRadjBMI.csv <- metabolic_type2_diabetes_WHRadjBMI.csv[-c(2,3,4,5,8),]
metabolic_type2_diabetes_WHRadjBMI.csv <- metabolic_type2_diabetes_WHRadjBMI.csv[-c(3),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(metabolic_type2_diabetes_WHRadjBMI.csv, "../data_for_analysis/metabolic_type2_diabetes_WHRadjBMI.csv", row.names = F)
rm(metabolic_type2_diabetes_WHRadjBMI.csv)

## 94 ====
a = 94
data[a,2] <- "N"
data[a,3] <- "not enough information"
rm(metabolic_urate_BMI.csv)

## 95 ====
a = 95
metabolic_uric_acid.csv <- metabolic_uric_acid.csv[-c(1,4,7,10),]
metabolic_uric_acid.csv <- metabolic_uric_acid.csv[-c(1,3,5),]
metabolic_uric_acid.csv <- metabolic_uric_acid.csv[-c(4),]
metabolic_uric_acid.csv <- metabolic_uric_acid.csv[-c(4),]
data[a,2] <- "N"
data[a,3] <- "one includes a mediator"
rm(metabolic_uric_acid.csv)

## 96 ====
a = 96
other_mortality_BMI_all_cause.csv <- other_mortality_BMI_all_cause.csv[-c(3,4),]
data[a,2] <- "N"
data[a,3] <- "incompatible populations"
rm(other_mortality_BMI_all_cause.csv)

## 97 ====
a = 97
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(reproductive_menarche_BMI.csv)

## 98 ====
a = 98
reproductive_PCOS_BMI.csv <- reproductive_PCOS_BMI.csv[-2,]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(reproductive_PCOS_BMI.csv, "../data_for_analysis/reproductive_PCOS_BMI.csv", row.names = F)
rm(reproductive_PCOS_BMI.csv)

## 99 ====
a = 99
respiratory_asthma_BMI_asthma.csv <- respiratory_asthma_BMI_asthma.csv[-c(1,2,3,6),]
data[a,2] <- "Y"
data[a,3] <- "compatible"
write.csv(respiratory_asthma_BMI_asthma.csv, "../data_for_analysis/respiratory_asthma_BMI_asthma.csv", row.names = F)
rm(respiratory_asthma_BMI_asthma.csv)

## 100 ====
a = 100
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(respiratory_asthma_BMI_atopic.csv)

## 101 ====
a = 101
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(respiratory_asthma_BMI_non_atopic.csv)

## 102 ====
a = 102
data[a,2] <- "N"
data[a,3] <- "incompaitble MR method"
rm(respiratory_asthma_WHRadjBMI.csv)

## 103 ====
a = 103
data[a,2] <- "N"
data[a,3] <- "incompatible units"
rm(respiratory_FVC_BMI.csv)

## 104 ====
a = 104
skeletal_arthritis_BMI.csv <- skeletal_arthritis_BMI.csv[-c(5,6),]
skeletal_arthritis_BMI.csv <- skeletal_arthritis_BMI.csv[-c(1),]
skeletal_arthritis_BMI.csv <- skeletal_arthritis_BMI.csv[-c(2),]
data[a,2] <- "Y"
data[a,3] <- "compaitble"
write.csv(skeletal_arthritis_BMI.csv, "../data_for_analysis/skeletal_arthritis_BMI.csv", row.names = F)
rm(skeletal_arthritis_BMI.csv)

## 105 ====
a = 105
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(skeletal_arthritis_WHRadjBMI.csv)

## 106 ====
a = 106
data[a,2] <- "N"
data[a,3] <- "incompatible outcomes"
rm(skeletal_BMD_BMI.csv)

## 107 ====
a = 107
skeletal_BMD_fat_mass.csv <- skeletal_BMD_fat_mass.csv[c(4,6,7,8),]
data[a,2] <- "N"
data[a,3] <- "incompaitble effect estimates and units"
rm(skeletal_BMD_fat_mass.csv)

## 108 ====
a = 108
skeletal_osteoarthritis_BMI.csv <- skeletal_osteoarthritis_BMI.csv[-20,]
skeletal_osteoarthritis_BMI.csv <- skeletal_osteoarthritis_BMI.csv[-c(7:9),]
skeletal_osteoarthritis_BMI.csv <- skeletal_osteoarthritis_BMI.csv[-c(1:6),]
data[a,2] <- "N"
data[a,3] <- "not enough information"
rm(skeletal_osteoarthritis_BMI.csv)

## 109 ====
a = 109
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(skeletal_osteoarthritis_WHRadjBMI.csv)

## 110 ====
a = 110
data[a,2] <- "N"
data[a,3] <- "incompatible MR method"
rm(skeletal_osteoporosis_WHRadjBMI.csv)

## 111 ====
a = 111
data[a,2] <- "N"
data[a,3] <- "incompatible outcome"
rm(social_education_BMI.csv)

## 112 ====
a = 112
social_income_BMI.csv <- social_income_BMI.csv[-c(1:6),]
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(social_income_BMI.csv)

## 113 ====
a = 113
data[a,2] <- "N"
data[a,3] <- "outcome overlap"
rm(social_SES_BMI.csv)

# ====
write.table(data, "../decision_list.txt", 
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
