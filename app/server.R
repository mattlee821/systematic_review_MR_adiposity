function(input, output, session) {
  
  # data_extraction
  output$data_extraction <- DT::renderDataTable(DT::datatable({
    data_extraction
    if (input$exposure != "All") {
      data_extraction <- data_extraction[data_extraction$Exposure == input$exposure,]
    }
    if (input$outcome != "All") {
      data_extraction <- data_extraction[data_extraction$Outcome == input$outcome,]
    }
    if (input$outcome_group != "All") {
      data_extraction <- data_extraction[data_extraction$`Outcome group` == input$outcome_group,]
    }
    data_extraction
  }))
  # meta_analysis
  output$meta_analysis <- DT::renderDataTable(DT::datatable(
    meta_analysis,
    options = list("pageLength" = 50)
  ))
  
}
