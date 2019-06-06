
rm(list=ls(all=TRUE))
# setwd("D:/Dropbox/ShinyCourse")

library(rgdal)
library(lubridate)
library(rgeos)
library(raster)

set.seed(4)


## Read in datasets
#--------------------------

## Tanzania regions shapefile
regions <- readOGR("Day 1/data/TZ_Region_2012","TZ_Region_2012")
# regions <- spTransform(regions,CRS("+proj=longlat"))
# gIsValid(regions)
# regions <- gBuffer(regions,width=0,byid=T)
# gIsValid(regions)
# writeOGR(regions, dsn="data/TZ_Region_2012","TZ_Region_2012", driver="ESRI Shapefile",overwrite_layer=T)
plot(regions)

## Protected Areas
PAs <- readOGR("Day 1/data/TZprotected_areas","TZprotected_areas")
# PAs <- spTransform(PAs,CRS("+proj=longlat"))
# writeOGR(PAs, dsn="Day 1/data/TZprotected_areas","TZprotected_areas", driver="ESRI Shapefile",overwrite_layer=T)
plot(PAs,col="khaki",add=T,border=F)
plot(regions,add=T)

## Human density
density <- raster("Day 1/data/HumanPopulation.grd")




## Simulate time series
#---------------------------

startDate <- as.Date("2010-01-01")
endDate <- as.Date("2015-01-01")
months <- (year(endDate)-year(startDate))*12

casesMonth <- rep(NA,months)

casesMonth[1] <- rpois(1,5)
for(i in 2:length(casesMonth)){
  casesMonth[i]<- rpois(1,casesMonth[i-1]+ifelse(casesMonth[i-1]<2,1,0))
}
plot(casesMonth,type="l")



## Get exact date for each case
#---------------------------

## Create data frame with month variable
data <- data.frame("month"=rep(1:months,casesMonth))

## Pick a random date within the month for each data point
data$date <- as.Date(NA)
for(i in 1:months){
  daysMonth <- seq(startDate %m+% months(i-1),startDate %m+% months(i)-1,by="day")
  data$date[which(data$month==i)] <- sort(sample(daysMonth,casesMonth[i],replace=T))
}



## Sex, species and age
#---------------------------

## Draw sex
data$sex <- sample(c("M","F"),nrow(data),replace=T)

## Draw species
species <- c("dog","cat","jackal","human","lion")
probSpecies <- c(0.45,0.2,0.15,0.1,0.1)
data$species <- species[apply(rmultinom(nrow(data),1,prob=probSpecies),2,function(x){which(x==1)})]
table(data$species)

## Draw age
maxAgeSpecies <- c(8,8,8,80,15)
data$age <- as.integer(round(runif(nrow(data),0,maxAgeSpecies[match(data$species,species)])))



## Determine whether cases are in a protected area
#---------------------------

## Set up columns for coordinates
data$x <- data$y <- NA

## Is case in a protected area?
probPAspecies <- c(0.04,0.04,0.75,0.025,0.95)
PAcase <- rbinom(nrow(data),1,probPAspecies[match(data$species,species)])



## Get coords for individuals located in PAs
#---------------------------

## Sample random coordinates
PAcoords <- spsample(PAs,sum(PAcase),type="random")
data[which(PAcase==1),c("x","y")] <- PAcoords@coords



## Get coords for wildlife individuals located outside of PAs
#---------------------------

## subtract protected areas from region shapefile
region_PAs_diff <- regions-PAs

## Sample random coordinates
notPAwildlifeCoords <- spsample(region_PAs_diff,length(which(PAcase==0 & is.element(data$species,c("jackal","lion")))),type="random")
data[which(PAcase==0 & is.element(data$species,c("jackal","lion"))),c("x","y")] <- notPAwildlifeCoords@coords



## Get coords for non-wildlife individuals located outside of PAs
#---------------------------

## Draw a density raster cell for every non-wildlife individual located outside PAs
rasterCoords <- SpatialPoints(coordinates(density), proj4string=region_PAs_diff@proj4string) # density raster coordinates
densityNotPA <- density
densityNotPA[which(is.na(over(rasterCoords,region_PAs_diff)$Loc_type))] <- NA  # find raster cells that are outside protected areas
cells <- sample.int(length(which(!is.na(densityNotPA[]))),length(which(PAcase==0 & !is.element(data$species,c("jackal","lion")))),replace=T, prob=density[which(!is.na(densityNotPA[]))]) # draw a cell for each case with bias towards high density

## Add coordinates for individuals not in PAs to data frame
notPAnotWildlifeCoords <- rasterCoords[which(!is.na(densityNotPA[])),][cells,]
data[which(PAcase==0 & !is.element(data$species,c("jackal","lion"))),c("x","y")] <- jitter(notPAnotWildlifeCoords@coords)

## Visual check
plot(regions)
points(data$x,data$y,col=match(data$species,species))



## Add density and region to dataframe
#---------------------------

data$density <- extract(density,data[,c("x","y")])
data$region <- over(SpatialPoints(data[,c("x","y")],regions@proj4string),regions)$Region_Nam



## Save data
#---------------------------

data_fns <- list.files(pattern="raw_data.csv", recursive=TRUE)
for(i in data_fns){
  write.csv(data, file=i,row.names = F)
}

