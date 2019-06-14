# ---------------------------------------------------------------------------- #
# Day 1 - barplot_2 Master App
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Barplot"),

  # Add a line break
  br(),

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is only 1 widget: selectInput - a dropdown menu. We have set this up to change the variable that is plotted on the x-axis."),

  # Add a line break
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      # Add a dropdown menu
      selectInput("xaxis", label = h3("Select the x-axis variable:"),
                  choices = list("Sex" = "sex", "Species" = "species", "Age" = "age"),
                  selected = 1),
      br(),

      # Add a text output
      verbatimTextOutput("output_text"),
      br(),

      # Add another text output
      verbatimTextOutput("output_values")

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("barPlot", height=700)
    )
  )

))
