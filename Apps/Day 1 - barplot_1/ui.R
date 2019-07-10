# ---------------------------------------------------------------------------- #
# Day 1 - barplot_1
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)

# Open the ui section
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploratory plots: Barplot"),

  # Add a line break
  br(),

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is only 1 widget: selectInput - a dropdown menu. This is set up to change the variable that is plotted on the x-axis."),

  # Add a line break
  br(),

  # Create a sidebar layout
  sidebarLayout(

    # Add content to the Sidebar
    sidebarPanel(

      # Add a dropdown menu
      selectInput(inputId="xaxis", # input id name
                  label = h3("Select the x-axis variable:"), # input title
                  choices = list("Sex" = "sex", "Species" = "species"), # choices that appear in the dropdown menu matched to the variable in the data
                  selected = 1) # number stating which of the choices starts as being selected

    ), # Close the sidebarPanel - remember the comma because the mainPanel is within this section

    # Add content to the main panel
    mainPanel(

      # Show plot
      plotOutput("barPlot", # output id name
                 height=700) # height in pixels of the plot

    ) # Close the mainPanel - no comma needed now as we are closing the section

  ) # Close the sidebarLayout

)) # Close the fluidPage and the ShinyUI
