################################
######## Your turn 2.2d ########

library(dplyr)
library(magrittr)
library(leaflet)
library(RColorBrewer)
library(rgdal)
load("Day2_mapping.Rdata")

# load shapefile data file
region_shp <- readOGR("../data/TZ_Region_2012_density/")

# Adjust the choropleth code below to
# 1) use ``colorQuantile()`` instead of ``colorNumeric()``
# 2) add circles coloured by date for human cases

m <- leaflet() %>% addProviderTiles(provider = providers$Esri.WorldShadedRelief)

myPal <- colorNumeric(palette = "YlOrRd", domain = log(region_shp$density))
m %>% addPolygons(data = region_shp, label = region_shp$density,
                  fillColor = myPal(log(region_shp$density)), fillOpacity = 0.7,
                  color = "white", opacity = 1, weight = 2)

# Solution: