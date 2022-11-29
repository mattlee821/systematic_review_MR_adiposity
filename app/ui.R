# call source function ====
source(file.path("helpers", "output_main.R"))
source("app_global.R")
# data_extraction <- read.csv("formatted_data.csv")
# meta_analysis <- read.csv("formatted_meta_analysis_results.csv")

# ui ====
navbarPage(
  title = "",
  theme =  shinythemes::shinytheme("flatly"),
  fluid = TRUE,
  selected = "Home",
  inverse = FALSE,
 
  tabPanel(
    title = "Home",
    fluidRow(
      column(12, title = "", id = "home", home()),
      column(1),
      column(4, title = "", id = "home1", home1()),
      # column(4, title = "", id = "home2", home2()),
      column(6, title = "", id = "home3", home3()),
      column(1)
    )),
  
  tabPanel(
    title = "Data extraction: data",
    fluidRow(
      column(4, title = "", id = "data1", 
             selectInput("exposure",
                         "Exposure",
                         c("All", sort(unique(as.character(data_extraction$Exposure)))))),
      column(4, title = "", id = "data2", 
             selectInput("outcome",
                         "Outcome",
                         c("All", sort(unique(as.character(data_extraction$Outcome)))))),
      column(4, title = "", id = "data3", 
             selectInput("outcome_group",
                         "Outcome group",
                         c("All", sort(unique(as.character(data_extraction$`Outcome group`)))))),
      
      column(12, title = "", id ="data_extraction_table",
             DT::dataTableOutput("data_extraction")),
      )),
  
  tabPanel(
    title = "Meta-analyses: results",
    fluidRow(
      column(1),
      column(10, title = "", id ="meta_analysis_table",
             DT::dataTableOutput("meta_analysis")),
      column(1),
      )
    )
  )
