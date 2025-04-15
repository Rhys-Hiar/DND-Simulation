library(shiny)
library(bslib)
library(ggplot2)
library(colourpicker)
library(shinyFiles)
library(shinycssloaders)
# Source external page scripts
source("Rolling Dice.R", local = TRUE)
source("Random Encounters.R", local = TRUE)
source("Spell List Viewer Test.R", local = TRUE)

# Main UI
ui <- page_navbar(
  title = "Shiny App",
  nav_panel("Dice Roll Simulator", dice_roll_ui),
  nav_panel("Random Encounter Tables", random_encounter_ui),
  nav_panel("Spell List Viewer", spell_list_ui)
)

# Main Server
server <- function(input, output, session) {
  callModule(dice_roll_server, "dice_roll")
  callModule(random_encounter_server, "random_encounter")
  callModule(spell_list_server, "spell_list")
}

# Run App
shinyApp(ui, server)
