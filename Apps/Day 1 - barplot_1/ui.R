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

  # Add text section
  h4("This app our first introduction to rShiny!"),
  h4("There is only 1 widget: selectInput - a dropdown menu. We have set this up to change the variable that is plotted on the x-axis."),

  # Add a line break
  br(),

  # Add content to the Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput(inputID="xaxis", # input id name
                  label = h3("Select the x-axis variable:"), # input title
                  choices = list("Sex" = "sex", "Species" = "species"), # choices that appear in the dropdown menu matched to the variable in the data
                  selected = 1) # number stating which of the choices starts as being selected

    ),

    # Add content to the main panel
    mainPanel(
      plotOutput("barPlot", # output id name
                 height=700) # height in pixels of the plot
    )
  )

))
