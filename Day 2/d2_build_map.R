library(dplyr)
library(ggplot2)
library(lubridate)
library(leaflet)
library(rgdal)
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)
region_shp <- readOGR("data/TZ_Region_2012", "TZ_Region_2012")

# Create a colour palette
col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D") # 2:"#3E507F",

## As we did on day 1: create a new variable and subset to ony include 1 year

# Create a new column specifying domestic vs. wildlife vs. human
raw_data$species_type[which(raw_data$species=="dog" | raw_data$species=="cat")] <- "Domestic"
raw_data$species_type[which(raw_data$species=="jackal" | raw_data$species=="lion")] <- "Wildlife"
raw_data$species_type[which(raw_data$species=="human")] <- "Human"

# Use only one year
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4)) %>% 
  filter(year == 2014)

##########

m <- leaflet()

# add some points for data
m %>% addCircles(data=leaflet_data, lng=~x, lat=~y)

# addTiles gives us the context
m %>% addCircles(data=leaflet_data, lng=~x, lat=~y) %>% addTiles()

# Different options are available using addProviderTiles
# 
m %>% addCircles(data=leaflet_data, lng=~x, lat=~y) %>%
  addProviderTiles("Esri.WorldImagery")

m %>% addCircles(data=leaflet_data, lng=~x, lat=~y) %>%
  addProviderTiles("Esri.WorldPhysical")

m %>% addCircles(data=leaflet_data, lng=~x, lat=~y) %>%
  addProviderTiles("Stamen.Terrain")

# Add data with points coloured by a variable

# Species type: colorFactor() creates a discrete colour palette for leaflet to use
colour_pal <- brewer.pal(length(unique(leaflet_data$species_type)), "Spectral")
pal <- colorFactor(colour_pal, domain = c("Human", "Domestic", "Wildlife"))

m <- leaflet() %>% addProviderTiles("Stamen.Terrain")
m <- m %>% addCircles(data=leaflet_data, lng=~x, lat=~y,
                      color = pal(leaflet_data$species_type),
                      opacity = 1, fillOpacity = 1)
m

# To add legend:
m %>% addLegend(m, position = "bottomright", title = "Species type",
                pal = pal, values = leaflet_data$species_type)

### TASK: write code to colour by sex and add a legend

# prepare leaflet colour palette - set limits a bit wider than the actual data
colour_pal <- brewer.pal(11, "Spectral")

# add a continuous colour palette
colour_pal <- brewer.pal(11, "Spectral")
densityRange <- range(leaflet_data$density)
myPal <- leaflet::colorNumeric(colour_pal, densityRange)

m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data = leaflet_data, lng = ~x, lat = ~y,
                      color = myPal(leaflet_data$density),
                      opacity = 1, fillOpacity = 1)

m %>% addLegend(m, position = "bottomright", title = "Density",
                pal = myPal, values = leaflet_data$density)


# TASK: write code to colour points by date
# requires >leaflet_data$date_decimal <- ggtree::Date2decimal(leaflet_data$date)

# convert date to decimal format so that it works as continuous variable for leaflet
leaflet_data$date_decimal <- decimal_date(ymd(leaflet_data$date))
dateRange <- c(2014, 2015)
myPal <- leaflet::colorNumeric(colour_pal, dateRange)

m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data = leaflet_data, lng = ~x, lat = ~y,
                      color = myPal(leaflet_data$date_decimal),
                      opacity = 1, fillOpacity = 1)
m
m %>% addLegend(m, position = "bottomright", title = "Date",
                pal = myPal, values = leaflet_data$date_decimal,
                labFormat = labelFormat(big.mark = "")) # this removes comma from 2,014

# Popups - adding information on data points to map
# use 'popup' argument in function addCircles()
# "<br>" creates a new line in what is displayed
popupInfo <- paste("Date: ", leaflet_data$date, "<br>",
                   "Species: ", leaflet_data$species, "<br>",
                   "Age: ", leaflet_data$age, "<br>",
                   sep = " ")

m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data = leaflet_data, lng = ~x, lat = ~y,
                      color = myPal(leaflet_data$date_decimal),
                      opacity = 1, fillOpacity = 1,
                      popup = popupInfo)
m
m %>% addLegend(m, position = "bottomright", title = "Date",
                pal = myPal, values = leaflet_data$date_decimal,
                labFormat = labelFormat(big.mark = ""))


# Plot
leaflet() %>%
  addPolygons(data=region_shp, weight=1, color="black", fillColor = "white", fillOpacity=1) %>%
  addCircleMarkers(data=leaflet_data, lng=~x, lat=~y, color=~leaflet_pal(species_type),
                   radius=3, opacity = 1, fillOpacity=1, label=~species)