# ---------------------------------------------------------------------------- #
# Day 1 - timeseries_1
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(RColorBrewer)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
#col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")
col_palette <- brewer.pal(name="Dark2", n=8)

# Collect list of years
raw_data$date <- as.Date(raw_data$date) # Change the structure of 'date' to a date
yrs <- c(unique(year(raw_data$date)), 2015) #Extract year and take only the unique years

plot_breaks = seq(from=0, to=12*length(yrs)-1, by=12)

# Summarise for 'all' data
overall_summary <- raw_data %>%
  group_by(month) %>%
  summarise(n = length(month)) %>%
  mutate(species="All Species")

# Summarise data by region
species_summary <- raw_data %>%
  group_by(month, species) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, species_summary)

#------------------------------------------------------------------------------#
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Subset for the chosen region
  data_subset <- reactive({
      data_sub = summary_data %>%
        filter(species==input$select_species | species=="All Species")
      as.data.frame(data_sub)
    })

  # Produce plot
  output$tsPlot <- renderPlot({
   ggplot() +
      geom_path(data=data_subset(), aes(x=month, y=n, color=species), size=1) +
      scale_color_manual(name="Species", values=col_palette) +
      labs(title=input$select_species, x="Date (Month)", y="Number of records") +
      # Extra plotting code to control appearence
      scale_x_continuous(breaks=plot_breaks, labels=yrs,
                         limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

})
