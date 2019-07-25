# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4d   timeseries_1
# This is the ui script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Collect a list of species for the dropdown menu
species_list <- c("All Species", sort(unique(raw_data$species)))

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Day 1 - Timeseries_1"),

  # Add a line break
  br(),

  # Add text section
  h4("This app is a little more complicated than the first one."),
  h4("There is still only 1 dropdown menu, but this time we are changing the species we want to view on the plot."),

  # Add a line break
  br(),

  # Add a sidebarLayout
  sidebarLayout(
    sidebarPanel(
      selectInput("select_species", label = h3("Select a Species:"),
                  choices = species_list,
                  selected = 1)

    ),

    # Show plot
    mainPanel(
      plotOutput("tsPlot", height=700)
    )
  )

))
