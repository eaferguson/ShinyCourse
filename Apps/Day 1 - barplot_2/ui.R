# ---------------------------------------------------------------------------- #
# ACTIVITY 1.4c   barplot_2
# This is the ui script for a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

#------------------------------------------------------------------------------#
# Begin ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Day 1 - Barplot_2"),

  # Add a line break
  br(),

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is still only 1 widget - a dropdown menu - but there is now a text output below."),

  # Add a line break
  br(),

  # Add sidebar layout
  sidebarLayout(
    sidebarPanel(

      # Add a dropdown menu
      selectInput("xaxis", label = h3("Select the x-axis variable:"),
                  choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                  selected = 1),
      br(),

      # Add a text output
      verbatimTextOutput("output_text")

    ),

    # Show plot
    mainPanel(
      plotOutput("barPlot", height=700)
    )
  )

))
