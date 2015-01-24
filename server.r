library(shiny)
library(datasets)
library(ggplot2)
library(markdown)

shinyServer(
  function(input, output, session) {
    
    
   getDataSet<-function(){
     df<- switch(input$my_ds,
                      "women" = women,
                      "trees" = trees,
                      "iris" = iris,
                      "rock" = rock,
                 "stackloss" = stackloss,
                 "swiss" = swiss)
     return(df)
   }  
    
   printPlot <- function(){
      
     
     df<-getDataSet()
     
     x <- input$columnX
     y <- input$columnY
     
     if(!(x %in% names(df)))
       stop()
     
     if(!(y %in% names(df)))
       stop()
     
      title<-paste("Graph for dataset", input$my_ds, "-", y, "vs.", x)
     
      xLab<-input$columnX
      yLab<-input$columnY     
      
      plot1 <- ggplot(data=df, aes_string(x = x, y = y))  +
        geom_line(colour = "black")  + geom_point(colour = "blue")
     
     if(input$show_smooth){
       plot1 <- plot1 + stat_smooth()
     }
     
     plot1 <- plot1 + labs(x = xLab, y = yLab) + 
        ggtitle(paste(title)) +
        theme_bw() +
        theme(
          plot.title = element_text(size = 26, face = 'bold', vjust = 2),
          #axis.text.x = element_blank(),
          axis.text = element_text(size = 16),
          axis.title.x = element_text(size = 24),
          axis.title.y = element_text(size = 24),
          #axis.ticks.x = element_blank(),
          strip.background = element_rect(fill = 'grey80'),
          strip.text.x = element_text(size = 18),
          legend.position = "none"
          #panel.grid = element_blank()
        )
      print(plot1)
      
    }   
   
   
   observe({
     
     df<-getDataSet() 
     
     updateSelectInput(session, "columnX", choices = names(df), selected = names(df)[1])
     updateSelectInput(session, "columnY", choices = names(df), selected = names(df)[2])
     
     
   })
   
   
   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ## Output Dataset explanation 
   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   output$dataset <- renderPrint({
     df<-getDataSet()
     cat("<table border=1>")
     cat("<tr><td align='center' colspan=2><b>Dataset Summary</b></td></tr>")
     cat("<tr><td><b>Name</b></td><td>", input$my_ds, "</td></tr>")
     cat("<tr><td><b>columns</b></td><td>", dim(df)[2], "</td></tr>")
     cat("<tr><td><b>observations</b></td><td>", dim(df)[1], "</td></tr>")
     col_names<-paste(names(df), c(rep(",", length(names(df))-1), ""))     
     cat("<tr><td><b>column names</b></td><td>", col_names, "</td></tr>")
     cat("</table>")
   })
   
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## Output Data Frame 
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$datatable <- renderDataTable({
      
      df<-getDataSet()  
      
      
      ## Display df
      df
      
    }, options = list(aLengthMenu = c(5, 10, 15), iDisplayLength = 5))
   
   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ## Output Stat 
   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
   output$stat <- renderPrint({
     
     
     df <- getDataSet()  
     
     cat("<table border='1'><tr><th></th>")
     for(i in 1:dim(df)[2]){
       cat("<th>", names(df)[i], "</th>")
     }
     cat("</tr>")
     
    if(input$mean){
       cat("<tr><td><b>Mean</b></td>")     
       for(i in 1:dim(df)[2]){
         value <- ""
        if(is.numeric(df[,i])) 
          value<-mean(df[,i])
        cat("<td>", value, "</td>")      
      }
      cat("</tr>")
    }
    
    if(input$sd){
      cat("<tr><td><b>sd</b></td>")     
      for(i in 1:dim(df)[2]){
        value <- ""
        if(is.numeric(df[,i])) 
          value<-sd(df[,i])
         cat("<td>", value, "</td>")      
      }
      cat("</tr>")
    }
    
    if(input$median){
      cat("<tr><td><b>median</b></td>")     
      for(i in 1:dim(df)[2]){
        value <- ""
        if(is.numeric(df[,i])) 
          value<-median(df[,i])
         cat("<td>", value, "</td>")      
      }
      cat("</tr>")
    }
    
    cat("</table>")
     
   })
        
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## Output Plot 
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$graph <- renderPlot({

      printPlot()
      
    })    

  }
)