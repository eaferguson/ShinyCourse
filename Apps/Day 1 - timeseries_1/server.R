# ---------------------------------------------------------------------------- #
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a column to give
# Collect a list of regions for the dropdown menu
regions_list <- c("All", sort(unique(raw_data$region)))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Create a colour palette
  col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")

  # Collect list of years
  yrs <- sort(unique(substr(raw_data$date, 1, 4)))
  plot_breaks = seq(from=0, to=12*length(yrs)-1, by=12)

  # Summarise for 'all' data
  month_summary <- raw_data %>%
    group_by(month) %>%
    summarise(n = length(month)) %>%
    mutate(region="All Regions")

  # Subset for the chosen region
  region_subset <- reactive({
    # If "All" is selected, use month_summary dataframe
    if(input$select_region=="All"){
      month_summary
    } else {
      # otherwise, subset data using input region
      region_sub = raw_data %>%
        filter(region==input$select_region) %>%
        group_by(month) %>%
        summarise(n = length(month)) %>%
        mutate(region=input$select_region)
      as.data.frame(region_sub)
    }
  })

  # Produce plot
  output$explPlot <- renderPlot({
   ggplot() +
      geom_line(data=region_subset(), aes(x=month, y=n), color=col_palette[1], size=1.5) +
      ggtitle(paste0(input$select_region, "\n")) +
      labs(x="\nMonth", y="Number of records\n") +
      scale_x_continuous(breaks=plot_breaks, labels=yrs,
                         limits=c(min(month_summary$month), max(month_summary$month))) +
      scale_y_continuous(limits=c(min(month_summary$month), max(month_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20, color=col_palette[1]))
  })

})
