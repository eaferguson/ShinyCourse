# ---------------------------------------------------------------------------- #
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

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("xaxis", label = h3("Select the x-axis variable:"),
                  choices = list("Gender" = "sex", "Species" = "species"),
                  selected = 1)

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("explPlot")
    )
  )

))
