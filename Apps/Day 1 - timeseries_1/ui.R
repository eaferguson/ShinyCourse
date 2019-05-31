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
regions_list <- c("All", sort(unique(raw_data$region)))

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Timeseries"),

  # Add a line break
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("select_region", label = h3("Select a Region:"),
                  choices = regions_list,
                  selected = 1)

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("explPlot")
    )
  )

))
