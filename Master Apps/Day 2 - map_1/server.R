# ---------------------------------------------------------------------------- #
# Day 2 - map Master App
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

##Load libraries
library(shiny)
library(leaflet)
library(lubridate)
library(dplyr)
library(rgdal)
library(rgeos)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Add year and decimal date to data
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4), date=ymd(date), date_decimal = decimal_date(date)) 

## Create a colour palette for points
palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")

## Load region shapefile
regions <- readOGR("data/TZ_Region_2012","TZ_Region_2012")

## Create text pop-up information for each point in leaflet_data
popupInfo <- 
  paste("Date: ", leaflet_data$date, "<br>",
        "Species: ", leaflet_data$species, "<br>",
        "Age: ", leaflet_data$age, "<br>",
        "Sex: ", leaflet_data$sex, "<br>",
        sep = " ")





#------------------------------------------------------------------------------#
# Define server logic 
shinyServer(function(input, output) {
  
  
  # Get point colours based on chosen variable
  pal <- reactive({
    colourby_col <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    if(input$colourby %in% c("species","sex")){ 
      colorFactor(palette, domain = sort(unique(leaflet_data[,colourby_col])))  
    }else if(input$colourby %in% c("date","age")){
      colorNumeric(palette, range(leaflet_data[,colourby_col]))
    }
  })
  
  
  ## Render map
  output$mymap <- renderLeaflet({
    
    ## Initialise map with tile. Set central point of viewing window and initial amount of zoom.
    m <- leaflet() %>% 
      addProviderTiles("Stamen.Terrain") %>%
      setView(c(gCentroid(regions)@coords)[1], c(gCentroid(regions)@coords)[2], zoom = 6)
    
    
    ## Add region shapefile
    m <- m %>% 
      addPolygons(data=regions,color="black",fillColor = "white",
                  label=regions$Region_Nam, weight=1, fillOpacity=0.7)
    
    ## Add coloured points and legend
    colourby_col <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    m %>% 
      addCircles(data=leaflet_data,lng=~leaflet_data$x,lat=~leaflet_data$y,
                 color = pal()(leaflet_data[,colourby_col]),
                 opacity=1, fillOpacity=1, popup = popupInfo) %>%
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = leaflet_data[,colourby_col], opacity=1,
                labFormat = labelFormat(big.mark = "")) 
    
  })
  
})
