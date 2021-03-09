
library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)
library(Rfast)
library(lintr)
library(styler)
style_file("analysis.R")
lint("analysis.R")
#source('./scripts/build_scatter.R')

df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

#5 relevant values of interest

#location with highest co2 emission per capita
location_highest_cap <- df %>% 
    filter(co2_per_capita == max(co2_per_capita, na.rm = T)) %>% 
    pull(country)
#location with the fastest growing co2 emission percentage (yearly)
location_highest_co2Growth_pct <- df %>% 
    filter(co2_growth_prct == max(co2_growth_prct, na.rm = T)) %>% 
    pull(country)
#average cumulative co2
avg_cum_co2 <- mean(df$cumulative_co2, na.rm = T) 
#how many locations are above the average cumulative co2 emission?
num_location_abvAvg <- df %>% 
    filter(cumulative_co2 > avg_cum_co2) %>% 
    nrow()

#location with the lowest deviation from average. I.e., closest to average.
lowest_devi <- df %>% 
    select(country, cumulative_co2) %>% 
    filter(cumulative_co2 > avg_cum_co2) %>% 
    mutate(deviation = cumulative_co2 - avg_cum_co2) %>% 
    filter(deviation == min(deviation, na.rm = T)) %>% 
    pull(country)

server <- function(input, output) {
    output$text <- renderText({
        return(paste("For this project, I've decided to analyze the following
                      variables: 1) The location with the highest average per 
                      capita CO2 emissions, measured in tonnes per year. This
                      interested me because I didn't want to ignore the respons
                      ibility we all share, as individuals, to do better when it
                      somes to CO2 emisions. This value show the location where,
                      on average, individuals emit the most CO2: ", 
                     location_highest_cap,"."))
    })
    output$text_two <- renderText({
        return(paste("2) For the second variable, I decided to explore what 
                     country/location had the fastest growing emission and see 
                     if it corresponded with the previously evaluated variable. 
                     Interestingly, it didn't. The location with the fastest 
                     growing CO2 emissions per year is: ", 
                     location_highest_co2Growth_pct,"."))
   
    })
    output$text_three <- renderText({
        return(paste("3) The third variable explored the average cumulative 
                     emissions of CO2 from 1751 through to the given year, 
                     measured in million tonnes. This value was useful for 
                     calculating posterior values. The average is: ", 
                     avg_cum_co2,"."))
    }) 
    output$text_four <- renderText({
        return(paste("4) The fourth variable simply was a calculation of how 
                     many countries/locations had cumulative CO2 emissions above 
                     the average. This was just to get an idea of how big the 
                     number of outstanding CO2-negligent countries was, was it 
                     just a small faction of the countries who exceeded the 
                     average, or a wide-spread tendency? In total, the number 
                     was: ", num_location_abvAvg,"."))
    })
    output$text_five <- renderText({
        return(paste("5) The fifth variable was calculated with the goal of 
                     finding the country/location that was closest to the 
                     average. The previous variables were made to the get an 
                     idea of how critical the CO2 problem was, for this last 
                     varaible, I wanted to add a slightly more positive note. 
                     The location in question turned out to be: ", 
                     lowest_devi,"."))
    
    })
    output$text_chart <- renderText({
        return(paste("This chart graphically represents which country had the
                    most emissions in a given year, and how each country/
                    location fares in relation to
                    other locations. It also shows what industry was responsible 
                    for emitting the most CO2 in that year. I created this chart
                    because I wanted to visualize CO2 trends in the most recent
                    years and countries. The result, the CO2 emissions barely 
                    change from year to year, the industry stays the same and
                     most influential locations don't change either."))
        
    })
    #output$scatter <- renderPlotly({
       # return(build_scatter(df, input$search))
    #})
    
    output$bar_chart <- renderPlotly({
        yr <- "2013"
        
        new_df <- df %>% 
            #select(cement_co2, coal_co2, flaring_co2, gas_co2, oil_co2, 
            #other_industry_co2) %>% 
            select(cement_co2, other_industry_co2) %>% 
            data.matrix() %>% 
            rowMaxs(value = F) %>%
            as.data.frame() %>% 
            mutate(year = df$year) 
        colnames(new_df)<- c("row", "year")
        df <- mutate(df, rows = new_df$row) %>% 
            mutate(industry = if_else(rows ==  1, "Cement", "other"))
        
        chart_data <- df %>% 
            filter(year == input$year_in) %>% 
            top_n(10, co2)
        
        my_plot <- ggplot(chart_data, aes(x = country, y = co2)) +
            geom_col(aes(fill = industry)) +
            labs(x = "Country", title = paste0("CO2 emissions by country in ", 
                                               yr), 
                 y = "CO2 emissions (mil. tonnes)") + 
            scale_fill_discrete(name = "Industry most emissions") +
            scale_fill_manual(values = input$color)
        ggplotly(my_plot)
    })
    
}
