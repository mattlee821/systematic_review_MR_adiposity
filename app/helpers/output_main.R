home = function(){
  list(
    div(
      id = "home",
      includeMarkdown(file.path("text", "home.md"))))
  }

home1 = function(){
  list(
    div(
      id = "home1",
      includeMarkdown(file.path("text", "home1.md"))))
  }

home2 = function(){
  list(
    div(
      id = "home2",
      includeMarkdown(file.path("text", "home2.md"))))
  }

home3 = function(){
  list(
    div(
      id = "home3",
      includeMarkdown(file.path("text", "home3.md"))))
}

meta_analysis_figures = function(){
  list(
    div(
      id = "meta_analysis_figures",
      includeMarkdown(file.path("text", "meta_analysis_figures.md"))))
}