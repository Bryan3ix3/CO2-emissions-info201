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

scatter_sidebar_content <- sidebarPanel(
    textInput("search", label = "Find a State", value = "")
)

scatter_main_content <- mainPanel(
    textInput("search", label = "Find a State", value = "")
    #plotlyOutput("scatter")
)
scatter_panel <- tabPanel(
    "Chart",
    sidebarLayout(
    # Display `scatter_sidebar_content`
    scatter_sidebar_content,
    
    # Display  `scatter_main_content`
    scatter_main_content
    )
 
)


ui <- navbarPage(
    "CO2 Emisssions Analysis",
    intro_panel,
    scatter_panel
)
