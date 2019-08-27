######## Data Visualisation using RShiny ########
################################################

###################################################
### Day 2.1 - Day 1 recap and intro to maps in R

### Load packages we'll need
library(leaflet)
library(dplyr)
library(magrittr)
library(ggplot2)
library(RColorBrewer)
library(rgdal) # for working with shape files
library(raster) # for working with raster files

########## Load data for this session and remind yourself what the variables look like
raw_data <- read.csv("../data/raw_data.csv", stringsAsFactors = FALSE)
head(raw_data)
str(raw_data)

########## Some simple manipulation before we map

# Create a new column specifying human OR domestic OR wildlife
# On Day 1 we used mutate() with a single ifelse() statement.
# This time we have 3 outcome options so we need nested ifelse() statements
raw_data <- mutate(raw_data,
                   species_type = ifelse(species == "human", "Human",
                                         ifelse(species %in% c("cat", "dog"), "Domestic", "Wildlife")))

table(raw_data$species, raw_data$species_type)

# Before mapping, filter raw_data to use only cases identified during 2014
map_data <- raw_data %>% 
  mutate(year = substr(date, 1,4)) %>% 
  filter(year == 2014)

### fill in the gaps in the code below to make some simple maps of the data:
# simple map using plot
plot(x = map_data$ , y = map_data$ , asp = 1)

# simple map using ggplot
ggplot() +
  geom_point(data = map_data, aes(x = , y = , fill = ))






###################################################
### Day 2.2 - Introduction to mapping with leaflet

# Initialise map with leaflet() and use addCircles
m <- leaflet() %>% 
  addCircles(data=map_data, lng=~x, lat=~y)

m %>%
  addTiles()

################################
######## Your turn 2.2a ########

# Try out a couple of the options for provider tiles.
# Hint: Use tab completion with addProviderTiles(provider = providers$) to access options

## Useful links
## More info on  ``addProviderTiles()``
# https://github.com/leaflet-extras/leaflet-providers
# Full list of free-to-use tiles with previews:</b> <br />
# http://leaflet-extras.github.io/leaflet-providers/preview/index.html
# Tile servers based on OpenStreetMap data with info on how to cite:</b> <br />
# https://wiki.openstreetmap.org/wiki/Tile_servers

# Now, save the R workspace in the folder you're working in
# We'll load this in the other Your turn scripts
save.image("Day2_mapping.Rdata")


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
