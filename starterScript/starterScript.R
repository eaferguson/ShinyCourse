#------------------------------------------------------------------------------#

# This script will complete some preperation for the upcoming rShiny workshop
# on XXXX in Bagamoyo. Please read the instructions carefully, and run the
# lines of code in each section of this script.

# Please set your working directory to where you have stored these files.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#------------------------------------------------------------------------------#
# Step 1: TELL US YOUR NAME AND EMAIL ADDRESS

# Please write your name and email address below, than run the lines to save
# to the 'environment':
your_name = "Rachel S"
your_email_address = "rachel.steenson@glasgow.ac.uk"

#------------------------------------------------------------------------------#
# Step 2: UPDATE R VERSION

# Please run this line of code to update your version of R. If asked whether
# you want to exit RStudio and run the installation from RGui, say "no".
# It will bring up an external dialog box, and begin installation.
updateR(fast=TRUE)

# When complete, "[1] TRUE" will appear in the console.

#------------------------------------------------------------------------------#
# Step 3: UPDATE R PACKAGES

# R packages are regularly updated by the developers, so it is important you
# have the most updated versions to prevent issues.

# Please run this line of code to update your existing packagaes
update.packages(checkBuilt=TRUE, ask=FALSE)

#------------------------------------------------------------------------------#
# Step 4: INSTALL NEW R PACKAGES

# For the R shiny workshop, there are a series of packages we need you to
# install.

# Please run the following lines of code to install the packages from this list
# that are not already installed on your computer.

# Set vector of packages to be installed
list.of.packages <- c("dplyr", "shiny", "shinyWidgets", "shinydashboard", "leaflet", "RColorBrewer",
                      "lubridate", "htmltools", "rgdal", "raster", "rmarkdown", "png", "kableExtra",
                      "rgeos", "magrittr", "mapview", "ggplot2",
                      "pillar", "sf", "knitr")

# Check if packages are already installed - if yes, remove from list
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Install packages
if(length(new.packages)) install.packages(new.packages)

#------------------------------------------------------------------------------#
# Step 5: GENERATE REPORT TO CHECK PACKAGE INSTALLATION

# We have created a report that will check for us how the package installation
# has gone for you. The next line of code will generate a .html file called
# starterScript_report.html.

# This report is very important to us. It will be saved in the folder you have
# saved this report in.

# Please run this line of code to generate the .html file.
rmarkdown::render("starterScript_report.Rmd")

# Please send the .html file to rachel.steenson@glasgow.ac.uk.

# If you have any issues with this, please let us know immediately by emailing
# rachel.steenson@glasgow.ac.uk
