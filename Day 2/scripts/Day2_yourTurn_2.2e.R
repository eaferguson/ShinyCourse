################################
######## Your turn 2.2e ########
library(dplyr)
library(magrittr)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(raster)

load("Day2_mapping.Rdata")

# load shape file with region borders
region_shp <- readOGR("../data/TZ_Region_2012_density/")
# load raster file with human density
density <- raster("../data/HumanDensity/HumanPopulation.grd")

# Adapt the code below to add region outlines that highlight when the cursor hovers an area.
# Hint: use ``addPolygon()`` with ``fillOpacity = 0``

myPal <- colorNumeric(palette = "Blues", domain = c(-1.5, 11),
                      na.color = "transparent")

m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.PositronNoLabels) %>%
  addRasterImage(x = log(density), colors = myPal, opacity = 0.8) %>%
  addProviderTiles(provider = providers$CartoDB.PositronOnlyLabels) %>%
  addLegend(pal = myPal, values = c(-1.5, 11), opacity = 0.8,
            title = "Human<br>population<br>density")
m

# Solution: