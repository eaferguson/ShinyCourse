#------------------------------------------------------------------------------#

# This script will install the packages required for the upcoming rShiny
# workshop on XXXX in Bagamoyo. A .html file will also be produced at the end
# of the scriot.

# Can you please send this .html file to ZZZ@YYY as soon as possible - this
# will check that some of the important packages have installed correctly.

# If you have any issues with this, please let us know immediately by emailing
# ZZZ@YYY.

# Please run this entire script by pressing:
# ctrl + a
# ctrl + enter

#------------------------------------------------------------------------------#

# UPDATE R VERSION

# Set vector of packages to be installed
packages <- c("shiny", "shinyWidgets", "shinydashboard", "leaflet", "RColorBrewer",
              "lubridate", "dplyr", "rgdal", "raster", "rmarkdown", "png", "kableExtra",
              "rgeos", "magrittr", "mapview")

# Install packages
install.packages(pkgs=packages, dependencies="Depends", quiet=TRUE)

# RENDER ASSOCIATED RMARKDOWN FILE
