#Script Implementation test for UI of Shiny app

library(shiny)
library(bslib)
library(ggplot2)
library(colourpicker)
library(shinyFiles)
library(shinycssloaders)

Ui <- 
title = "Dice Roll Simulator",
h3("Dice Roll Simulator"),
sidebarLayout(
  sidebarPanel(
    selectInput(
      "dice_type", 
      label = "Select Dice Type:", 
      choices = c("d4" = 4, "d6" = 6, "d8" = 8, "d10" = 10, "d12" = 12, "d20" = 20), 
      selected = 6
    ),
    numericInput(
      "num_dice", 
      label = "Number of Dice to Roll:", 
      value = 10, 
      min = 1
    ),
    actionButton("roll_button", "Roll the Dice"),
    h4("Customize Colors:"),
    uiOutput("color_inputs")
  ),
  mainPanel(
    h3("Result:"),
    withSpinner(textOutput("dice_roll"), type = 6),
    h3("Roll Distribution:"),
    withSpinner(plotOutput("dice_histogram"), type = 6)
  )
)