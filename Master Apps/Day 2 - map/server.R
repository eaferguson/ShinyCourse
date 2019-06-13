# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)
library(leaflet)
library(RColorBrewer)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# # Create a colour palette
# col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")

## Load region shapefile
regions <- readOGR("data/TZ_Region_2012","TZ_Region_2012")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # # Species type: colorFactor() creates a discrete colour palette for leaflet to use
  colour_pal <- brewer.pal(11, "Spectral")
  
  
  # Get colours based on chosen variable
  pal <- reactive({
    colorFactor(colour_pal, domain = sort(unique(raw_data[,input$colourby])))
  })
  colours <- reactive({
    pal()(raw_data[,input$colourby])
  })
  
  
  ## Render map
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addPolygons(data=regions,color="black",fillColor = "white", weight=1, fillOpacity=0.6) %>%
      addCircles(data=raw_data,lng=~raw_data$x,lat=~raw_data$y,
                 color = colours(),
                 opacity=1, fillOpacity=1) %>%
      addProviderTiles("Stamen.Terrain") %>%
      addLegend(position = "bottomright", title = input$colourby,
                pal = pal(), values = raw_data[,input$colourby], opacity=1)
  })
  
})
