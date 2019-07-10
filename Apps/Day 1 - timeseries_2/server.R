# ---------------------------------------------------------------------------- #
# Day 1 - timeseries_2
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
# ---------------------------------------------------------------------------- #

# Load in libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(lubridate)

# Load in the raw data
raw_data <- read.csv("data/raw_data.csv", stringsAsFactors=FALSE)

# Create a colour palette
#col_palette <- c("#231D51", "#178B8B", "#63C963", "#FFE31D")
col_palette <- brewer.pal(name="Dark2", n=8)

# Collect list of years
raw_data$date <- as.Date(raw_data$date) # Change the structure of 'date' to a date
yrs <- c(unique(year(raw_data$date)), 2015) #Extract year and take only the unique years

# Set plot breaks
plot_breaks = seq(from=0, to=12*length(yrs)-1, by=12)

# Summarise for 'all' data - this will always be plotted
overall_summary <- raw_data %>%
  group_by(month) %>%
  summarise(n = length(month)) %>%
  mutate(region="All data",
         sex="All data")

# Summarise for 'all' sexes, divided by region data
region_allsexes_summary <- raw_data %>%
  group_by(month, region) %>%
  summarise(n = length(month)) %>%
  mutate(sex="Both sexes")

# Summarise for 'all' region, divided by sex data
sex_allregions_summary <- raw_data %>%
  group_by(month, sex) %>%
  summarise(n = length(month)) %>%
  mutate(region="All Regions")

# Summarise region and sex data
region_sexes_summary <- raw_data %>%
  group_by(month, region, sex) %>%
  summarise(n = length(month))

# Join summary data together
summary_data <- bind_rows(overall_summary, region_allsexes_summary, sex_allregions_summary, region_sexes_summary)

#------------------------------------------------------------------------------#
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Subset for the chosen region and sexes
  data_subset <- reactive({

    # Subset for region
    data_sub = summary_data %>%
      filter(region==input$select_region | region=="All data")

    # Subset for sex
    if(length(input$select_sex)>0){
      data_sub = data_sub %>%
        filter(sex %in% input$select_sex | sex=="Both sexes" | sex=="All data")
    } else {
      data_sub = data_sub %>%
        filter(sex=="Both sexes" | sex=="All data")
    }

    # Summarise data using subsets created above
    data_sub = data_sub %>%
      group_by(month, region, sex) %>%
      summarise(n = sum(n))
    as.data.frame(data_sub)
  })

  # Produce plot
  output$tsPlot <- renderPlot({
   ggplot() +
      geom_path(data=data_subset(), aes(x=month, y=n, color=sex), size=1) +
      scale_color_manual(name="Sex", values=col_palette) +
      labs(title=input$select_region, x="Date (Month)", y="Number of records") +
      scale_x_continuous(breaks=plot_breaks, labels=yrs, limits=c(min(overall_summary$month), max(overall_summary$month))) +
      scale_y_continuous(limits=c(min(overall_summary$month), max(overall_summary$month))) +
      theme_classic() +
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size=18),
            plot.title = element_text(size=20),
            legend.title = element_text(size=18),
            legend.text = element_text(size=14))
  })

})
