######## Data Visualisation using RShiny ########
################################################

### Day 2 - Introduction to mapping with leaflet

### Load packages
library(dplyr)
library(ggplot2)
library(leaflet)
library(rgdal) # for working with shape files

### Load data for this session
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)
head(raw_data)

### Some simple manipulation before we map
# create variable for type of species
raw_data$species_type <- ifelse(raw_data$species == "human", "Human", NA)
raw_data$species_type[which(raw_data$species %in% c("dog", "cat"))] <- "Domestic"
raw_data$species_type[which(raw_data$species %in% c("jackal", "lion"))] <- "Wildlife"

# to simplify the maps, subset to only include data for 2014
map_data <- raw_data %>% 
  dplyr::mutate(year = substr(date, 1,4)) %>% 
  dplyr::filter(year == 2014)

### Introduction to leaflet

# Initialise map with 

################################
######## Your turn 2.2a ########

# Try out a couple of the options for provider tiles.
# Hint: Use tab completion with addProviderTiles(provider = providers$) to access options

################################
######## Your turn 2.2b ########

# Adapt the code below from previous slides to produce a map with:
# 1) tiles showing elevation.
# 2) circles coloured by species (instead of species type).
# 3) a legend for colour.
# 4) a scale bar showing distance in kilometers (hint: ?addScaleBar).

colour_pal <- c("gold", "forestgreen", "cornflowerblue")
myPal <- colorFactor(colour_pal, domain = c("Human", "Domestic", "Wildlife"))
m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.Positron) %>%
  addCircles(data = map_data, lng = ~x, lat = ~y,
             color = myPal(map_data$species_type), opacity = 0.9) %>%
  addLegend(position = "topright", title = "Species<br>type", pal = myPal,
            values = map_data$species_type, opacity = 0.9)
m

################################
######## Your turn 2.2c ########

# Adapt the code below from previous slides to produce a map with:
# 1) Circles coloured by population density using the viridis palette
# 2) and sized by population density (higher density = larger circles)
# 3) legend and scale bar
# Hint: Consider whether transforming density might make a more infomative plot

dateRange <- c(2014, 2015)
myPal <- colorNumeric(palette = "Spectral", domain = dateRange)
m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.Positron) %>%
  addCircles(data = map_data, lng = ~x, lat = ~y,
             color = myPal(map_data$date_decimal), opacity = 0.9) %>% 
  addLegend(position = "topright", title = "Date",
            pal = myPal, values = dateRange, opacity = 0.9,
            labFormat = labelFormat(big.mark = ""))
m

################################
######## Your turn 2.2d ########

# Adjust the choropleth code below to:

# 1) use ``colorQuantile()`` instead of ``colorNumeric()``
# 2) add circles coloured by date for human cases

m <- leaflet() %>% addProviderTiles(provider = providers$Esri.WorldShadedRelief)

myPal <- colorNumeric(palette = "YlOrRd", domain = log(region_shp$density))
m %>% addPolygons(data = region_shp, label = region_shp$density,
                  fillColor = myPal(log(region_shp$density)), fillOpacity = 0.7,
                  color = "white", opacity = 1, weight = 2)

################################
######## Your turn 2.2e ########

# Adapt the code below to add region outlines that highlight when the cursor hovers an area.
# Hint: use ``addPolygon()`` with ``fillOpacity = 0``

colour_pal <- c("#FFFFCC", "#41B6C4", "#0C2C84")
myPal <- colorNumeric(palette = colour_pal, domain = c(-1.5, 11),
                      na.color = "transparent")

m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.PositronNoLabels) %>%
  addRasterImage(x = log(density), colors = myPal, opacity = 0.8) %>%
  addProviderTiles(provider = providers$CartoDB.PositronOnlyLabels) %>%
  addLegend(pal = myPal, values = c(-1.5, 11), opacity = 0.8,
            title = "Human<br>population<br>density")
m
