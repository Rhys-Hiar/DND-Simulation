library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Character Sheet Viewer"),
  dashboardSidebar(
    fileInput("file", "Upload Character Sheet (CSV)", accept = ".csv"),
    uiOutput("stats_ui") # Dynamically rendered UI for stats
  ),
  dashboardBody(
    fluidRow(
      uiOutput("stats_display") # Dynamically rendered stat displays
    )
  )
)

server <- function(input, output, session) {
  # Reactively read the uploaded file
  character_sheet <- reactive({
    req(input$file)
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
  
  # Dynamically generate the UI for counter bars
  output$stats_ui <- renderUI({
    req(character_sheet())
    stats <- c("Strength", "Intelligence", "Wisdom", "Dexterity", "Willpower", "Constitution", "Charisma")
    
    # Generate numeric inputs for each stat
    lapply(stats, function(stat) {
      numericInput(
        inputId = paste0("stat_", stat),
        label = stat,
        value = character_sheet()[[stat]],
        min = 0, max = 100 # Adjust min/max as needed
      )
    })
  })
  
  # Display counter bars dynamically based on the uploaded file
  output$stats_display <- renderUI({
    req(character_sheet())
    stats <- c("Strength", "Intelligence", "Wisdom", "Dexterity", "Willpower", "Constitution", "Charisma")
    
    # Generate progress bars for each stat
    lapply(stats, function(stat) {
      value <- input[[paste0("stat_", stat)]] %||% character_sheet()[[stat]]
      tagList(
        tags$h4(stat),
        tags$div(
          class = "progress",
          style = "height: 25px;",
          tags$div(
            class = "progress-bar",
            role = "progressbar",
            style = paste0("width: ", value, "%;"),
            value, "%"
          )
        )
      )
    })
  })
}

shinyApp(ui, server)
