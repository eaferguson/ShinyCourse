library(dplyr)
library(ggplot2)
library(lubridate)
library(leaflet)
library(rgdal)
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)
region_shp <- readOGR("data/TZ_Region_2012", "TZ_Region_2012")

# Create a colour palette
col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D") # 2:"#3E507F",

# Create a new column specifying domestic vs. wildlife vs. human
raw_data$species_type[which(raw_data$species=="dog" | raw_data$species=="cat")] <- "Domestic"
raw_data$species_type[which(raw_data$species=="jackal" | raw_data$species=="lion")] <- "Wildlife"
raw_data$species_type[which(raw_data$species=="human")] <- "Human"

# Use only one year
leaflet_data <- raw_data %>% 
  mutate(year = substr(date, 1,4)) %>% 
  filter(year == 2014)

# Setup point colours using the colorFactor() function
leaflet_pal <- colorFactor(palette=col_palette[1:3], domain = unique(leaflet_data$species_type))

m <- leaflet()

# add some points for data
m %>% addCircles(data=leaflet_data, lng=~x, lat=~y)

m %>% addCircles(data=leaflet_data, lng=~x, lat=~y) %>% addTiles()

# add a discrete colour palette for leaflet using the colorFactor() function
colour_pal <- brewer.pal(length(unique(leaflet_data$species_type)), "Spectral")
pal <- colorFactor(colour_pal, domain = c("Human", "Domestic", "Wildlife"))

m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data=leaflet_data, lng=~x, lat=~y,
                      color = pal(leaflet_data$species_type),
                      opacity = 1, fillOpacity = 1)
m

m %>% addLegend(m, position = "bottomright", title = "Species type",
                pal = pal, values = leaflet_data$species_type)

### TASK: write code to colour by sex and add a legend

# prep leaflet colour palette - set limits a bit wider than the actual data
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

# convert date to decimal format so that 
leaflet_data$date_decimal <- ggtree::Date2decimal(leaflet_data$date)
dateRange <- range(leaflet_data$date_decimal)
myPal <- leaflet::colorNumeric(colour_pal, dateRange)

m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data = leaflet_data, lng = ~x, lat = ~y,
                      color = myPal(leaflet_data$date_decimal),
                      opacity = 1, fillOpacity = 1)
m
m %>% addLegend(m, position = "bottomright", title = "Density",
                pal = myPal, values = leaflet_data$date_decimal)


# TASK: 
m <- leaflet() %>% addTiles()
m <- m %>% addCircles(data = leaflet_data, lng = ~x, lat = ~y,
                      color = myPal(leaflet_data$density),
                      opacity = 1, fillOpacity = 1)

m %>% addLegend(m, position = "bottomright", title = "Density",
                pal = myPal, values = leaflet_data$density)


# Plot
leaflet() %>%
  addPolygons(data=region_shp, weight=1, color="black", fillColor = "white", fillOpacity=1) %>%
  addCircleMarkers(data=leaflet_data, lng=~x, lat=~y, color=~leaflet_pal(species_type),
                   radius=3, opacity = 1, fillOpacity=1, label=~species)