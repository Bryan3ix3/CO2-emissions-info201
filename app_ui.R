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
