# ---------------------------------------------------------------------------- #
# Day 1 - barplot_1
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in the libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Load in the data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
col_palette <- brewer.pal(name="Dark2", n=8)

#------------------------------------------------------------------------------#
# Open the shiny section
shinyServer(function(input, output) {

  # Produce plot
  output$barPlot <- renderPlot({
    ggplot() +
      geom_bar(data=raw_data, # set the dataset used
               aes(x=raw_data[[input$xaxis]]), # use the input from the ui to give the column name for the x-axis
               fill=col_palette[1]) + # use the first colour from the colour palette
      labs(x=paste0(input$xaxis), y="Number of records") + # Set the axis labels
      theme_classic() + # use a simple theme (no gridlines)
      theme(axis.text = element_text(size=14), # make all plot text bigger (axes, titles, labels)
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))

    }) # Close the renderPlot

}) # Close the shinyServer
