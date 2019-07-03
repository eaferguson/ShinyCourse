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

# Set vector of packages to be installed
packages <- c("htmltools", "shiny", "shinyWidgets", "shinydashboard", "leaflet", "RColorBrewer",
              "lubridate", "dplyr", "rgdal", "raster", "rmarkdown", "png", "kableExtra",
              "rgeos", "magrittr", "mapview", "ggplot2",
              "Xmisc")

# Install packages
install.packages(pkgs=packages, dependencies="Depends", quiet=TRUE)

# RENDER ASSOCIATED RMARKDOWN FILE
rmarkdown::render("starterScript_report.Rmd")
