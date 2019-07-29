#------------------------------------------------------------------------------#
# Workshop: Data Visualisation using RShiny, Bagamoyo, August 2019
#------------------------------------------------------------------------------#

# This script will complete some preperation for the upcoming rShiny workshop
# in Bagamoyo. Please read the instructions carefully, and run the lines of
# code in each section of this script.

# Please run this line to set your working directory to where you have stored
# these files.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#------------------------------------------------------------------------------#
# Step 1: TELL US YOUR NAME AND EMAIL ADDRESS

# Please write your name and email address below, than run the lines to save
# to the 'environment':
your_name = ""
your_email_address = ""

#------------------------------------------------------------------------------#
# Step 2: UPDATE R VERSION

# Please run these lines of code to update your version of R. If asked whether
# you want to exit RStudio and run the installation from RGui, say "no".
# It will bring up an external dialog box, and begin installation.
install.packages("installr", quiet=TRUE)
installr::updateR(fast=TRUE)

# If your R version is up to date, the following message will print in the console:
# "No need to update. You are using the latest R version:
# R version 3.6.1 (2019-07-05)[1] FALSE"

# If an update is needed, "[1] TRUE" will appear in the console When complete.

# Please note, some of your old packages may not be copied accross, and these
# will need re-installing.

#------------------------------------------------------------------------------#
# Step 3: UPDATE R PACKAGES

# R packages are regularly updated by the developers, so it is important you
# have the most recent versions to prevent issues.

# Please run this line of code to update your existing packagaes
update.packages(checkBuilt=TRUE, ask=FALSE)

# If you are asked to use a personal library, say "No".

#------------------------------------------------------------------------------#
# Step 4: INSTALL RTOOLS

# Please click on this link (https://cran.r-project.org/bin/windows/Rtools/),
# download and install Rtools35.exe (recommended). This will help install
# R packages in the next step.

#------------------------------------------------------------------------------#
# Step 5: INSTALL NEW R PACKAGES

# For the R shiny workshop, there are a series of packages we need you to
# install.

# Please run the following lines of code to install the packages from this list
# that are not already installed on your computer.

# This is the packages that will be installed
list.of.packages <- c("dplyr", "ggplot2", "htmltools", "kableExtra", "knitr",
                      "leaflet", "lubridate", "magrittr", "mapview", "pillar",
                      "plotly", "png", "raster", "RColorBrewer", "rgdal", "rgeos",
                      "rlang", "rmarkdown", "sf", "shiny", "shinydashboard",
                      "shinyWidgets", "tidyverse", "vctrs", "Xmisc")

# Check if packages are already installed, and remove from the list if present
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Install packages
if(length(new.packages)) install.packages(new.packages, quiet=TRUE)

#------------------------------------------------------------------------------#
# Step 6: GENERATE REPORT TO CHECK PACKAGE INSTALLATION

# We have created a report that will check for us how the package installation
# has gone for you. The next line of code will generate a .html file called
# starterScript_report.html.

# This report is very important to us. It will be saved in the folder you have
# stored this report in.

# Please run this line of code to generate the .html file.
rmarkdown::render("starterScript_report.Rmd")

# Please send the .html file to rachel.steenson@glasgow.ac.uk

# If you have any issues with this, please let us know immediately by emailing
# rachel.steenson@glasgow.ac.uk
