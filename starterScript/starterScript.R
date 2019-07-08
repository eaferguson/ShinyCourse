#------------------------------------------------------------------------------#

# Please write your name and email address below:
your_name = "Rachel S"
your_email_address = "rachel.steenson@glasgow.ac.uk"

# This script will install the packages required for the upcoming rShiny
# workshop on XXXX in Bagamoyo.

# A .html file called starterScript_report.html will also be produced at the
# end of the script.
# Can you please send the .html file to rachel.steenson@glasgow.ac.uk as soon
# as possible - this will check that some of the important packages have
# installed correctly.

# If you have any issues with this, please let us know immediately by emailing
# rachel.steenson@glasgow.ac.uk

# Please set your working directory to where you have stored these files, and
# run this entire script by pressing:
# ctrl + a
# then
# ctrl + enter

#------------------------------------------------------------------------------#

# UPDATE R VERSION

# Update existing packagaes
update.packages(checkBuilt=TRUE, ask=FALSE)

# Set vector of packages to be installed
list.of.packages <- c("dplyr", "shiny", "shinyWidgets", "shinydashboard", "leaflet", "RColorBrewer",
                      "lubridate", "htmltools", "rgdal", "raster", "rmarkdown", "png", "kableExtra",
                      "rgeos", "magrittr", "mapview", "ggplot2",
                      "Xmisc", "pillar", "vcts", "sf", "knitr")

# Check if packages are already installed - if yes, remove from list
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Install packages
if(length(new.packages)) install.packages(new.packages)

# RENDER ASSOCIATED RMARKDOWN FILE
rmarkdown::render("starterScript_report.Rmd")
