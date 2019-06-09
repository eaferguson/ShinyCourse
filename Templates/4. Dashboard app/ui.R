# ---------------------------------------------------------------------------- #
#                            DASHBOARD LAYOUT TEMPLATE                         #
#                                                                              #
# This is the user-interface definition of a Shiny web application. You can    #
# run the application by clicking 'Run App' above.                             #
# ---------------------------------------------------------------------------- #

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(

  dashboardHeader(
    title="page title"
    ),

  dashboardSidebar(
    "sidebar content"
  ),

  dashboardBody(
    fluidRow(
      "body content"
    )
  )

))
