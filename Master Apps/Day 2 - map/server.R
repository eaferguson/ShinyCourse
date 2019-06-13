# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)
library(RColorBrewer)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Add year and decimal date to data
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4), date=ymd(date), date_decimal = decimal_date(date)) 

# # Create a colour palette
# col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")
colour_pal <- brewer.pal(11, "Spectral")

## Load region shapefile
regions <- readOGR("data/TZ_Region_2012","TZ_Region_2012")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  # Get point colours based on chosen variable
  pal <- reactive({
    colourby <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    if(is.character(leaflet_data[,colourby])){
      colorFactor(colour_pal, domain = sort(unique(leaflet_data[,colourby])))  
    }else{
      colorNumeric(colour_pal, range(leaflet_data[,colourby]))
    }
  })
  
  
  ## Render map
  output$mymap <- renderLeaflet({
    colourby <- ifelse(input$colourby!="date",input$colourby,"date_decimal")
    leaflet() %>%
      addPolygons(data=regions,color="black",fillColor = "white", weight=1, fillOpacity=0.6) %>%
      addCircles(data=leaflet_data,lng=~leaflet_data$x,lat=~leaflet_data$y,
                 color = pal()(leaflet_data[,colourby]),
                 opacity=1, fillOpacity=1) %>%
      addProviderTiles("Stamen.Terrain") %>%
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = leaflet_data[,colourby], opacity=1,
                labFormat = labelFormat(big.mark = ""))
  })
  
})
