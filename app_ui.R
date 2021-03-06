library(shiny)


intro_panel <- tabPanel(
    "Introduction",
    titlePanel("Values of interest"),
    textOutput("text"),
    textOutput("text_two"),
    textOutput("text_three"),
    textOutput("text_four"),
    textOutput("text_five")
)


bChart_sidebar_content <- sidebarPanel(
    year_input <- selectInput(
        "year_in",
        label = "Year",
        choices = tail(df$year),
        selected = "yr"
    ),
    color_input <- selectInput(
        "color",
        label = "Color",
        choices = list("Green" = "#669933", "Yellow" = "#FFCC66",
                       "Cyan" = "#00FFFF", "Magenta" = "#FF00FF", 
                       "Blue Bell" = "#A5A3C1", "Desire" = "#EA3C53")
    )
)

bChart_main_content <- mainPanel(
    #textInput("search", label = "Find a State", value = "")
    plotlyOutput("bar_chart"),
    textOutput("text_chart")
)
bChart_panel <- tabPanel(
    "Chart",
    sidebarLayout(
        # Display `scatter_sidebar_content`
        bChart_sidebar_content,
        
        # Display  `scatter_main_content`
        bChart_main_content
    )
 
)


ui <- navbarPage(
    "CO2 Emisssions Analysis",
    intro_panel,
    bChart_panel
)
