# ---------------------------------------------------------------------------- #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)
library(shinyWidgets)


shinyUI(fluidPage(

  leafletOutput("mymap",width=800,height=600),
  
  sliderInput(inputId = "date", label = "Date:", 
              min = min(leaflet_data$date),max =max(leaflet_data$date),
              value=c(min(leaflet_data$date),max(leaflet_data$date)),
              timeFormat="%b %Y"),
  # textOutput("SliderText"),
  
  selectInput(inputId="colourby", label="Colour Cases By:",
              choices = c("species","date","sex","age"),
              selected="species"),
  
  pickerInput(inputId = "species", label = "Species:",
              as.character(unique(leaflet_data$species)), selected=as.character(unique(leaflet_data$species)),
              options = list(`actions-box` = TRUE),multiple = T)
  
  
))
