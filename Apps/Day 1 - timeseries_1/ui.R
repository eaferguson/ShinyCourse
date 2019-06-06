# ---------------------------------------------------------------------------- #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Collect a list of regions for the dropdown menu
options_list <- c("All Species", sort(unique(raw_data$species)))

#------------------------------------------------------------------------------#
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Timeseries"),

  # Add a line break
  br(),

  # Add text section
  h4("This app is a little more complicated than the first one."),
  h4("There is still only 1 widget (selectInput), but this time we are changing the species we want to view on the plot."),

  # Add a line break
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("select_species", label = h3("Select a Species:"),
                  choices = options_list,
                  selected = 1)

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("explPlot", height=700)
    )
  )

))
