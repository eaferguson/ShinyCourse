# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)
library(RColorBrewer)
library(lubridate)
library(dplyr)
library(rgdal)
library(raster)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Add year and decimal date to data
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4), date=ymd(date), date_decimal = decimal_date(date)) 

## Create a colour palette for points
palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")

## Load region shapefile
regions <- readOGR("data/TZ_Region_2012","TZ_Region_2012")

## Load protected areas shapefile
PAs <- readOGR("data/TZprotected_areas","TZprotected_areas")



# Define server logic 
shinyServer(function(input, output) {
  
  
  ## Subset data based on date slider input and species picker input
  leaflet_data_sub<- reactive({
    leaflet_data %>% 
      filter(date>input$date[1] & date<input$date[2] & species %in% input$species)
    
  })
  
  popupInfo <- reactive({
    paste("Date: ", leaflet_data_sub()$date, "<br>",
          "Species: ", leaflet_data_sub()$species, "<br>",
          "Age: ", leaflet_data_sub()$age, "<br>",
          "Sex: ", leaflet_data_sub()$sex, "<br>",
          sep = " ")
  })
   
  
  # Get point colours based on chosen variable
  pal <- reactive({
    colourby <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    if(is.character(leaflet_data[,colourby])){
      colorFactor(palette, domain = sort(unique(leaflet_data[,colourby])))  
    }else{
      colorNumeric(palette, range(leaflet_data[,colourby]))
    }
  })
  
  
  ## Render map
  output$mymap <- renderLeaflet({
    colourby <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    m <- leaflet() 
    
    if("regions" %in% input$shapefiles){
      m <- m%>%addPolygons(data=regions,color="black",fillColor = "white",
                           label=regions$Region_Nam, weight=1, fillOpacity=0.7)}
    if("protected areas" %in% input$shapefiles){
      m <- m%>%addPolygons(data=PAs,color="transparent",fillColor = "sienna",
                           weight=1, fillOpacity=0.6)}
    
    m<-m%>%addCircles(data=leaflet_data_sub(),lng=~leaflet_data_sub()$x,lat=~leaflet_data_sub()$y,
                      color = pal()(leaflet_data_sub()[,colourby]),
                      opacity=1, fillOpacity=1, popup = popupInfo()) %>%
      addProviderTiles("Stamen.Terrain") %>%
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = leaflet_data[,colourby], opacity=1,
                labFormat = labelFormat(big.mark = "")) 
    
  })
  
})
