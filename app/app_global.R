# packages ====
# packages <- c("shiny", "shinythemes", "dplyr", "DT", "markdown", "rmarkdown")
# package.check <- lapply(packages, FUN = function(x) {
#   if (!require(x, character.only = TRUE)) {
#     install.packages(x, dependencies = TRUE)
#   }
# })


library(shiny)
library(shinythemes)
library(dplyr)
library(DT)
library(markdown)
library(rmarkdown)

# data ====
data_extraction <- read.csv("formatted_data_extraction.csv")
data_extraction <- data_extraction[order(data_extraction$outcome, data_extraction$exposure),]
colnames(data_extraction) <- c("Author", "Year", "Title", "Exposure", "Outcome", "Outcome info", "Outcome group",
                             "MR design", "MR method","Effect measure","Estimate")



meta_analysis <- read.csv("formatted_meta_analysis_results.csv")
colnames(meta_analysis) <- c("Exposure", "Outcome", "Estimate", "Lower 95%", "Upper 95%", "p-value", "N studies")
