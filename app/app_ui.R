library("shiny")
library("plotly")
library("dplyr")
library("shinyWidgets")
library("shinythemes")

##### Introduction

df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

intro_page <- tabPanel(
  "Introduction",
  h1(strong("Introduction"), style = "font-family: 'Arial'; font-si13pt"),
  h3(strong("Overall Information")),
  p("Human emissions of carbon dioxide and other greenhouse gases are a major contributor to 
  climate change and one of the world's most important problems. This website shows the 
  data from \"Our World in Data\" that consists of different varibales about CO₂ emission. 
  Specifically, the analyzation in this website could be used to understand the trend of annual 
  consumption-based emissions of carbon dioxide (CO₂). ", 
    style = "font-size:18px;"),
  p("Obviously, the variable chosen for analyzation is annual consumption-based emissions of carbon 
    dioxide (CO₂) which is measured in kilograms per dollar of GDP. Consumption-based emissions are 
    national or regional emissions which have been adjusted for trade (i.e. territorial/production 
    emissions minus emissions embedded in exports, plus emissions embedded in imports) and year 1990 
    to 2018 since most of the data of consumption-based emissions of carbon dioxide is from 1990 to
    2018.", 
    style = "font-size:18px;"),
  h3(strong("Rough Analyzation")),
  p(textOutput("avg")),
  p(textOutput("max")),
  p(textOutput("change"))
)


interactive_sidebar <- sidebarPanel( 
  selectInput(
    inputId = "country",
    label = "Select a country",
    choices = unique(df$country),
    selected = "United States",
    multiple = TRUE
  ),
  
  sliderInput(
    "year",
    label = "Choose a range of year", 
    min = 1990, 
    max = 2018, 
    value = c(1990, 2018),
    step = 2,
    sep = ""
  )
)

interactive_main <- mainPanel(
  plotlyOutput(outputId = "line_chart")
)

interactive_page <- tabPanel(
  "Trend Analyzation",
  h1(strong("Consumption-based CO₂ Emissions Trend"), style = "font-si13pt"),
  p("This interactive line chart displays statistics on CO₂ emissions depending on 
    consumption from 1990 to 2018. You can examine and comprehend diverse countries or 
    regions as well as different years by typing or choosing from the searching bar. 
    The general trend in most nations is dropping with each passing year, 
    indicating that consumption-based CO₂ emissions are improving. However, consumption-based CO₂ 
    emissions have grown dramatically in some countries/areas, such as Mozambique. 
    This implies that, depending on the scenario, various countries and areas must 
    continue to minimize CO₂ emissions, and people must be cautious about CO₂ emssion.",
    style = "font-size:18px;"),
  sidebarLayout(
    interactive_sidebar,
    interactive_main
  )
)

ui <- navbarPage(
  "Analyzation on CO₂ Esmission",
  theme = shinythemes::shinytheme("flatly"),
  setBackgroundColor("#f8f8ff"),
  tags$style("#avg {font-size:18px;}"),
  tags$style("#max {font-size:18px;}"),
  tags$style("#change {font-size:18px;}"),
  intro_page,
  interactive_page
)