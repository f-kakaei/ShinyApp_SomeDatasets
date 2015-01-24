shinyUI(pageWithSidebar(
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Application title
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  headerPanel("Investigating Some Datasets"),
  
  sidebarPanel(
    
    
     wellPanel(       
       helpText(HTML("<b>Dataset</b>")),
       selectInput("my_ds", "Choose Dataset:", choice = c("women","trees", "iris", "rock", "stackloss", "swiss"))
       
     ),
     
     wellPanel(       
       helpText(HTML("<b>Statistics</b>")),
       checkboxInput("mean", "Mean", TRUE),
       checkboxInput("sd", "S.D.", TRUE),
       checkboxInput("median", "Median", TRUE)
     ),
     
     wellPanel(       
       helpText(HTML("<b>Graph</b>")),
       selectInput('columnX', 'Choose X axis', ''),
       selectInput('columnY', 'Choose Y axis', ''),
       checkboxInput("show_smooth", "Show Smooth", TRUE)
     ),
    
    width=3
  ),
  
  
  mainPanel(
    tabsetPanel(      
      
      tabPanel("Introduction", includeMarkdown("docs/introduction.md")),
      tabPanel("Dataset", htmlOutput("dataset")),
      tabPanel("Data", dataTableOutput("datatable")),
      tabPanel("Statistics", htmlOutput("stat")),
      tabPanel("Graph", plotOutput("graph"))
    ) 
  )
))