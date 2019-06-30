# ---------------------------------------------------------------------------- #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)
library(shinyWidgets)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Add year and mal date to data
leaflet_data <- raw_data %>% mutate(date=ymd(date)) 


shinyUI(fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(inputId = "date", label = "Date:", 
                  min = min(leaflet_data$date),max =max(leaflet_data$date),
                  value=c(min(leaflet_data$date),max(leaflet_data$date)),
                  timeFormat="%b %Y"),
      
      selectInput(inputId="colourby", label="Colour Cases By:",
                  choices = c("species","date","sex","age"),
                  selected="species"),
      
      pickerInput(inputId = "species", label = "Species:",
                  as.character(sort(unique(leaflet_data$species))), selected=as.character(unique(leaflet_data$species)),
                  options = list(`actions-box` = TRUE),multiple = T)
      
    ),
    
    mainPanel(
      
      leafletOutput("mymap",width=1000,height=700)
      
    )
    
    
  )
  

))
