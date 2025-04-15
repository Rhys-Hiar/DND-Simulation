library(shiny)
library(bslib)
library(ggplot2)
library(colourpicker)
library(shinyFiles)
library(shinycssloaders)

#Random Encounter Tables File
random_encounter_ui <- fluidPage(
  titlePanel("Random Encounter Tables"),
  sidebarLayout(
    sidebarPanel(
      fileInput("encounter_table", "Upload Encounter Table (CSV)", accept = ".csv"),
      actionButton("roll_encounter", "Roll Encounter")
    ),
    mainPanel(
      textOutput("encounter_result")
    )
  )
)

random_encounter_server <- function(input, output, session) {
  encounter_data <- reactive({
    req(input$encounter_table)
    read.csv(input$encounter_table$datapath)
  })
  
  observeEvent(input$roll_encounter, {
    table <- encounter_data()
    dice_roll <- sample(1:100, 1)  # Simulate a d100 roll
    match <- table[table$DiceRollRange == dice_roll, ]
    
    output$encounter_result <- renderText({
      if (nrow(match) > 0) {
        paste("You rolled:", dice_roll, "- Result:", match$Encounter[1])
      } else {
        paste("You rolled:", dice_roll, "- No match found in the table.")
      }
    })
  })
}

shinyApp(random_encounter_ui, random_encounter_server)
