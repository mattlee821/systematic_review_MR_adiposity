function(input, output, session) {
  
  # data_extraction
  output$data_extraction <- DT::renderDataTable(DT::datatable({
    data_extraction
    if (input$exposure != "All") {
      data_extraction <- data_extraction[data_extraction$exposure == input$exposure,]
    }
    if (input$outcome != "All") {
      data_extraction <- data_extraction[data_extraction$outcome == input$outcome,]
    }
    if (input$outcome_group != "All") {
      data_extraction <- data_extraction[data_extraction$outcome_group == input$outcome_group,]
    }
    data_extraction
  }))
  # meta_analysis
  output$meta_analysis <- DT::renderDataTable(DT::datatable(
    meta_analysis,
    options = list("pageLength" = 50)
  ))
  
}
