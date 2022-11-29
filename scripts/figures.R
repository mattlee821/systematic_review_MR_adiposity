rm(list=ls())

# Packages ====
library(wesanderson)
library(ggplot2)
library(dplyr)
library(cowplot)
library(data.table)

# Palettes ====
d1 <- wes_palette("Royal1", type = "discrete")
d2 <- wes_palette("GrandBudapest2", type = "discrete")
d3 <- wes_palette("Cavalcanti1", type = "discrete")
d4 <- wes_palette("Darjeeling1", type = "discrete")
discrete_wes_pal <- c(d1, d2, d3, d4)
continuous_wes_pal <- wes_palette("Zissou1", 100, type = "continuous")

# data ====
load("../systematic_review_MR_adiposity/analysis/data_extraction.RData")

year <- data[!duplicated(data$ID),]
year <- year[,c("ID", "year", "outcome_n_case_current", "outcome_n_control_current", "exposure_n_current")]
year$exposure_n_current <- as.numeric(year$exposure_n_current)
year$outcome_n_case_current <- as.numeric(year$outcome_n_case_current)
year$outcome_n_control_current <- as.numeric(year$outcome_n_control_current)

a <- year[,c("year", "exposure_n_current")]
a <- a[complete.cases(a), ]
exposure <- a %>% 
  group_by(year) %>% 
  summarise(exposure_average = mean(exposure_n_current))

a <- year[,c("year", "outcome_n_case_current", "outcome_n_control_current")]
a[is.na(a)] <- 0
a$outcome <- a$outcome_n_case_current + a$outcome_n_control_current
a <- subset(a, outcome > 0)
a <- a[,c("year", "outcome")]
a <- a[complete.cases(a), ]
outcome <- a %>% 
  group_by(year) %>% 
  summarise(outcome_average = mean(outcome))

a <- year[,c("year")]
a <- a[complete.cases(a), ]
year <- a %>% 
  group_by(year) %>%
  summarise(year_count = length(year))

plot_data <- left_join(year, exposure, by = "year")
plot_data <- left_join(plot_data, outcome, by = "year")

# plot ====
plot_data$`N articles` <- plot_data$year_count
p1 <- ggplot(plot_data) +
  geom_col(aes(x = year, y = `N articles`)) +
  geom_point(aes(x = year, y = exposure_average/5000, group = 1), size = 2, colour = discrete_wes_pal[1]) +
  geom_point(aes(x = year, y = outcome_average/5000, group = 1), size = 2, colour = discrete_wes_pal[2]) +
  geom_line(aes(x = year, y = exposure_average/5000, group = 1), size = 3, colour = discrete_wes_pal[1]) +
  geom_line(aes(x = year, y = outcome_average/5000, group = 1), size = 3, colour = discrete_wes_pal[2]) +
  scale_y_continuous(sec.axis = sec_axis(~.*5000, breaks = c(250000,200000,150000,100000,50000,0), name = "N exposure/outcome")) +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

pdf("figures/n_articles.pdf", width = 10, height = 10)
p1
dev.off()

design <- select(data, ID, MR_design)
design <- as.data.table(design)
design <- dcast(design, MR_design ~ ., fun.agg = function(x) sum(!is.na(x)), 
                value.var = "ID")
colnames(design)[2] <- "N"
design$MR_design <- gsub("one-sample meta-analysis", "One-sample meta-analysis", design$MR_design)
design$MR_design <- gsub("two-sample meta-analysis", "Two-sample meta-analysis", design$MR_design)
design$MR_design <- gsub("one-sample and Two-sample meta-analysis", "One-sample and two-sample meta-analysis", design$MR_design)
p1 <- ggplot(data.frame(design), aes(x=reorder(MR_design, N), y=N)) +
  geom_bar(stat='identity') +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.text.y = element_text(size = 8),
        axis.title.y = element_blank(), axis.title.x = element_blank()) +
  coord_cartesian(xlim=c(0,2000), ylim=c(0,2000)) +
  # geom_text(aes(label=N), position=position_dodge(width=0.9), vjust=0.5, hjust=-0.5) +
  coord_flip()
pdf("figures/study_design.pdf", width = 10, height = 10)
p1
dev.off()

# ====2
rob_data <- read.csv("../systematic_review_MR_adiposity/analysis/quality_assessment/quality_assessment_results.csv")
rob_data<- rob_data[- grep("WHRadjBMI", rob_data$.id),] # remove whradjbmi because of bias
rob_data$QA[rob_data$Total <= 19] <- "High"
rob_data$QA[rob_data$Total >= 20 ] <- "Medium"
rob_data$QA[rob_data$Total >= 28] <- "Low"
rob_data$QA <- factor(rob_data$QA, levels = c("High", "Medium", "Low"))

p1 <- ggplot(data = rob_data,
       aes(Total, fill = QA)) +
  geom_histogram(binwidth = 1, alpha = 0.8) +
  theme_cowplot() +
  scale_fill_grey(start = 0,end = 0.8)
pdf("figures/qa_distribution.pdf", width = 10, height = 10)
p1
dev.off()
