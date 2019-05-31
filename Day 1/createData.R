
rm(list=ls(all=TRUE))
setwd("D:/Dropbox/ShinyCourse/Day 1")

library(rgdal)
library(lubridate)

set.seed(0)


## Read in datasets
#--------------------------

## Tanzania regions shapefile
regions <- readOGR("data/Tz_Region_2012","TZ_Region_2012")
regions <- spTransform(regions,CRS("+proj=utm +zone=37 +south +ellps=clrk80 +towgs84=-160,-6,-302,0,0,0,0 +units=m +no_defs"))
plot(regions)



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



## Get date for each case
#---------------------------

## Create data frame with month variable
data <- data.frame("month"=rep(1:months,casesMonth))

## Pick a random date within the month for each data point
data$date <- as.Date(NA)
for(i in 1:months){
  daysMonth <- seq(startDate %m+% months(i-1),startDate %m+% months(i)-1,by="day")
  data$date[which(data$month==i)] <- sort(sample(daysMonth,casesMonth[i]))
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
data$age <- runif(nrow(data),0,maxAgeSpecies[match(data$species,species)])



## Generate a random location for each case
#---------------------------

locs <- spsample(regions,nrow(data),type="random")
# plot(regions)
# plot(locs,add=T,col=match(data$species,species))



