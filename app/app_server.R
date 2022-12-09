library("stringr")
library("dplyr")
library("ggplot2")
library("plotly")

df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

server <- function(input, output) {
  # First Page
  output$avg <- renderText({
    avg <- df %>% 
      filter(year == 2000) %>% 
      summarize(avg = round(mean(consumption_co2_per_gdp, na.rm = T), digits = 2))
    text_avg <- paste0("  ",
                       "The average is an important number for understanding the characteristics of a 
                        set of numbers. Once we calculate the average, we can compare different values 
                        of the same set of numbers with the average to get different meanings of the 
                        different values. For the carbon dioxide data in this project, the average 
                        calculated for annual consumption-based emissions of carbon dioxide in the year 2000  is ", 
                       avg, 
                       " kilograms per dollar.")
    return(text_avg)
  })
  
  output$max <- renderText({
    max <- df %>% 
      filter(consumption_co2_per_gdp == max(consumption_co2_per_gdp, na.rm = T)) %>%
      select(country)
    text_max <- paste0("The countries where the extremes occur can help us to better analyze the CO₂ emissions of 
                       different countries. Different countries have different annual consumption-based emissions of carbon 
                       dioxide, and in this project, we have calculated that ",
                       max,
                       " has reached the highest value on record. This will help to understand the CO₂ 
                       situation in different countries.")
    return(text_max)
  })
  
  output$change <- renderText({
    change_data <- df %>% 
      group_by(year) %>%
      select(year, consumption_co2_per_gdp)
    
    change_data_df <- aggregate(
      change_data$consumption_co2_per_gdp,
      list(change_data$year),
      sum,
      na.rm = T)
    
    value_start <- change_data_df %>%
      filter(Group.1 == 1990) %>%
      pull()
    
    value_end <- change_data_df %>%
      filter(Group.1 == 2018) %>%
      pull()
    
    change <- round((value_end - value_start) / value_start * 100, digits = 2)
    
    change_text <- paste0("For understanding the trend of CO₂ emission and the selected variables, we can 
                            first calculate how annual consumption-based emissions of carbon dioxide have 
                            changed over time to get a rough understanding of it. Since there is not enough 
                            data for some years, I calculated the data from 1990 to 2018. According to the 
                            calculation, the change of annual consumption-based emissions of carbon 
                            dioxide is ",
                          change,
                          "%",
                          ". This indicates that, roughly speaking, annual consumption-based CO₂ emissions 
                            are declining.")
    
    return(change_text)
  })
  
  
  
  # Second Page
  output$line_chart <- renderPlotly({
    line_data<- reactive({
      df %>% filter(
        country == input$country,
        year >= input$year[1],
        year <= input$year[2])
    })
    
    ggplot(line_data(), aes(x = year, y = consumption_co2_per_gdp, color = country)) +
      geom_line() + 
      theme_bw() +
      xlab("Year") +
      ylab("Amount") +
      labs(title = "The Amount of Consumption-based CO₂ Emissions (1990-2018)")
  })
}
