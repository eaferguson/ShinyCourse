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

# # Create a colour palette for points
point_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")
# point_palette <- brewer.pal(11, "Spectral")


## Load region shapefile
regions <- readOGR("data/TZ_Region_2012","TZ_Region_2012")


## Load density raster
density <- raster("data/HumanDensity/HumanPopulation.grd")


## Colour palette for rasters
raster_palette <- brewer.pal(9, "YlOrRd")




# Define server logic 
shinyServer(function(input, output) {
  
  
  ## Subset data based on date slider input and species picker input
  leaflet_data_sub<- reactive({
    leaflet_data[which(leaflet_data$date>input$date[1] & leaflet_data$date<input$date[2] & 
                         is.element(leaflet_data$species,input$species)),]
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
      colorFactor(point_palette, domain = sort(unique(leaflet_data[,colourby])))  
    }else{
      colorNumeric(point_palette, range(leaflet_data[,colourby]))
    }
  })
  
  
  ## Render map
  output$mymap <- renderLeaflet({
    rasterRange <- range(log10(density[])[which(!is.infinite(log10(density[])))],na.rm=T)
    colourby <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    leaflet() %>%
      # addPolygons(data=regions,color="black",fillColor = "white", 
      #             label=regions$Region_Nam, weight=1, fillOpacity=0.9) %>%
      addCircles(data=leaflet_data_sub(),lng=~leaflet_data_sub()$x,lat=~leaflet_data_sub()$y,
                 color = pal()(leaflet_data_sub()[,colourby]),
                 opacity=1, fillOpacity=1, popup = popupInfo()) %>%
      addProviderTiles("Stamen.Terrain") %>%
      addRasterImage(log10(density), 
                     colors = colorNumeric(raster_palette, rasterRange, na.color = "transparent"), 
                     opacity = 0.7) %>% 
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = leaflet_data[,colourby], opacity=1,
                labFormat = labelFormat(big.mark = "")) %>%
      addLegend(pal = colorNumeric(raster_palette, rasterRange, na.color = "transparent"), 
                values = rasterRange, opacity=1,bins = -10:10,labels=as.character((-10:10)^10),
                title = "Log10 human<br>population<br>density")
    
  })
  
})
