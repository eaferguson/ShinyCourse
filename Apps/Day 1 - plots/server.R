# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {



  # Produce plot
  output$explPlot <- renderPlot({
   if(input$xaxis=="sex"){
     ggplot() +
       geom_bar(data=raw_data, aes(x=raw_data[[input$xaxis]]), fill="#178B8B") +
       theme_classic()
   } else if(input$xaxis=="species"){
     ggplot() +
       geom_bar(data=raw_data, aes(x=species), fill="#178B8B") +
       theme_classic()
   }
  })

})
