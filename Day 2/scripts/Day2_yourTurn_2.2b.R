################################
######## Your turn 2.2b ########
library(dplyr)
library(magrittr)
library(leaflet)
library(RColorBrewer)

load("Day2_mapping.Rdata")

# Adapt the code below to produce a map with:
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

# Solution: