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
options_list <- c("All Regions", sort(unique(raw_data$region)))

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Timeseries"),

  # Add a line break
  br(),

  # Add text section
  h4("This app is identical to the last, with a new widget: checkboxGroupInput"),
  h4("Using these widgets, we can change the region and the sex we want to view on the plot. The line showing 'all data' will always be visible!"),

  # Add a line break
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      # Add a dropdown menu widget
      selectInput("select_region", label = h3("Select a Region:"),
                  choices = options_list,
                  selected = 1),
      br(),

      # Add a checkbox widget
      checkboxGroupInput("select_sex", label = h3("Select a sex"),
                         choices = list("Male" = "M", "Female" = "F"),
                         selected = c("M", "F"))

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("explPlot", height=700)
    )
  )

))
