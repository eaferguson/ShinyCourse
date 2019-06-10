# ---------------------------------------------------------------------------- #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  leafletOutput("mymap",width=800,height=600),
  
  selectInput(inputId="colourby", label="Colour Cases By:",
              choices = c("species","sex"),
              selected="species")
  
  
))
