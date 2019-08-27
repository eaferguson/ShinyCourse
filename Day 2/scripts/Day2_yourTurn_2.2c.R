################################
######## Your turn 2.2c ########
library(dplyr)
library(magrittr)
library(leaflet)
library(RColorBrewer)

load("Day2_mapping.Rdata")

# Adapt the code below from previous slides to produce a map with:
# 1) Circles coloured by population density using the "Spectral" palette
# 2) and sized by population density (higher density = larger circles)
# 3) legend and scale bar
# Hint: Consider whether transforming density might make a more infomative plot

dateRange <- c(2014, 2015)
myPal <- colorNumeric(palette = "YlOrRd", domain = dateRange)
m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.Positron) %>%
  addCircles(data = map_data, lng = ~x, lat = ~y,
             color = myPal(map_data$date_decimal), opacity = 0.9) %>% 
  addLegend(position = "topright", title = "Date",
            pal = myPal, values = dateRange, opacity = 0.9,
            labFormat = labelFormat(big.mark = ""))
m

# Solution: