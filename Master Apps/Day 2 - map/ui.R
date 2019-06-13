# ---------------------------------------------------------------------------- #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)

shinyUI(fluidPage(

  leafletOutput("mymap",width=800,height=600),
  
  selectInput(inputId="colourby", label="Colour Cases By:",
              choices = c("species","date","sex","age"),
              selected="species")
  
  
))
