# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Produce plot
  output$explPlot <- renderPlot({
   ggplot() +
       geom_bar(data=raw_data, aes(x=raw_data[[input$xaxis]]), fill="#178B8B") +
      labs(x=input$xaxis) +
       theme_classic()
  })

})
